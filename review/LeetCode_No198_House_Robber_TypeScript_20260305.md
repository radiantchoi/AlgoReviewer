# LeetCode No.198 House Robber Code Review

훌륭한 코드입니다! LeetCode 198 House Robber 문제의 전형적인 동적 프로그래밍(DP) 풀이이자, 공간 복잡도를 최적화한 모범적인 접근 방식을 TypeScript로 잘 구현했습니다. 시니어 코드 리뷰어의 관점에서 각 기준에 따라 상세히 리뷰하겠습니다.

---

## LeetCode No.198 House Robber 풀이 코드 리뷰

### 1. 시간 복잡도 (Big-O 분석 및 최적화 가능성)

*   **분석:**
    *   `if (nums.length < 3)` 조건문 내부의 `Math.max(...nums)`는 배열의 길이에 비례하여 `O(N)` 시간이 걸립니다. 그러나 이 블록은 `nums.length`가 0, 1, 2일 때만 실행되므로, 실제로는 상수 시간 `O(1)`에 가깝습니다. (엄밀히 말하면 N=2일 때 2번 비교, N=1일 때 1번 비교)
    *   `nums[1] = Math.max(nums[0], nums[1]);`는 상수 시간 `O(1)`입니다.
    *   `for` 루프는 `i = 2`부터 `nums.length - 1`까지 `nums.length - 2`번 반복됩니다. 루프 내의 각 연산은 상수 시간 `O(1)`입니다.
    *   따라서 전체 시간 복잡도는 배열의 길이에 선형적으로 비례하는 **`O(N)`** 입니다.

*   **최적화 가능성:**
    *   이 문제에서 모든 집을 한 번씩은 고려해야 하므로 `O(N)`보다 더 효율적인 시간 복잡도는 불가능합니다. 현재 풀이는 **시간 복잡도 측면에서 최적화되어 있습니다.**

### 2. 공간 복잡도

*   **분석:**
    *   이 코드는 입력 배열 `nums`를 직접 수정하여 DP 상태를 저장합니다.
    *   추가적인 배열이나 데이터 구조를 생성하지 않습니다.
    *   `i`, `nums.length` 등의 변수는 상수 공간을 차지합니다.
    *   따라서 공간 복잡도는 **`O(1)`** (상수 공간) 입니다.

*   **최적화 가능성:**
    *   이 풀이는 `O(1)` 공간 복잡도를 달성했으므로, **공간 복잡도 측면에서 최적화되어 있습니다.** (전통적인 `dp` 배열을 사용하는 `O(N)` 공간 풀이보다 효율적입니다.)

### 3. 보편적인 "정석" 풀이 방법

*   **동적 프로그래밍 (Dynamic Programming):** 이 문제는 전형적인 동적 프로그래밍 문제입니다.
    *   `dp[i]`를 `i`번째 집까지 털었을 때 얻을 수 있는 최대 금액이라고 정의할 때, 점화식은 `dp[i] = max(dp[i-1], dp[i-2] + nums[i])`가 됩니다.
    *   `dp[i-1]`은 `i`번째 집을 털지 않았을 경우의 최대 금액입니다.
    *   `dp[i-2] + nums[i]`는 `i`번째 집을 털었을 경우의 최대 금액입니다 (이 경우 `i-1`번째 집은 털 수 없으므로 `i-2`번째 집까지의 최대 금액에 `i`번째 집 금액을 더합니다).
*   **현재 풀이의 접근법:**
    *   제공된 코드는 정확히 이 DP 점화식을 따르고 있으며, 입력 배열 `nums`를 `dp` 배열처럼 재사용하여 공간을 최적화했습니다.
    *   `nums[i]`가 DP 배열의 `dp[i]` 역할을 합니다.
    *   기존 `nums[i]` 값은 현재 집의 금액을 나타내고, 루프 안에서 `nums[i]`는 `i`번째 집까지 털었을 때의 최대 금액으로 업데이트됩니다.
    *   베이스 케이스:
        *   `nums.length = 1`일 때 `nums[0]` 반환 (첫 번째 집만 털 수 있음)
        *   `nums.length = 2`일 때 `max(nums[0], nums[1])` 반환 (둘 중 더 큰 집 하나만 털 수 있음)
        *   `nums.length = 0`일 때 `Math.max(...[])`는 `-Infinity`를 반환하므로, 이 경우는 별도 처리가 필요합니다. (아래 4번에서 다룸)
    *   초기화: `nums[1] = Math.max(nums[0], nums[1])`는 `dp[1]`을 올바르게 설정합니다. `nums[0]`는 암묵적으로 `dp[0]`의 역할을 수행합니다.

### 4. 현재 풀이의 적절성과 개선 가능한 부분 (엣지 케이스 포함)

*   **적절성:**
    *   매우 적절하며, 공간 복잡도까지 최적화한 훌륭한 DP 풀이입니다.
*   **개선 가능한 부분:**
    *   **`nums.length === 0` 엣지 케이스 처리:**
        `Math.max(...[])`는 `-Infinity`를 반환합니다. 문제 조건에 따라 `nums`가 빈 배열일 경우 `0`을 반환하는 것이 일반적입니다. 현재 코드로는 `nums.length < 3` 블록에서 `-Infinity`가 반환되어 올바르지 않습니다.
        ```typescript
        function rob(nums: number[]): number {
            if (nums.length === 0) { // 추가된 엣지 케이스 처리
                return 0;
            }
            if (nums.length === 1) { // nums.length < 3의 첫 번째 부분
                return nums[0];
            }
            // 기존: if (nums.length < 3) { return Math.max(...nums); }
            // 변경 후: nums.length가 2일 때만 남음
            if (nums.length === 2) {
                return Math.max(nums[0], nums[1]);
            }
            // 이제 nums.length >= 3인 경우만 남음
            // ... (나머지 코드)
        }
        ```
        또는 더 간결하게:
        ```typescript
        function rob(nums: number[]): number {
            if (nums.length === 0) return 0;
            if (nums.length === 1) return nums[0];
            // 이 시점에서는 nums.length >= 2

            // nums.length가 2일 때 이 초기화가 이미 정답이 된다.
            // nums[0]은 dp[0], nums[1]은 dp[1] 역할을 한다.
            nums[1] = Math.max(nums[0], nums[1]);

            // nums.length가 2이면 루프는 실행되지 않고 nums[1]이 반환된다.
            // nums.length가 3 이상이면 루프가 실행된다.
            for (let i = 2; i < nums.length; i++) {
                nums[i] = Math.max(nums[i - 1], nums[i - 2] + nums[i]);
            }

            return nums[nums.length - 1];
        };
        ```
        이 두 번째 방식이 더 간결하면서도 `nums.length === 2`까지 처리하므로 더 우아합니다.

### 5. TypeScript의 언어적 특성(Idiomatic Code)을 잘 살렸는지 준수 여부

*   **타입 명시:** `nums: number[]`와 반환 타입 `: number`를 명확히 명시하여 가독성과 안정성을 높였습니다. 이는 TypeScript의 가장 중요한 장점 중 하나이며, 잘 활용되었습니다.
*   **`const`/`let` 사용:** 루프 변수 `i`에 `let`을 사용하고, 다른 변수를 선언할 필요가 없어 적절하게 사용되었습니다.
*   **배열 Spread 연산자:** `Math.max(...nums)`와 같이 배열에 대한 연산을 수행할 때 Spread 연산자를 사용하여 간결하고 가독성 좋은 코드를 작성했습니다.
*   **객체 지향적 접근 vs 함수형 접근:**
    *   이 코드는 입력 배열 `nums`를 **직접 수정(mutate)**합니다. 알고리즘 문제 풀이에서는 공간 효율성을 위해 이런 접근법이 흔하게 사용됩니다.
    *   하지만 TypeScript를 포함한 현대 웹 개발에서는 "불변성(immutability)"을 선호하는 경향이 있습니다. 입력 데이터를 수정하는 것은 예상치 못한 부작용을 일으킬 수 있기 때문입니다.
    *   만약 "불변성"이 중요한 코드 베이스라면, 입력 배열을 복사하여 사용하거나, `dp` 값을 저장할 별도의 변수 (`prev2`, `prev1`, `current`)를 사용하는 방식(`O(1)` 공간 복잡도는 유지)을 고려할 수 있습니다.
        ```typescript
        // 불변성을 유지하는 O(1) 공간 풀이 예시
        function robImmutable(nums: number[]): number {
            if (nums.length === 0) return 0;
            if (nums.length === 1) return nums[0];

            let prev2 = nums[0]; // dp[0]
            let prev1 = Math.max(nums[0], nums[1]); // dp[1]

            for (let i = 2; i < nums.length; i++) {
                const current = Math.max(prev1, prev2 + nums[i]);
                prev2 = prev1;
                prev1 = current;
            }

            return prev1; // 최종 dp[n-1]
        }
        ```
    *   경쟁 프로그래밍 환경에서는 현재의 "mutating" 방식이 더 흔하고 허용되지만, 일반적인 애플리케이션 개발에서는 위 `robImmutable`과 같은 방식이 더 "idiomatic"하다고 볼 수 있습니다.

### 종합 의견

제공된 `rob` 함수는 LeetCode 198 House Robber 문제에 대한 **매우 효율적이고 올바른 동적 프로그래밍 솔루션**입니다. 시간 복잡도 `O(N)`와 공간 복잡도 `O(1)`을 달성하여 최적화된 상태입니다.

다만, `nums.length === 0` 엣지 케이스 처리를 보완하고, 필요에 따라 입력 배열의 불변성을 유지하는 방향으로 코드를 개선할 수 있습니다. 그러나 알고리즘 문제 풀이의 맥락에서는 현재의 코드도 매우 훌륭합니다.

---