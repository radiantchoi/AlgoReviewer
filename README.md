# Blind 75 Logs

* 하루 1문제씩 꾸준히 알고리즘 문제를 풀고 기록하는 저장소입니다.

## 🚀 How to Use (초기 세팅)

이 저장소를 처음 클론받은 후, 자동 리뷰 환경을 구성하기 위해 다음 과정을 수행합니다.
*(uv 패키지 매니저가 설치되어 있어야 합니다.)*

### 1. 환경 변수 설정

* `.reviewer` 디렉토리 내에 `.env` 파일을 생성합니다.
* 아래와 같이 사용할 LLM 프로바이더와 API 키를 입력합니다. (현재 Gemini 기본 지원, 향후 로컬 LLM 전환 상정)

```
LLM_PROVIDER=gemini
GEMINI_API_KEY=당신의_API_키
```

* *참고: 의존성 패키지는 `uv.lock`에 기록되어 있어 별도의 패키지 설치 명령어(`uv add ...`) 없이 훅 실행 시 자동 적용됩니다.*

### 2. Git Hook 활성화

* 프로젝트 루트 디렉토리에서 아래 명령어를 실행하여 훅 스크립트를 복사하고 실행 권한을 부여합니다.

```
cp scripts/post-commit.sh .git/hooks/post-commit
chmod +x .git/hooks/post-commit
```

## 📝 자동 리뷰 파이프라인 사용법

### 1. 문제 풀이 및 파일 생성

* `submission` 디렉토리 내에 풀이 코드를 작성합니다.
* **(중요)** 지원되는 언어(`Swift`, `Python`, `TypeScript`)의 파일 확장자에 맞게 생성하고, **파일의 첫 번째 줄에는 반드시 문제 정보를 주석으로 작성**해야 합니다.
* Swift / TypeScript 예시: `// LeetCode No.347 Top K Frequent Elements`
* Python 예시: `# LeetCode No.347 Top K Frequent Elements`



### 2. 커밋 생성 (트리거)

* CLI 환경에서 푼 문제를 커밋할 때, 커밋 메시지 앞에 `solve:` 접두어를 붙입니다.

```
git add submission/파일명
git commit -m "solve: LeetCode No.347 Top K Frequent Elements"
```

### 3. 자동 리뷰 및 커밋

* 커밋이 완료되는 즉시 백그라운드에서 LLM 리뷰 시스템이 동작합니다.
* 시간/공간 복잡도, 정석 풀이, 개선점, 언어적 관용구 준수 여부를 분석합니다.
* 결과는 `review` 디렉토리에 마크다운 파일(`.md`)로 저장되며, `review: 문제 정보 코드 리뷰`라는 메시지와 함께 자동으로 후속 커밋됩니다.
* *주의: GUI Git 클라이언트(SourceTree, GitHub Desktop 등)에서는 환경 변수 문제로 훅이 동작하지 않을 수 있으므로 CLI 환경 사용을 권장합니다.*