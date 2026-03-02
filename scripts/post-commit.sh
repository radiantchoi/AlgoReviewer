#!/bin/bash

# 1. 방금 완료된 커밋의 메시지를 가져옵니다.
COMMIT_MSG=$(git log -1 --pretty=%B)

# 2. [무한 루프 방지] 커밋 메시지가 "review:" 로 시작하면 즉시 종료합니다. (대소문자 무시)
if echo "$COMMIT_MSG" | grep -iq "^review:"; then
    exit 0
fi

# 3. [트리거 조건] 커밋 메시지가 "solve:" 로 시작하지 않으면 일반 커밋이므로 무시하고 종료합니다.
if ! echo "$COMMIT_MSG" | grep -iq "^solve:"; then
    exit 0
fi

echo "========================================="
echo "🤖 [Git Hook] 알고리즘 풀이가 감지되었습니다!"
echo "LLM 코드 리뷰를 시작합니다..."
echo "========================================="

# "solve: " 이후의 텍스트를 추출하여 문제 정보로 저장합니다.
PROBLEM_INFO=$(echo "$COMMIT_MSG" | sed -E 's/^[sS][oO][lL][vV][eE]:[[:space:]]*//')

# 4. 이번 커밋에서 변경/추가된 파일 중 'submissions/' 폴더에 있는 파일만 필터링합니다.
MODIFIED_FILES=$(git diff-tree --no-commit-id --name-only -r HEAD | grep "^submission/")

if [ -z "$MODIFIED_FILES" ]; then
    echo "[Git Hook] submission/ 디렉토리에 변경된 풀이 코드가 없습니다."
    exit 0
fi

# 5. 변경된 각 파일에 대해 파이썬 리뷰 스크립트를 실행합니다.
for FILE in $MODIFIED_FILES; do
    echo "📄 파일 분석 중: $FILE"

    # .reviewer 폴더로 이동하여 uv를 통해 파이썬 스크립트 실행 (상대 경로 전달)
    cd .reviewer || exit
    uv run generate_review.py "../$FILE"
    cd ..
done

# 6. 생성된 리뷰 마크다운 파일을 Git에 추가하고 자동 커밋합니다.
git add review/

# 변경된 사항(새로 생성된 파일)이 있는지 확인합니다.
if ! git diff --cached --quiet; then
    echo "📝 리뷰 파일 자동 커밋을 진행합니다..."
    # --no-verify 옵션으로 혹시 모를 다른 훅의 간섭을 막습니다.
    git commit --no-verify -m "review: $PROBLEM_INFO 코드 리뷰"
    echo "✅ 성공적으로 리뷰 커밋이 완료되었습니다!"
else
    echo "⚠️ 추가할 리뷰 파일이 생성되지 않았습니다."
fi

exit 0
