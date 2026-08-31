# Unknown Problem Occurred Code Review

# 코드 리뷰: Unknown Problem Occurred

## ⚠️ 코드 확인 요청

현재 첨부하신 코드 블록이 **비어 있습니다.**

```swift
// 코드가 여기에 있어야 합니다.
```

아래와 같이 Swift 소스를 다시 붙여넣어 주시면 바로 리뷰를 진행해 드리겠습니다:

```swift
// 예시
func solution(_ input: Int) -> Int {
    // ...
}
```

---

## 📋 예정된 리뷰 기준

코드가 도착하면 아래 5개 기준으로 체계적으로 리뷰하겠습니다.

### 1. 시간 복잡도 (Big-O)
- 현재 알고리즘의 worst-case / average-case 분석
- 반복/재귀 구조에서 불필요한 계산 여부
- 최적화 가능성이 있는 구간 식별 (예: O(n²) → O(n log n) 등)

### 2. 공간 복잡도
- 추가 메모리 사용량 분석
- 불필요한 자료구조 복사, 배열/딕셔너리 생성 여부
- in-place 처리 가능 여부

### 3. 정석 풀이 방법
- 문제 유형(방문/DP/그리디/그래프/이분 탐색 등)에 맞는 canonical approach 비교
- 현재 접근과 정석 접근의 trade-off 평가

### 4. 적절성 및 엣지 케이스
- 입력 검증 및 boundary condition 처리
- 특수 입력(빈 배열, 1개 요소, 최대/최솟값, 음수 등) 처리
- 잘못된 출력/오버플로 가능성

### 5. Swift Idiomatic Code
- `guard`/`if let`/`optional` 활용 적절성
- `let` vs `var` 사용 원칙
- 값 타입 vs 참조 타입 선택
- Swift 표준 라이브러리 활용 (`map`, `filter`, `reduce`, `lazy` 등)
- 프로토콜/제네릭 사용 적절성 (해당 시)
- 에러 처리 방식 (`throw`/`Result`/`failable init`)

---

## ✍️ 코드 제출 시 팁

더 정확한 리뷰를 위해 아래 정보를 함께 알려주시면 좋습니다:

| 항목 | 내용 |
|------|------|
| 문제 출처 | (예: BOJ, LeetCode, Codeup 등) |
| 입력/출력 형식 | |
| 제약 조건 | (예: 1 ≤ N ≤ 10⁵) |
| 실행 시간/메모리 제한 | |
| 현재 상태 | (AC / TLE / MLE / WA 등) |

코드만 붙여넣어 주셔도 기본 리뷰는 충분히 가능합니다. 🙌