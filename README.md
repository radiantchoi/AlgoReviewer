# Blind 75 Logs

* 하루 1문제씩 꾸준히 알고리즘 문제를 풀고 기록하는 저장소입니다.

## 🚀 How to Use (초기 세팅)

이 저장소를 처음 클론받은 후, 자동 리뷰 환경을 구성하기 위해 다음 과정을 수행합니다.
*(uv 패키지 매니저가 설치되어 있어야 합니다.)*

### 1. 환경 변수 설정

* `.reviewer` 디렉토리 내에 `.env` 파일을 생성합니다.
* 사용할 리뷰어를 `.reviewer/.env`의 `LLM_PROVIDER`에 지정합니다. 지원 값은 `local`과 `opencode`입니다.

#### Local (oMLX)
oMLX 서버를 8808 포트로 구동한 후 아래와 같이 설정합니다.
```env
LLM_PROVIDER=local
OMLX_API_URL=http://127.0.0.1:8808/v1/chat/completions
OMLX_MODEL=oMLX에_등록된_모델_ID
OMLX_API_KEY=당신의_oMLX_API_키
```

* `OMLX_API_KEY`는 필수이며 HTTP `Authorization: Bearer` 헤더로 전달됩니다.

#### OpenCode (ChatGPT Plus/Pro OAuth)
OpenCode를 설치한 뒤 로그인합니다. OpenCode에서 `/connect`를 실행하고 `OpenAI`와 `ChatGPT Plus/Pro`를 선택해 브라우저 인증을 완료합니다. 사용 가능한 모델 ID를 확인해 아래 설정에 지정합니다.
```env
LLM_PROVIDER=opencode
OPENCODE_MODEL=openai/gpt-6-luna#high
```
* 리뷰 훅은 로그인된 OpenCode CLI를 비대화식으로 실행하므로, `opencode` 명령이 `PATH`에 있어야 합니다.

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
* 리뷰 생성이 실패하거나 오류 메시지만 반환되면 리뷰 파일은 만들지 않습니다. 원인은 `.reviewer/errorlogs/` 아래 타임스탬프가 붙은 마크다운 로그에 기록되며, 실패한 `solve:` 커밋을 amend하면 다시 시도합니다.
* *주의: GUI Git 클라이언트(SourceTree, GitHub Desktop 등)에서는 환경 변수 문제로 훅이 동작하지 않을 수 있으므로 CLI 환경 사용을 권장합니다.*
