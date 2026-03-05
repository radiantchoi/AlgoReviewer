# LeetCode No.1 Two Sum Code Review

안녕하세요. 시니어 알고리즘 코드 리뷰어입니다. Swift로 작성된 LeetCode No.1 Two Sum 문제 풀이 코드에 대한 상세 리뷰를 시작하겠습니다.

---

## LeetCode No.1 Two Sum 풀이 코드 리뷰

전반적으로 두 가지 접근 방식(`twoSum`, `twoSum2`)을 모두 시도하고 고민한 흔적이 보이는 좋은 코드입니다. 특히 `twoSum2`는 이 문제의 "정석" 풀이에 해당하며, Swift의 언어적 특성을 잘 활용했습니다.

### 1. `func twoSum(_ nums: [Int], _ target: Int) -> [Int]` (첫 번째 시도)

**1.1. 시간 복잡도 (Big-O 분석 및 최적화 가능성)**

*   **`let pairs = nums.enumerated().sorted { $0.element < $1.element }`**:
    *   `enumerated()`: O(N)
    *   `sorted()`: O(N log N) (주로 `Int` 타입의 비교는 상수 시간이므로)
    *   여기까지의 시간 복잡도는 **O(N log N)** 입니다.
*   **외부 `for` 루프**: `pairs.count - 1`번 반복하므로 O(N)입니다.
*   **내부 `while` 루프 (이진 탐색)**: 정렬된 배열에서 원소를 탐색하므로 O(log N)입니다.
*   **총 시간 복잡도**: O(N log N) (정렬) + O(N log N) (N번의 이진 탐색) = **O(N log N)**.
*   **최적화 가능성**: 이 풀이 자체에서는 N log N보다 더 최적화하기 어렵습니다. 하지만 이 문제는 N log N보다 더 빠른 O(N) 해법이 존재합니다. (아래 `twoSum2`에서 다룸)

**1.2. 공간 복잡도**

*   **`let pairs`**: `nums` 배열의 각 요소와 인덱스를 저장하는 새로운 배열을 생성합니다. 이는 입력 배열 `nums`의 크기 N에 비례하므로 **O(N)** 입니다.
*   나머지 변수들은 상수 공간을 사용합니다.
*   **총 공간 복잡도**: **O(N)**.

**1.3. 보편적인 "정석" 풀이 방법**

*   이 방식은 정렬 후 투 포인터(Two-Pointers)나 이진 탐색(Binary Search)을 활용하는 일반적인 패턴입니다. 예를 들어, "Two Sum II - Input array is sorted" 문제에서는 이진 탐색 대신 투 포인터 방식을 사용하면 O(N) 시간 복잡도로 해결할 수 있습니다.
*   하지만 이 문제에서는 원본 인덱스를 반환해야 하므로, 정렬 시 인덱스 정보를 함께 유지해야 합니다. 또한, 이진 탐색을 사용할 경우 `O(N log N)`이 됩니다. 이진 탐색 대신 투 포인터 접근 방식을 취하려면, 정렬된 `pairs` 배열에서 `i`와 `j` 두 포인터를 사용하고, `pairs[i].element + pairs[j].element`를 비교하여 `target`과 맞추는 방식으로 `O(N)`에 해결할 수 있습니다. 이 경우, `i`는 `0`에서 시작하고 `j`는 `pairs.count - 1`에서 시작합니다. (현재 코드처럼 `i`를 고정하고 `i+1`부터 이진 탐색하는 방식이 아닙니다.)
    *   **정렬 후 투 포인터 (O(N log N) + O(N))**:
        ```swift
        // pseudo code
        let sortedPairs = nums.enumerated().sorted { $0.element < $1.element }
        var left = 0
        var right = sortedPairs.count - 1

        while left < right {
            let sum = sortedPairs[left].element + sortedPairs[right].element
            if sum == target {
                return [sortedPairs[left].offset, sortedPairs[right].offset]
            } else if sum < target {
                left += 1
            } else {
                right -= 1
            }
        }
        return [] // Should not be reached based on problem statement
        ```
    *   이 방식은 여전히 정렬 때문에 O(N log N)이 걸리지만, N번의 이진 탐색보다는 투 포인터 탐색 부분이 O(N)이므로, 정렬 + 투 포인터는 이진 탐색보다는 나은 접근이 될 수 있습니다. (하지만 정렬이 포함되므로 `twoSum2`의 해시맵 방식보다 여전히 느립니다.)

**1.4. 현재 풀이의 적절성과 개선 가능한 부분 (엣지 케이스 포함)**

*   **적절성**: 코드는 주어진 제약 조건 내에서 올바르게 작동합니다. 문제의 "정확히 하나의 해답이 있다"는 조건 때문에 `return []`에 도달할 일은 없습니다.
*   **엣지 케이스**:
    *   **빈 배열 또는 요소가 하나인 배열**: `pairs.count - 1`이 음수가 되므로 `0..<(-1)`은 빈 범위가 되어 `for` 루프가 실행되지 않고 `[]`를 반환합니다. 문제 조건상 `nums`의 길이가 2 이상이므로 이 케이스는 발생하지 않습니다.
    *   **중복된 숫자**: 예를 들어 `nums = [3, 2, 4], target = 6`의 경우, `pairs`는 `[(1,2), (0,3), (2,4)]`처럼 정렬됩니다. `i=0, pairs[i]=(1,2)`. `searching=4`. `binary search`로 `pairs[2]=(2,4)`를 찾고 `[1, 2]`를 반환합니다. `nums = [3, 3], target = 6`의 경우, `pairs`는 `[(0,3), (1,3)]`으로 정렬됩니다. `i=0, pairs[i]=(0,3)`. `searching=3`. `binary search`로 `pairs[1]=(1,3)`을 찾고 `[0, 1]`을 반환합니다. 모두 잘 처리됩니다.
*   **개선**: 위에서 언급했듯이, 정렬된 배열에서 이진 탐색을 N번 하는 대신, 정렬된 배열에서 투 포인터를 사용하는 것이 더 효율적인 탐색 방법이지만, 여전히 정렬 시간 때문에 `O(N log N)`입니다. 이 문제의 진정한 최적화는 해시맵을 사용하는 `twoSum2` 방식입니다.

**1.5. Swift의 언어적 특성(Idiomatic Code)을 잘 살렸는지 준수 여부**

*   `nums.enumerated().sorted { $0.element < $1.element }`: `enumerated()`를 사용하여 인덱스와 값을 동시에 처리하고, 클로저를 활용한 `sorted`는 Swift다운 표현입니다.
*   변수명(`pairs`, `left`, `right`, `mid`, `searching`, `offset`, `element`)이 명확하고 가독성이 좋습니다.
*   전반적으로 Swift의 문법과 표현에 충실하게 작성되었습니다.

---

### 2. `func twoSum2(_ nums: [Int], _ target: Int) -> [Int]` (두 번째 시도)

**2.1. 시간 복잡도 (Big-O 분석 및 최적화 가능성)**

*   **`var pool: [Int: Int] = [:]`**: 딕셔너리 초기화는 O(1)입니다.
*   **`for (offset, number) in nums.enumerated()`**: `nums` 배열의 각 요소를 한 번씩 순회하므로 O(N)입니다.
*   **`let searching = target - number`**: 상수 시간 O(1)입니다.
*   **`if let candidate = pool[searching]`**: 딕셔너리(해시 맵) 조회는 평균적으로 O(1)입니다. 최악의 경우(해시 충돌이 매우 심할 때) O(N)이 될 수도 있지만, Swift의 `Dictionary`는 일반적으로 잘 구현되어 평균 O(1) 성능을 보장합니다.
*   **`pool[number] = offset`**: 딕셔너리 삽입 또한 평균적으로 O(1)입니다.
*   **총 시간 복잡도**: **평균 O(N)**. 이는 이 문제에서 달성할 수 있는 최적의 시간 복잡도입니다.

**2.2. 공간 복잡도**

*   **`var pool: [Int: Int]`**: 딕셔너리에 최대 `N`개의 요소를 저장할 수 있습니다. 각 요소는 `Int` 키와 `Int` 값을 가집니다.
*   **총 공간 복잡도**: **O(N)**. 입력 배열의 모든 요소가 짝을 찾지 못하고 딕셔너리에 저장될 경우 N개의 공간이 필요합니다.

**2.3. 보편적인 "정석" 풀이 방법**

*   이 풀이는 LeetCode No.1 "Two Sum" 문제의 **가장 보편적이고 효율적인 "정석" 풀이 방법**입니다. 해시 테이블(Swift의 `Dictionary`)을 사용하여 각 숫자에 대해 `target - number`를 O(1)에 찾을 수 있는지 확인하고, 없으면 현재 숫자를 해시 테이블에 저장하는 방식입니다.

**2.4. 현재 풀이의 적절성과 개선 가능한 부분 (엣지 케이스 포함)**

*   **적절성**: 이 풀이는 완벽하게 적절하며, 가장 효율적인 접근 방식입니다. 문제의 "정확히 하나의 해답이 있다"는 조건 때문에 `return []`에 도달할 일은 없습니다.
*   **엣지 케이스**:
    *   **빈 배열 또는 요소가 하나인 배열**: `for` 루프가 실행되지 않고 `[]`를 반환합니다. 문제 조건상 `nums`의 길이가 2 이상이므로 이 케이스는 발생하지 않습니다.
    *   **중복된 숫자**: `nums = [3, 3], target = 6`의 경우:
        *   `offset = 0, number = 3`. `searching = 3`. `pool[3]`은 `nil`. `pool`에 `[3:0]` 추가.
        *   `offset = 1, number = 3`. `searching = 3`. `pool[3]`은 `0`을 반환. `[1, 0]` 반환. (현재 인덱스 `1`과 이전에 저장된 `3`의 인덱스 `0`). 올바르게 작동합니다.
    *   `nums = [2, 7, 11, 15], target = 9`의 경우:
        *   `offset = 0, number = 2`. `searching = 7`. `pool[7]`은 `nil`. `pool`에 `[2:0]` 추가.
        *   `offset = 1, number = 7`. `searching = 2`. `pool[2]`는 `0`을 반환. `[1, 0]` 반환. 올바르게 작동합니다.
*   **개선**: 특별히 개선할 부분은 없습니다. 완벽한 솔루션입니다.

**2.5. Swift의 언어적 특성(Idiomatic Code)을 잘 살렸는지 준수 여부**

*   `var pool: [Int: Int] = [:]`: 딕셔너리 초기화는 Swift의 표준 방식입니다.
*   `for (offset, number) in nums.enumerated()`: `enumerated()`를 사용하여 인덱스와 값을 동시에 가져오는 방식은 Swift에서 매우 권장되는 관용적인 코드입니다.
*   `if let candidate = pool[searching]`: 딕셔너리 조회 결과가 `Optional`임을 `if let`을 통해 안전하게 언래핑하는 방식은 Swift의 안전성을 높이는 매우 좋은 습관입니다.
*   변수명(`pool`, `offset`, `number`, `searching`, `candidate`)이 명확하고 가독성이 좋습니다.
*   전반적으로 Swift의 강력한 기능을 활용하여 간결하고 안전하며 효율적인 코드를 작성했습니다.

---

### 결론

두 풀이 모두 특정 알고리즘적 접근 방식을 잘 구현했지만, **`twoSum2` 함수가 시간 복잡도 면에서 훨씬 우수하며, LeetCode No.1 Two Sum 문제의 "정석" 풀이에 해당합니다.** Swift의 `Dictionary`를 효과적으로 활용하여 `O(N)`의 평균 시간 복잡도를 달성했고, Swift 언어의 관용적인 표현들도 잘 사용했습니다.

`twoSum` 함수는 정렬 기반의 이진 탐색으로 `O(N log N)`의 복잡도를 가지며, 이는 일반적인 경우 `twoSum2`보다 비효율적입니다. 하지만 정렬 기반 풀이를 시도하여 문제에 대한 다양한 접근 방식을 고민해본 것은 매우 훌륭한 학습 과정입니다.

전반적으로 시니어 알고리즘 리뷰어로서 이 코드를 매우 긍정적으로 평가합니다. 특히 `twoSum2`는 최적의 해법으로, 유지보수성, 가독성, 성능 모두 뛰어납니다.