# LeetCode No.1 Two Sum Code Review

# LeetCode No.1 Two Sum Swift 코드 리뷰

## 1. 종합 평가

- **`twoSum2`가 이 문제의 가장 적절하고 정석적인 풀이입니다.**
  - 해시 테이블을 이용해 한 번의 순회로 `O(n)` 평균 시간 복잡도를 달성합니다.
  - LeetCode Two Sum 문제의 표준 접근법입니다.

- **`twoSum3`은 정렬 입력을 전제로 하면 좋은 풀이입니다.**
  - 정렬된 배열이라면 two-pointer로 `O(n)` 시간, 추가 공간 `O(1)` 개념의 풀이가 가능합니다.
  - 하지만 현재 코드는 `nums.enumerated().sorted(...)`를 사용하므로 정렬 복사 비용 때문에 전체적으로 `O(n log n)`입니다.

- **`twoSum`은 정답이지만 불필요하게 복잡하고 성능도 열위입니다.**
  - 정렬 후 각 요소마다 binary search를 수행하므로 `O(n log n)`입니다.
  - `twoSum3`처럼 정렬 후 two-pointer로 쓰는 것이 더 단순하고 효율적입니다.

---

## 2. 시간 복잡도 / 공간 복잡도 분석

| 함수 | 시간 복잡도 | 공간 복잡도 | 비고 |
|---|---:|---:|---|
| `twoSum` | `O(n log n)` | `O(n)` | 정렬 + 각 요소별 binary search |
| `twoSum2` | 평균 `O(n)` | `O(n)` | 해시 테이블 기반 1-pass |
| `twoSum3` | `O(n log n)` | `O(n)` | 정렬 + two-pointer |

### 2.1. `twoSum`

```swift
let pairs = nums.enumerated().sorted { $0.element < $1.element }
```

- 정렬: `O(n log n)`
- 외부 루프: 최대 `n - 1`회
- 내부 binary search: `O(log n)`

따라서 전체 시간 복잡도는:

```text
O(n log n) + O(n log n) = O(n log n)
```

공간 복잡도는 `pairs` 배열을 생성하므로 `O(n)`입니다.

### 2.2. `twoSum2`

```swift
var pool: [Int: Int] = [:]
```

- 한 번의 `for` 루프: `O(n)`
- `Dictionary` 조회/저장은 평균 `O(1)`

따라서 전체 시간 복잡도는:

```text
평균 O(n)
```

공간 복잡도는 `pool`에 최대 `n`개 키를 저장하므로:

```text
O(n)
```

Swift의 `Dictionary`는 해시 충돌이 극단적으로 발생할 경우 이론상 최악 `O(n)` 조회가 가능하지만, LeetCode Two Sum의 제약 조건과 `Int` 해시 특성상 사실상 `O(1)`로 보는 것이 일반적입니다.

### 2.3. `twoSum3`

```swift
let pairs = nums.enumerated().sorted { $0.element < $1.element }
```

- 정렬: `O(n log n)`
- two-pointer while 루프: `O(n)`

따라서 전체 시간 복잡도는:

```text
O(n log n)
```

공간 복잡도는 `pairs`를 새로 만들므로 `O(n)`입니다.

단, **입력이 이미 정렬되어 있고 배열 복사를 하지 않는다면** two-pointer는 개념적으로:

```text
시간 O(n), 추가 공간 O(1)
```

이 될 수 있습니다.

---

## 3. 문제 유형과 정석 풀이

LeetCode 1. Two Sum은 다음 유형입니다.

- **해시 테이블 기반 lookup**
- **정렬 입력 기반 two-pointer**

DP, 그래프, 분할 정복 같은 접근은 이 문제에는 특히 적합하지 않습니다.

### 3.1. unsorted 입력: 해시 테이블

LeetCode 기본 Two Sum은 배열이 정렬되어 있지 않습니다.  
이 경우 정석은 해시 테이블입니다.

핵심 아이디어:

```text
현재 값 number에 대해 target - number가 이전에出现过하는지 확인
```

즉:

```swift
let complement = target - value
```

을 계산하고, `complement`가 이미 저장된 값인지 확인합니다.

이 방식은:

- 한 번만 순회
- 자기 자신과 같은 인덱스를 재사용하지 않도록 가능
- 중복 값, 음수, 큰 수, 작은 수 모두 자연스럽게 처리

할 수 있습니다.

### 3.2. sorted 입력: two-pointer

입력이 정렬되어 있다면:

```text
left = 0
right = n - 1
```

로 시작하여:

- 합이 `target`보다 작으면 `left += 1`
- 합이 `target`보다 크면 `right -= 1`
- 같으면 정답

하는 two-pointer가 정석입니다.

코드에서 `twoSum3`이 이 아이디어를 잘 구현하고 있습니다.

---

## 4. 코드별 리뷰

## 4.1. `twoSum`

```swift
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    let pairs = nums.enumerated().sorted { $0.element < $1.element }

    for i in 0..<pairs.count - 1 {
        var left = i + 1
        var right = pairs.count - 1
        let searching = target - pairs[i].element

        while left <= right {
            let mid = (left + right) / 2

            if pairs[mid].element == searching {
                return [pairs[i].offset, pairs[mid].offset]
            } else if pairs[mid].element < searching {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
    }

    return []
}
```

### 장점

- 음수, 중복 값, 정렬되지 않은 입력을 모두 처리합니다.
- `i + 1`부터 binary search하므로 같은 인덱스를 두 번 사용하지 않습니다.
- 정확성 면에서는 LeetCode 제약을 만족합니다.

### 단점

1. **최적 복잡도가 아닙니다.**
   - `twoSum2`의 평균 `O(n)`보다 느립니다.

2. **`twoSum3`보다도 불필요하게 복잡합니다.**
   - 정렬을 이미 했다면 binary search보다 two-pointer가 더 단순하고 빠릅니다.

3. **빈 배열 안전성**
   - `0..<pairs.count - 1`은 `nums`가 비어 있을 경우 upper bound가 음수가 될 수 있습니다.
   - LeetCode 제약상 `nums.count >= 2`이지만, 재사용 가능한 API라면 `guard`로 방어하는 것이 좋습니다.

4. **반환 인덱스 순서**
   - 문제에서는 인덱스 순서를 보장하지 않지만, `[pairs[i].offset, pairs[mid].offset]`은 값 기준으로 정렬된 순서일 뿐 인덱스 크고 작음과는 무관합니다.
   - 테스트가 특별판정이라면 문제없지만, 가독성을 위해 `[min, max]`로 반환하는 것도 좋습니다.

### 개선 방향

- LeetCode 제출용이라면 이 함수를 해시 테이블 풀이로 교체하거나
- 학습용으로 유지하되 `twoSum3`보다 우선순위가 낮습니다.

---

## 4.2. `twoSum2`

```swift
func twoSum2(_ nums: [Int], _ target: Int) -> [Int] {
    var pool: [Int: Int] = [:]

    for (offset, number) in nums.enumerated() {
        let searching = target - number

        if let candidate = pool[searching] {
            return [offset, candidate]
        }

        pool[number] = offset
    }

    return []
}
```

### 장점

- **이 문제의 정석 풀이입니다.**
- 한 번의 순회로 해결합니다.
- 자기 자신과 같은 인덱스를 재사용하지 않습니다.
  - 현재 값을 `pool`에 넣기 전에 `searching`을 조회하기 때문입니다.
- 음수, 중복 값, 큰 값, 작은 값을 모두 자연스럽게 처리합니다.
- Swift적으로도 자연스럽습니다.
  - `enumerated()`
  - `Dictionary`
  - `if let`
  - value type 기반 처리

이 코드가 최종적으로 제출해야 할 풀이에 가장 가깝습니다.

### 개선 가능한 부분

#### 1. `guard nums.count >= 2` 추가

LeetCode 제약상 `nums.count >= 2`이지만, 함수를 일반 API처럼 사용하려면 안전합니다.

```swift
guard nums.count >= 2 else { return [] }
```

#### 2. `reserveCapacity`

사전 할당을 통해 rehash 비용을 줄일 수 있습니다.

```swift
pool.reserveCapacity(nums.count)
```

#### 3. 반환 인덱스 순서

현재:

```swift
return [offset, candidate]
```

`candidate`는 반드시 `offset`보다 작은 이전 인덱스입니다.  
따라서:

```swift
return [candidate, offset]
```

이렇게 하면 인덱스가 오름차순이 되어 가독성이 더 좋습니다.  
LeetCode는 순서를 특별하게 요구하지 않지만, 정돈된 반환 형태는 좋습니다.

#### 4. 중복 값 처리 정책

현재:

```swift
pool[number] = offset
```

는 같은 값이 여러 번 나오면 **가장 최근 인덱스**로 덮어씁니다.

이것은 LeetCode Two Sum에는 문제없습니다.  
왜냐하면 어떤 유효한 이전 인덱스만 있으면 되기 때문입니다.

하지만 **가장 작은 인덱스 쌍을 반환하고 싶다면** 첫 번째 인덱스를 유지하는 것이 좋습니다.

```swift
if pool[number] == nil {
    pool[number] = offset
}
```

또는:

```swift
pool[number] = pool[number] ?? offset
```

#### 5. 변수명

`pool`보다는 의도가 더 명확한 이름이 좋습니다.

예:

```swift
var seen: [Int: Int] = [:]
var seenIndex: [Int: Int] = [:]
var valueToIndex: [Int: Int] = [:]
```

`searching`도 `complement`가 더 일반적입니다.

#### 6. 오버플로 고려

```swift
let searching = target - number
```

이 줄에서 `Int` 오버플로가 발생할 수 있습니다.

LeetCode Two Sum의 제약 조건에서는 보통 안전하지만, Swift에서 `Int` 오버플로는 trap이 될 수 있으므로 매우 넓은 범위 값을 다룬다면 주의가 필요합니다.

예를 들어:

```swift
let a = Int.min
let b = Int.max
let c = a - b // trap 가능
```

일반 LeetCode 제출에서는 크게 신경 쓸 필요는 없지만, 리뷰 관점에서는 언급할 가치가 있습니다.

---

## 4.3. `twoSum3`

```swift
func twoSum3(_ nums: [Int], _ target: Int) -> [Int] {
    let pairs = nums.enumerated().sorted { $0.element < $1.element }

    var left = 0
    var right = pairs.count - 1

    while left < right {
        let current = pairs[left].element + pairs[right].element

        if current == target {
            return [pairs[left].offset, pairs[right].offset]
        } else if current < target {
            left += 1
        } else {
            right -= 1
        }
    }

    return []
}
```

### 장점

- two-pointer 알고리즘을 정확히 적용했습니다.
- 정렬된 값 기준에서 합이 작으면 `left`를 올리고, 크면 `right`를 내리는 로직이 맞습니다.
- `left < right` 조건으로 같은 인덱스를 두 번 사용하지 않습니다.
- 음수, 중복 값도 처리됩니다.

### 단점

1. **unsorted 입력에서는 최적 아님**
   - 정렬 비용 `O(n log n)`이 발생합니다.
   - LeetCode Two Sum은 unsorted이므로 해시 테이블이 더 적합합니다.

2. **현재 코드에서는 공간 `O(n)`**
   - `nums.enumerated().sorted(...)`가 새 배열을 만듭니다.
   - 이미 정렬된 배열을 받는 함수라면 추가 공간 `O(1)`이 될 수 있지만, 현재 시그니처에서는 `O(n)`입니다.

3. **합 계산 시 오버플로 가능성**

```swift
let current = pairs[left].element + pairs[right].element
```

극단적인 `Int` 값에서는 오버플로가可能发生합니다.

LeetCode 제약상 보통 안전하지만, 리뷰 관점에서는:

```swift
let current = Int64(pairs[left].element) + Int64(pairs[right].element)
```

처럼 안전하게 처리할 수 있습니다.

다만 Swift의 `Int`가 64-bit인 환경에서 `Int64`로 올려도 두 값의 합이 `Int64` 범위를 벗어나면 여전히 오버플로할 수 있으므로, 완전한 보장은 아닙니다. 하지만 LeetCode 수준에서는 실질적으로 안전성이 올라갑니다.

4. **반환 인덱스 순서**

```swift
return [pairs[left].offset, pairs[right].offset]
```

이것은 값 기준 left/right 순서이지, 인덱스 순서는 아닙니다.  
원하면:

```swift
let a = pairs[left].offset
let b = pairs[right].offset
return a < b ? [a, b] : [b, a]
```

로 반환할 수 있습니다.

---

## 5. 엣지 케이스 체크

| 엣지 케이스 | `twoSum` | `twoSum2` | `twoSum3` | 비고 |
|---|---|---|---|---|
| `nums`가 빈 배열 | 주의 필요 | 안전 | 안전 | `twoSum`은 `0..<pairs.count - 1` 부분에서 guard 권장 |
| `nums`가 1개 요소 | 안전 | 안전 | 안전 | `return []` |
| 음수 포함 | 안전 | 안전 | 안전 | 모두 처리 가능 |
| 중복 값 포함 | 안전 | 안전 | 안전 | 동일 값 두 개가 target을 만들 수 있음 |
| 같은 인덱스 두 번 사용 | 방지됨 | 방지됨 | 방지됨 | `twoSum2`는 조회 후 저장, `twoSum3`은 `left < right` |
| 해 없음 | `return []` | `return []` | `return []` | LeetCode는 보통 해가 있다고 보장 |
| 오버플로 | 주의 필요 | 주의 필요 | 주의 필요 | `target - value`, `value + value` |
| 반환 인덱스 순서 | 보장 없음 | 보장 없음 | 보장 없음 | 문제에서는 보통 순서 무관 |

### 5.1. 중복 값

예:

```swift
nums = [3, 3]
target = 6
```

`twoSum2`:

```swift
offset 0, number 3
searching = 3
pool[3] 없음
pool[3] = 0

offset 1, number 3
searching = 3
pool[3] = 0
return [1, 0] 또는 개선하면 [0, 1]
```

정상 동작합니다.

### 5.2. 음수

예:

```swift
nums = [-1, -2, -3, -4, -5]
target = -8
```

해시 테이블과 two-pointer 모두 음수를正确处理합니다.

### 5.3. 같은 값 두 번 사용 불가

`twoSum2`가 중요한 이유는:

```swift
if let candidate = pool[searching] {
    return [offset, candidate]
}

pool[number] = offset
```

이 순서이기 때문입니다.

만약 저장 후 조회를 하면:

```swift
pool[number] = offset
if let candidate = pool[searching] { ... }
```

`number == searching`일 때 현재 인덱스 자신을 후보로 사용할 수 있어 버그가 됩니다.

현재 `twoSum2`는 이 부분을 올바르게 처리하고 있습니다.

---

## 6. Swift 언어적 특성 리뷰

### 잘한 부분

- `nums.enumerated()`를 사용해 인덱스 접근을 잘했습니다.
- `Dictionary`를 적절히 사용했습니다.
- `if let candidate = pool[searching]`을 사용해 Swift적인 optional handling을 했습니다.
- `let`으로 불변 값을 다수 선언했습니다.
- value type인 `Array`, `Dictionary`를 자연스럽게 사용했습니다.

### 더 Swift적으로 개선할 부분

#### 1. `guard`로 early return

```swift
guard nums.count >= 2 else { return [] }
```

Swift에서 early return을 통한 가독성 향상은 좋습니다.

#### 2. `reserveCapacity`

```swift
seen.reserveCapacity(nums.count)
```

성능 최적화 관점에서 좋습니다.

#### 3. 명확한 이름

```swift
var pool: [Int: Int] = [:]
```

보다는:

```swift
var seen: [Int: Int] = [:]
```

또는:

```swift
var valueToIndex: [Int: Int] = [:]
```

가 더 명확합니다.

#### 4. `complement`라는 명명

```swift
let searching = target - number
```

보다는:

```swift
let complement = target - number
```

가 이 문제의 의도를 더 잘 드러냅니다.

#### 5. 불필요한 여러 함수 분리

학습 코드라면 `twoSum`, `twoSum2`, `twoSum3`을 나열하는 것은 좋습니다.  
하지만 LeetCode 제출용이라면 `twoSum` 하나만 최종 정답으로 유지하는 것이 더 깔끔합니다.

LeetCode는 보통 `twoSum`을 호출하므로, 현재 코드에서 `twoSum`이 `O(n log n)` 풀이라면 `twoSum2` 로직을 `twoSum`으로 옮기는 것이 좋습니다.

---

## 7. 추천 최종 코드

LeetCode Two Sum 기준, unsorted 입력을 전제로 한 추천 코드는 다음과 같습니다.

```swift
class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        guard nums.count >= 2 else { return [] }

        var seen: [Int: Int] = [:]
        seen.reserveCapacity(nums.count)

        for (index, value) in nums.enumerated() {
            let complement = target - value

            if let previousIndex = seen[complement] {
                return [previousIndex, index]
            }

            // 같은 값이 여러 번 나오면 가장 첫 번째 인덱스를 유지
            if seen[value] == nil {
                seen[value] = index
            }
        }

        return []
    }
}
```

### 설명

- `seen[value] = index` 전에 `complement`를 조회하므로 같은 인덱스를 두 번 사용하지 않습니다.
- `if seen[value] == nil`은 중복 값에서 가장 첫 번째 인덱스를 유지합니다.
  - LeetCode에서는 `seen[value] = index`로 덮어써도 정답입니다.
  - 하지만 “가장 작은 인덱스 쌍”을 원한다면 첫 번째 인덱스를 유지하는 것이 더 안정적입니다.
- `return [previousIndex, index]`는 인덱스를 오름차순으로 반환합니다.
- `reserveCapacity`로 Dictionary 재할당을 줄입니다.
- `guard`로 빈 배열 또는 1개 요소 배열을 안전하게 처리합니다.

---

## 8. 정렬 입력 전제로 한 two-pointer 추천 코드

만약 문제가 이미 정렬된 배열을 전제로 한다면 `twoSum3` 방향이 정석입니다.

```swift
func twoSumSorted(_ nums: [Int], _ target: Int) -> [Int] {
    guard nums.count >= 2 else { return [] }

    var left = 0
    var right = nums.count - 1

    while left < right {
        let sum = nums[left] + nums[right]

        if sum == target {
            return [left, right]
        } else if sum < target {
            left += 1
        } else {
            right -= 1
        }
    }

    return []
}
```

이 경우:

```text
시간 O(n)
추가 공간 O(1)
```

입니다.

다만 현재 제출 코드의 `twoSum3`은 `nums.enumerated().sorted(...)`를 사용하므로 unsorted 입력을 정렬하는 데 `O(n log n)`과 `O(n)` 공간을 사용합니다.

---

## 9. 최종 의견

### LeetCode 제출 관점

- **`twoSum2`가 최종 제출 코드에 가장 적합합니다.**
- `twoSum` 함수 이름으로 해시 테이블 풀이를 제출하는 것이 좋습니다.
- `twoSum3`은 입력이 정렬되어 있을 때만 최적입니다.
- `twoSum`은 정답이지만 불필요하게 복잡하고 `O(n log n)`이라 최적 아님.

### 학습 코드 관점

- 세 가지 시도 모두 알고리즘적 가치가 있습니다.
  - `twoSum`: 정렬 + binary search
  - `twoSum2`: 해시 테이블
  - `twoSum3`: 정렬 + two-pointer
- 다만 최종 정리할 때는 다음처럼 구분하는 것이 좋습니다.
  - unsorted: 해시 테이블
  - sorted: two-pointer

### 최종 권장 방향

```text
LeetCode No.1 Two Sum
→ unsorted 입력
→ 해시 테이블 기반 O(n) 풀이
→ twoSum2를 twoSum으로 정리
```

추가로 `twoSum3`은 “정렬된 배열을 받는 변형 문제”로 분리해 두는 것이 좋습니다.