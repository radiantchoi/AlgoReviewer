# LeetCode No.70 Climbing Stairs Code Review

훌륭하게 작성된 코드입니다! LeetCode 70번 "Climbing Stairs" 문제에 대한 TypeScript 풀이 코드 리뷰를 진행하겠습니다.

---

## 코드 리뷰: LeetCode No.70 Climbing Stairs

**제출된 코드:**

```typescript
// LeetCode No.70 Climbing Stairs

function climbStairs(n: number): number {
  let steps = [1, 1, 2]; // steps[0] is for 0 stairs (1 way), steps[1] for 1 stair (1 way), steps[2] for 2 stairs (2 ways)

  while (steps.length <= n) {
    let first = steps[steps.length - 1];
    let second = steps[steps.length - 2];

    steps.push(first + second);
  }

  return steps[n];
}
```

### 1. 시간 복잡도 (Big-O 분석 및 최적화 가능성)

*   **분석:**
    *   `while` 루프는 `steps.length`가 `n`에 도달할 때까지 실행됩니다. 초기 `steps` 배열의 길이는 3이므로, 루프는 약 `n - 2`번 실행됩니다.
    *   루프 내부에서 배열 인덱스 접근(`steps[steps.length - 1]`, `steps[steps.length - 2]`)은 O(1) 연산입니다.
    *   `steps.push()` 연산 또한 대부분의 경우(amortized) O(1) 시간 복잡도를 가집니다.
    *   따라서 전체 시간 복잡도는 **O(n)** 입니다.

*   **최적화 가능성:**
    *   `O(n)`은 이 문제에 대한 동적 프로그래밍(Dynamic Programming, DP) 접근 방식으로는 이미 최적의 시간 복잡도입니다. 피보나치 수열을 계산하기 위해 `n`번째 항까지 순차적으로 계산해야 하므로, 선형 시간보다 빠르게 일반적인 방법으로 해결하기는 어렵습니다.
    *   매트릭스 지수화(Matrix Exponentiation)를 사용하면 `O(log n)`으로도 가능하지만, 이는 일반적인 알고리즘 인터뷰나 LeetCode 문제의 `n` 제약(보통 45 정도)에서는 과도한 최적화이며, DP의 "정석" 풀이라고 보기는 어렵습니다. 현재 풀이 방식에서 시간 복잡도 측면의 추가 최적화는 필요하지 않습니다.

### 2. 공간 복잡도

*   **분석:**
    *   `steps` 배열은 `n`까지의 모든 계단 수에 대한 방법을 저장하며, `n`이 커짐에 따라 배열의 크기도 선형적으로 증가합니다.
    *   `while` 루프가 끝난 후 `steps` 배열의 길이는 `n + 1`이 됩니다. (예: `n=3`일 때 `steps`는 `[1, 1, 2, 3]`으로 길이 4)
    *   따라서 공간 복잡도는 **O(n)** 입니다.

*   **최적화 가능성:**
    *   이 문제는 피보나치 수열과 같으므로, 현재 값을 계산하기 위해 바로 직전 두 개의 값만 필요합니다. 따라서 전체 배열을 저장할 필요 없이 두 개의 변수만 사용하여 공간 복잡도를 **O(1)** 으로 최적화할 수 있습니다.

### 3. 보편적인 "정석" 풀이 방법

*   이 문제는 대표적인 **동적 프로그래밍(Dynamic Programming, DP)** 문제입니다.
*   `ways[i]`를 `i`개의 계단을 오르는 방법의 수라고 할 때, `i`번째 계단에 도달하는 방법은 다음과 같습니다:
    1.  `(i-1)`번째 계단에서 1칸 올라오는 경우 (`ways[i-1]`)
    2.  `(i-2)`번째 계단에서 2칸 올라오는 경우 (`ways[i-2]`)
*   따라서 점화식은 `ways[i] = ways[i-1] + ways[i-2]`가 됩니다.
*   **기저(Base) 조건:**
    *   `ways[1] = 1` (1칸만 오르는 방법)
    *   `ways[2] = 2` (1+1 또는 2칸 오르는 방법)
*   제출된 코드는 이 DP 점화식을 바텀업(bottom-up) 방식으로 구현하고 있으며, `steps` 배열이 DP 테이블 역할을 합니다. 이는 이 문제의 "정석" 풀이 방법 중 하나입니다.

### 4. 현재 풀이의 적절성과 개선 가능한 부분 (엣지 케이스 포함)

*   **적절성:**
    *   코드는 `n=1`과 `n=2`와 같은 작은 `n` 값과 더 큰 `n` 값 모두에서 정확히 동작합니다.
    *   초기 `steps = [1, 1, 2]` 설정이 흥미롭고 효과적입니다. `steps[0]`은 `n=0`일 때의 가상적인 방법의 수 (1가지, 아무것도 안 함)로 사용되어 `steps[2]`를 올바르게 계산하는 데 도움을 줍니다. `n=1`이면 `steps[1]` (1)을 반환하고, `n=2`이면 `steps[2]` (2)를 반환하여 엣지 케이스를 별도의 `if` 문 없이 처리합니다. 매우 간결하고 영리한 접근 방식입니다.

*   **개선 가능한 부분 (주로 공간 최적화):**
    *   **O(1) 공간 최적화:** 위에서 언급했듯이, `O(n)` 공간 복잡도를 `O(1)`로 줄일 수 있습니다.

    ```typescript
    function climbStairsOptimized(n: number): number {
        if (n <= 0) return 0; // LeetCode constraints usually say 1 <= n. If 0 is possible, clarify expected output.
        if (n === 1) return 1;

        let prev2 = 1; // Represents ways to climb (i-2) stairs, initially for 1 stair
        let prev1 = 2; // Represents ways to climb (i-1) stairs, initially for 2 stairs
        let current = 0;

        // n=1, n=2 handled. Start calculating from n=3.
        for (let i = 3; i <= n; i++) {
            current = prev1 + prev2; // Current ways = ways(i-1) + ways(i-2)
            prev2 = prev1;          // Update prev2 to be the old prev1
            prev1 = current;        // Update prev1 to be the newly calculated current
        }

        return prev1; // For n=3, prev1 holds 3. For n=2, prev1 holds 2.
                      // More robust: return (n === 1 ? 1 : prev1) if we want to include n=1 logic here.
                      // But since n=1 and n=2 are handled above, prev1 will always hold the result for n >= 2.
    }
    ```
    *   위 `climbStairsOptimized`의 `prev2`와 `prev1`의 초기 값을 `n=1`과 `n=2`에 맞추어 더 깔끔하게 가져갈 수도 있습니다.
    ```typescript
    function climbStairsO1Space(n: number): number {
        if (n <= 0) { // Constraint: 1 <= n <= 45. But good to consider if n=0 were possible.
            return 0; // Or 1, depending on interpretation of '0 stairs'
        }
        if (n === 1) {
            return 1;
        }

        let a = 1; // ways for (i-2) stairs, initially for 1 stair
        let b = 2; // ways for (i-1) stairs, initially for 2 stairs

        for (let i = 3; i <= n; i++) {
            const temp = a + b; // Calculate ways for 'i' stairs
            a = b;              // Update 'a' to be the old 'b' (ways for i-1)
            b = temp;           // Update 'b' to be the new 'temp' (ways for i)
        }

        return b; // 'b' will hold the result for 'n' stairs
    }
    ```
    이 O(1) 공간 복잡도 버전은 원본 코드의 효율적인 `n=1, n=2` 처리를 `if` 문으로 분리하고, 나머지 계산을 루프에서 진행합니다.

### 5. TypeScript의 언어적 특성(Idiomatic Code)을 잘 살렸는지 준수 여부

*   **준수 여부:**
    *   **타입 명시:** `n: number`, `: number`와 같이 함수 인자와 반환 값에 대한 타입 어노테이션을 정확하게 사용했습니다. 이는 TypeScript의 핵심적인 강점을 잘 활용한 것입니다.
    *   **변수 선언:** `let` 키워드를 사용하여 변수를 선언한 것은 적절합니다. `first`와 `second`는 루프 내에서 재할당되지 않으므로 `const`를 사용하는 것도 고려할 수 있으나, `let`도 유효합니다.
    *   **배열 사용:** 자바스크립트/타입스크립트에서 배열 리터럴 및 `push()` 메서드를 사용하는 방식은 표준적입니다.
    *   **간결성:** 코드가 매우 간결하고 이해하기 쉽습니다. 불필요한 복잡성이나 장황함이 없습니다.

*   **개선할 점 (사소한 부분):**
    *   `steps` 배열의 초기 값에 대한 주석이 의미하는 바를 명확히 할 수 있습니다. `steps[0]`은 `n=0`의 결과가 아니라, `n=2`를 계산하기 위한 **보조 값**으로 사용된다는 점을 명시하는 것이 좋습니다.
        *   `// steps[0]: dummy value to correctly compute steps[2] (or represents 0 stairs, 1 way)`
        *   `// steps[1]: 1 way to climb 1 stair`
        *   `// steps[2]: 2 ways to climb 2 stairs`
        현재 코드는 `steps[0]`이 `n=0`일 때의 방법의 수로 사용되는 것처럼 보이지만, LeetCode 문제의 `n` 범위가 보통 `1 <= n`이기 때문에 `steps[0]`이 직접적으로 `n=0`을 처리하는 경우는 드뭅니다. 대신 `steps[2]`를 `steps[1] + steps[0]`으로 계산하기 위한 `f(0)`의 역할(`1`)을 하는 것이죠. 이 코드는 이 부분을 매우 우아하게 처리하고 있습니다.

### 결론

제출된 코드는 LeetCode No.70 "Climbing Stairs" 문제에 대한 **매우 훌륭하고 정석적인 DP 풀이**입니다. 시간 복잡도는 O(n)으로 최적이며, TypeScript의 언어적 특성을 잘 살린 간결하고 명확한 코드입니다.

주요 개선점은 공간 복잡도를 O(n)에서 **O(1)** 으로 줄이는 것입니다. 이는 성능 개선이라기보다는 메모리 사용 효율성 측면에서의 최적화이며, 면접 등에서 추가 질문으로 자주 나오는 부분입니다.

**최종 평가:**
*   **시간 복잡도:** O(n) (최적)
*   **공간 복잡도:** O(n) (O(1)으로 최적화 가능)
*   **적절성:** 매우 높음
*   **TypeScript Idiom:** 잘 준수됨

코드 품질이 높으므로, O(1) 공간 최적화 버전을 추가적으로 학습하고 공유하면 더욱 완벽한 풀이가 될 것입니다.