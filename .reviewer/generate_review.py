import os
import re
import sys
from abc import ABC, abstractmethod
from datetime import datetime

from dotenv import load_dotenv

load_dotenv()


class Reviewer(ABC):
    @abstractmethod
    def generate_review(self, prompt: str, code: str) -> str:
        pass


class GeminiReviewer(Reviewer):
    def __init__(self):
        from google import genai

        self.client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

    def generate_review(self, prompt: str, code: str) -> str:
        full_text = f"{prompt}\n\n코드:\n```\n{code}\n```"
        response = self.client.models.generate_content(
            model="gemini-3.1-flash-lite", contents=full_text
        )
        return response.text if response.text else "No Review Generated"


def get_reviewer() -> Reviewer:
    provider = os.getenv("LLM_PROVIDER", "gemini").lower()

    if provider == "gemini":
        return GeminiReviewer()

    return GeminiReviewer()


def extract_problem_info(code_content: str, ext: str) -> str:
    first_line = code_content.strip().split("\n")[0]

    if (ext == ".swift" or ext == ".ts") and first_line.startswith("//"):
        return first_line.replace("//", "").strip()
    elif ext == ".py" and first_line.startswith("#"):
        return first_line.replace("#", "").strip()

    return "Unknown Problem Occurred"


def extract_language(ext: str) -> str:
    if ext == ".swift":
        return "Swift"
    elif ext == ".py":
        return "Python"
    elif ext == ".ts":
        return "TypeScript"
    else:
        return "Unknown Language"


def sanitize_filename(name: str) -> str:
    clean_name = re.sub(r"[^\w\s-]", "", name).strip()
    return re.sub(r"[-\s]+", "_", clean_name)


def main():
    if len(sys.argv) < 2:
        print("Usage: uv run generate_review.py <file_path>")
        sys.exit(1)

    file_path = sys.argv[1]
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        sys.exit(1)

    with open(file_path, "r", encoding="utf-8") as f:
        code_content = f.read()

    _, ext = os.path.splitext(file_path)
    language = extract_language(ext)
    problem_info = extract_problem_info(code_content, ext)
    sanitized_info = sanitize_filename(problem_info)

    prompt = f"""
    당신은 시니어 알고리즘 코드 리뷰어입니다.
    다음 {language}로 작성된 알고리즘 문제('{problem_info}') 풀이 코드를 리뷰해 주세요.

    리뷰 기준:
    1. 시간 복잡도 (Big-O 분석 및 최적화 가능성)
    2. 공간 복잡도
    3. 보편적인 "정석" 풀이 방법 (DP, 그래프 등 문제 유형에 맞는 접근법)
    4. 현재 풀이의 적절성과 개선 가능한 부분 (엣지 케이스 포함)
    5. {language}의 언어적 특성(Idiomatic Code)을 잘 살렸는지 준수 여부

    결과는 마크다운 형식으로 작성해 주세요.
    """

    print(
        f"[{problem_info}] 코드 리뷰를 생성 중입니다... (LLM: {os.getenv('LLM_PROVIDER')})"
    )

    reviewer = get_reviewer()
    review_result = reviewer.generate_review(prompt, code_content)

    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    review_dir = os.path.join(base_dir, "review")
    os.makedirs(review_dir, exist_ok=True)

    date_str = datetime.now().strftime("%Y%m%d")
    filename = f"{sanitized_info}_{language}_{date_str}.md"
    save_path = os.path.join(review_dir, filename)

    with open(save_path, "w", encoding="utf-8") as f:
        f.write(f"# {problem_info} Code Review\n\n")
        f.write(review_result)

    print(f"리뷰 파일이 성공적으로 생성되었습니다: {save_path}")


if __name__ == "__main__":
    main()
