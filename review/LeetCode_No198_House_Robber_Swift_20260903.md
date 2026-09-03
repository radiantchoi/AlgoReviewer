# LeetCode No.198 House Robber Code Review

# LeetCode No.198 House Robber Swift 코드 리뷰

## 1. 총평

제시된 코드는 House Robber 문제의 핵심 DP recurrence를 올바르게 반영하고 있습니다.

핵심 아이디어는 다음과 같습니다.

```text
현재 집까지의 최대 수익 =
  max(
    현재 집을 털지 않는 경우,
    현재 집을 털는 경우
  )
```

즉,

```text
dp[i] = max(dp[i - 1], dp[i - 2] + nums[i])
```

이 방향은 이 문제의 정석적인 접근법입니다.

다만 다음과 같은 개선 포인트가 있습니다.

1. `nums`가 빈 배열일 경우 크래시가 발생할 수 있음
2. 불필요하게 O(n) 추가 공간을 사용할 수 있음
3. 입력 배열을 복사해서 수정하는 방식은 Swift 관점에서 약간 비직관적
4. 분기 처리가 다소 많아 가독성이 떨어질 수 있음
5. Swift idiomatic한 DP 상태 관리 방식으로 더 단순하게 작성 가능

---

## 2. 시간 복잡도

### 현재 코드

```swift
for i in 2..<nums.count {
    nums[i] = max(nums[i - 1], nums[i] + nums[i - 2])
}
```

배열을 한 번만 순회하므로 시간 복잡도는 다음과 같습니다.

```text
O(n)
```

여기서 `n`은 `nums.count`입니다.

`max` 연산은 상수 시간이므로 시간 복잡도에 영향을 주지 않습니다.

### 최적화 가능성

House Robber 문제는 각 집의 상태가 직전 두 상태에만 의존하므로, 반드시 O(n) 시간으로 풀 수 있습니다.

따라서 현재 코드의 시간 복잡도는 이미 최적입니다.

---

## 3. 공간 복잡도

### 현재 코드

```swift
var nums = nums
```

이후 `nums`의 원소를 수정하고 있습니다.

Swift의 `Array`는 Value Type이지만, Copy-on-Write(CoW)을 사용합니다.

즉, `var nums = nums`로 변수를 만든 뒤 원소를 수정하면, 원래 `nums` 참조가 남아 있는 상태에서 수정이 발생하므로 내부적으로 배열 복사 가 발생할 수 있습니다.

따라서 현재 코드의 공간 복잡도는 개념적으로 다음과 같습니다.

```text
O(n)
```

### 개선 가능 여부

House Robber 문제는 DP 상태 중 이전 두 값만 기억하면 됩니다.

즉,

```text
dp[i - 1]
dp[i - 2]
```

이 두 값만 유지하면 O(n) 배열이 필요하지 않습니다.

따라서 공간 복잡도는 다음과 같이 개선 가능합니다.

```text
O(1)
```

---

## 4. 정석적인 풀이 방법

House Robber 문제는 전형적인 1D Dynamic Programming 문제입니다.

### 상태 정의

`dp[i]`: `i` 번째 집까지를 대상으로 할 때 얻을 수 있는 최대 수익

### 상태 전이

각 집은 두 가지 선택지가 있습니다.

1. `i` 번째 집을 털지 않는다  
   → `dp[i - 1]`

2. `i` 번째 집을 털는다  
   → `dp[i - 2] + nums[i]`

따라서:

```text
dp[i] = max(dp[i - 1], dp[i - 2] + nums[i])
```

### Base Case

편의상 다음과 같이 정의할 수 있습니다.

```text
dp[-1] = 0
dp[0] = nums[0]
```

또는 두 변수를 사용하여 구현합니다.

```swift
var prev2 = 0
var prev1 = 0
```

여기서:

- `prev2`: `dp[i - 2]`
- `prev1`: `dp[i - 1]`

---

## 5. 현재 풀이의 적절성과 개선 가능한 부분

### 5-1. 빈 배열 엣지 케이스

현재 코드:

```swift
guard nums.count > 1 else {
    return nums[0]
}
```

`nums.count == 1`이면 문제 없습니다.

하지만 `nums.count == 0`이면 다음과 같이 크래시가 발생합니다.

```swift
nums[0]
```

LeetCode 제약 조건에서 `nums`가 비어 있지 않다고 보장되면 실제 테스트에서는 문제가 없을 수 있습니다.

하지만 더 방어적인 코드로는 다음과 같이 처리하는 것이 좋습니다.

```swift
if nums.isEmpty {
    return 0
}
```

또는 O(1) DP 방식에서 자연스럽게 빈 배열을 처리할 수 있습니다.

```swift
var skip = 0
var take = 0
for num in nums {
    (skip, take) = (take, max(take, skip + num))
}
return take
```

이 방식은 `nums`가 비어 있어도 `0`을 반환합니다.

---

### 5-2. 입력 배열 복사 및 수정

현재 코드:

```swift
var nums = nums

if nums.count > 2 {
    nums[1] = max(nums[0], nums[1])

    for i in 2..<nums.count {
        nums[i] = max(nums[i - 1], nums[i] + nums[i - 2])
    }
}
```

이 코드는 `nums`를 복사한 뒤 원소를 수정하는 in-place DP 방식에 가깝습니다.

동작 자체는 가능하지만, 몇 가지 단점이 있습니다.

1. 원본 입력을 복사할 수 있음
2. Swift의 Copy-on-Write 특성상 O(n) 메모리 소비 가능성
3. `nums[i]`가 원래 집의 값인지, DP 상태인지 혼동될 수 있음
4. 함수가 입력을 변경하는 side effect를 가질 수 있음

House Robber 문제는 O(1) 상태로 충분히 풀 수 있으므로, 배열을 수정하는 방식보다는 두 변수를 사용하는 방식이 더 깔끔합니다.

---

### 5-3. 분기 처리가 다소 많음

현재 코드는 다음과 같은 분기를 가지고 있습니다.

```swift
guard nums.count > 1 else {
    return nums[0]
}

if nums.count > 2 {
    nums[1] = max(nums[0], nums[1])

    for i in 2..<nums.count {
        nums[i] = max(nums[i - 1], nums[i] + nums[i - 2])
    }
}

return max(nums[nums.count - 1], nums[nums.count - 2])
```

기능적으로는 작동하지만, 다음과 같은 이유로 가독성이 떨어집니다.

- `count == 0`, `count == 1`, `count == 2`, `count > 2`를 분리해서 생각해야 함
- 마지막에 다시 `max`를 수행하는 이유를 이해해야 함
- `nums[i]`가 원본 값인지 DP 상태인지 구분이 어려움

반면 O(1) DP 방식은 분기 없이 처리할 수 있습니다.

---

### 5-4. 마지막 `max`는 사실상 불필요할 수 있음

현재 코드:

```swift
return max(nums[nums.count - 1], nums[nums.count - 2])
```

`count > 2`인 경우, DP invariant에 의해:

```text
dp[n - 1] >= dp[n - 2]
```

이 성립합니다.

이유는:

```swift
nums[i] = max(nums[i - 1], nums[i] + nums[i - 2])
```

이므로 항상 `nums[i] >= nums[i - 1]`이기 때문입니다.

따라서 `count > 2`일 때는 다음으로도 충분합니다.

```swift
return nums[nums.count - 1]
```

다만 현재 코드의 `max`가 틀린 것은 아닙니다.

안전성 측면에서는 무해하지만, DP 의미를 정확히 반영한다면 불필요한 연산으로 볼 수 있습니다.

---

### 5-5. 음수 값 엣지 케이스

LeetCode No.198의 일반적인 제약 조건은 다음과 같습니다.

```text
1 <= nums.length <= 100
0 <= nums[i] <= 1000
```

즉, 음수는 없습니다.

따라서 현재 코드는 문제 제약 조건상 문제 없습니다.

하지만 만약 `nums[i]`가 음수일 수도 있고, 반드시 한 곳 이상을 선택해야 하는 문제로 확장된다면 초기값을 주의해야 합니다.

예를 들어:

```swift
var skip = 0
var take = 0
```

이 방식은 “아무 집도 안 털어도 된다”는 의미로 동작합니다.

만약 모든 값이 음수이고 반드시 한 곳 이상을 선택해야 한다면, 아래처럼 처리해야 합니다.

```swift
guard let first = nums.first else { return 0 }

var prev2 = 0
var prev1 = first

for num in nums.dropFirst() {
    let current = max(prev1, prev2 + num)
    prev2 = prev1
    prev1 = current
}

return prev1
```

다만 LeetCode No.198 기본 제약 조건에서는 `0` 초기화가 충분합니다.

---

## 6. Swift 언어적 특성 및 Idiomatic Code

### 6-1. `var nums = nums` shadowing

현재 코드:

```swift
func rob(_ nums: [Int]) -> Int {
    var nums = nums
    ...
}
```

파라미터 `nums`와 로컬 변수 `nums` 이름이 같습니다.

Swift에서 허용되는 방식이지만, 가독성 측면에서는 약간 혼동될 수 있습니다.

특히 이 문제는 입력 배열을 수정할 필요가 없으므로, `nums`를 shadowing하는 것보다는 새로운 상태 변수를 사용하는 것이 더 명확합니다.

---

### 6-2. `for num in nums` 사용

Swift에서는 배열 순회 시:

```swift
for num in nums {
    ...
}
```

방식이 더 자연스럽습니다.

인덱스 기반 순회보다는 요소 기반 순회가 더 읽기 쉽고, Swift 스타일에 부합합니다.

---

### 6-3. tuple assignment 활용

DP 상태 전이는 tuple assignment로 매우 깔끔하게 표현할 수 있습니다.

```swift
(skip, take) = (take, max(take, skip + num))
```

Swift는 오른쪽 값을 모두 평가한 뒤 왼쪽에 동시에 대입하므로, 상태 업데이트에 매우 적합합니다.

---

### 6-4. `guard` 또는 빈 배열 처리

빈 배열을 방어적으로 처리한다면:

```swift
if nums.isEmpty {
    return 0
}
```

또는:

```swift
guard let first = nums.first else {
    return 0
}
```

을 사용할 수 있습니다.

다만 O(1) DP 방식으로 작성하면 빈 배열도 자연스럽게 처리됩니다.

---

## 7. 개선 코드

### 추천 코드

```swift
class Solution {
    func rob(_ nums: [Int]) -> Int {
        var skip = 0
        var take = 0

        for num in nums {
            (skip, take) = (take, max(take, skip + num))
        }

        return take
    }
}
```

### 동작 설명

- `skip`: 현재 집을 털지 않을 때의 최대 수익
- `take`: 현재 집을 털었을 때의 최대 수익

각 `num`에 대해:

```swift
(skip, take) = (take, max(take, skip + num))
```

다음과 같이 업데이트됩니다.

- 새 `skip`: 이전 `take`
- 새 `take`: 이전 `take`와 이전 `skip + num` 중 큰 값

이 방식은:

```text
dp[i] = max(dp[i - 1], dp[i - 2] + nums[i])
```

를 O(1) 공간으로 구현한 것입니다.

### 복잡도

```text
Time:  O(n)
Space: O(1)
```

### 엣지 케이스 처리

- `nums.isEmpty` → `0`
- `nums.count == 1` → 해당 값
- `nums.count == 2` → 두 값 중 최대
- `nums.count > 2` → 정상 DP

모두 자연스럽게 처리됩니다.

---

## 8. 대안 코드: `prev2`, `prev1` 방식

DP 의미를 더 직접적으로 드러내려면 다음과 같이 작성할 수도 있습니다.

```swift
class Solution {
    func rob(_ nums: [Int]) -> Int {
        var prev2 = 0
        var prev1 = 0

        for num in nums {
            let current = max(prev1, prev2 + num)
            prev2 = prev1
            prev1 = current
        }

        return prev1
    }
}
```

이 방식은:

- `prev2`: `dp[i - 2]`
- `prev1`: `dp[i - 1]`
- `current`: `dp[i]`

을 명시적으로 표현하므로 DP 학습 관점에서는 더 이해하기 쉽습니다.

복잡도는 동일합니다.

```text
Time:  O(n)
Space: O(1)
```

---

## 9. 최종 평가

| 항목 | 평가 |
|---|---|
| 알고리즘 방향 | 정석적인 DP 접근 |
| 시간 복잡도 | O(n), 최적 |
| 공간 복잡도 | 현재 O(n) 가능, O(1)으로 개선 가능 |
| 엣지 케이스 | 빈 배열 크래시 가능성 존재 |
| 가독성 | 분기较多, 개선 가능 |
| Swift idiomatic | 개선 가능 |
| 전체 적절성 | 동작은 올바름, O(1) DP 방식으로 정리하는 것이 더 좋음 |

### 최종 결론

현재 코드는 LeetCode No.198 House Robber 문제를 올바르게 풀고 있습니다.

하지만 더 좋은 Swift 풀이는 입력 배열을 복사하거나 수정하지 않고, 이전 두 DP 상태만 사용하는 O(1) 공간 방식입니다.

추천 개선 코드는 다음과 같습니다.

```swift
class Solution {
    func rob(_ nums: [Int]) -> Int {
        var skip = 0
        var take = 0

        for num in nums {
            (skip, take) = (take, max(take, skip + num))
        }

        return take
    }
}
```

이 방식은:

- 시간 복잡도: `O(n)`
- 공간 복잡도: `O(1)`
- 엣지 케이스 처리: 빈 배열 포함 자연스러운 처리
- Swift 스타일: tuple assignment와 `for-in` loop을 활용한 가독성 개선

을 모두 만족합니다.