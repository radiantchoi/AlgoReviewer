# LeetCode No.217 Contains Duplicate Code Review

# LeetCode 217. Contains Duplicate 리뷰

## 1. 요약

제시된 코드는 **HashSet을 사용하여 중복 요소가 존재하는지 O(n) 시간에 판별**하는 전형적이고 적절한 풀이입니다.  
Swift 코드로서도 동작은 명확하고, 문제의 핵심 요구사항을 잘 반영하고 있습니다.

다만, 아래 부분을 조금만 다듬으면 더 완성도 높은 코드가 됩니다.

- 변수명 `occured`는 철학적으로 `occurred` 또는 `seen`이 더 명확합니다.
- `Set`의 초기 용량 힌트를 줄 수 있습니다.
- 정렬 기반 풀이도 대안으로 고려할 수 있습니다.

---

## 2. 시간 복잡도

### 현재 코드

```swift
for num in nums {
    if occured.contains(num) { return true }
    occured.insert(num)
}
```

- `Set.contains`와 `Set.insert`는 평균적으로 **O(1)** 입니다.
- 전체 배열을 한 번만 순회하므로 시간 복잡도는:

```text
O(n)
```

여기서 `n`은 `nums.count`입니다.

### 최적화 가능성

현재 풀이는 이 문제에서 사실상 **최적 시간 복잡도**에 도달해 있습니다.  
중복 여부를 판별하기 위해 모든 요소를 최소 한 번은 확인해야 하므로,

```text
하한: Ω(n)
```

입니다. 따라서 `O(n)`은 이론적으로 더 개선할 여지가 없습니다.

---

## 3. 공간 복잡도

### 현재 코드

`Set<Int>`에 최대 `n`개의 요소를 저장할 수 있으므로:

```text
O(n)
```

입니다.

### 대안

추가 공간을 줄이려면 `nums`를 정렬한 뒤 인접한 두 원소를 비교하는 방법도 있습니다.

```swift
func containsDuplicate(_ nums: [Int]) -> Bool {
    var sorted = nums
    sorted.sort()

    for i in 1..<sorted.count {
        if sorted[i] == sorted[i - 1] {
            return true
        }
    }

    return false
}
```

이 경우:

```text
시간 복잡도: O(n log n)
공간 복잡도: O(n) 또는 O(1)
```

Swift의 `sort()`는 in-place가 아니기 때문에 복사본을 만들면 `O(n)` 추가 공간이 필요합니다.  
단, 문제가 배열을 무조건 복사해서 정렬해도 되는지, mutable copy가 허용되는지에 따라 해석이 다를 수 있습니다.

LeetCode 환경에서는 현재 `Set` 풀이가 더 일반적이고, 시간 복잡도 측면에서도 우수합니다.

---

## 4. 정석 풀이

이 문제는 대표적인 **Hashing** 문제입니다.

### 정석 1: HashSet 사용

가장 일반적인 정석 풀이입니다.

```swift
class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var seen = Set<Int>()

        for num in nums {
            if seen.contains(num) {
                return true
            }
            seen.insert(num)
        }

        return false
    }
}
```

장점:

- 구현이 단순합니다.
- 시간 복잡도 `O(n)`
- Swift에서 자연스럽게 사용할 수 있습니다.

### 정석 2: 정렬 후 인접 비교

```swift
class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var nums = nums
        nums.sort()

        for i in 1..<nums.count {
            if nums[i] == nums[i - 1] {
                return true
            }
        }

        return false
    }
}
```

장점:

- 해시 테이블을 사용하지 않습니다.
- 공간 복잡도를 줄이는 관점에서 의미 있는 대안입니다.

단점:

- 시간 복잡도가 `O(n log n)`입니다.
- Swift에서 `sort()`가 in-place가 아니므로 복사본이 필요합니다.

이 문제에서는 **HashSet 풀이가 더 정석에 가깝고 실용적입니다.**

---

## 5. 현재 풀이의 적절성

### 좋은 점

1. **문제 의도에 정확히 부합합니다.**
   - 중복이 있는지 여부는 `Set`으로 판별하는 것이 가장 자연스럽습니다.

2. **조기 반환(early return)을 잘 활용하고 있습니다.**
   - 중복을 발견하는 즉시 `return true`을 호출하므로 불필요한 순회를 줄입니다.

3. **Swift의 컬렉션 API를 자연스럽게 사용하고 있습니다.**
   - `Set<Int>`
   - `contains(_:)`
   - `insert(_:)`
   - `for-in` 루프

이 모두 Swift에서 충분히 idiomatic한 표현입니다.

4. **엣지 케이스 처리가 무난합니다.**

   - `nums`가 빈 배열이면 `for` 루프가 실행되지 않아 `false` 반환
   - `nums`에 요소가 하나만 있으면 중복이 없으므로 `false` 반환
   - 모든 요소가 동일하면 두 번째 요소에서 `true` 반환
   - `Int` 범위 내 숫자라면 해시 처리에 문제 없음

---

## 6. 개선 가능한 부분

### 6.1 변수명: `occured` → `seen` 또는 `occurred`

현재:

```swift
var occured = Set<Int>()
```

`occured`는 `occurred`의 오타로 보입니다.  
또한 의미 전달 측면에서는 `seen`이 더 직관적입니다.

권장:

```swift
var seen = Set<Int>()
```

또는:

```swift
var occurred = Set<Int>()
```

중복 판별 문제에서는 `seen`이 가장 흔하고 명확합니다.

---

### 6.2 Set 초기 용량 힌트

Swift의 `Set`은 초기 용량 힌트를 줄 수 있습니다.

```swift
var seen = Set<Int>(minReservingCapacity: nums.count)
```

이것은 재할당을 줄여 성능을 약간 개선할 수 있습니다.

다만, LeetCode 문제에서는 필수적이지 않고, 가독성 저하 없이 사용할 수 있으므로 선택 사항입니다.

개선 코드:

```swift
class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var seen = Set<Int>(minReservingCapacity: nums.count)

        for num in nums {
            if seen.contains(num) {
                return true
            }
            seen.insert(num)
        }

        return false
    }
}
```

---

### 6.3 가독성 개선

현재 코드는 이미 짧고 명확하지만, 한 줄을 더 분리하면 의도가 더 선명해집니다.

현재:

```swift
if occured.contains(num) { return true }
```

권장:

```swift
if seen.contains(num) {
    return true
}
```

Swift 코드 리뷰 관점에서는 무조건 한 줄이 좋다고 보지 않습니다.  
단순 조건문이지만, 리뷰어 입장에서 가독성과 일관성은 중요합니다.

---

## 7. Swift 언어적 특성 / Idiomatic Code

### 잘 사용된 부분

```swift
var occured = Set<Int>()
for num in nums { ... }
occured.contains(num)
occured.insert(num)
```

이 부분은 Swift에서 매우 자연스럽습니다.

### 더 idiomatic하게 다듬을 수 있는 부분

#### 변수명

```swift
var seen = Set<Int>()
```

#### Set 용량 힌트

```swift
var seen = Set<Int>(minReservingCapacity: nums.count)
```

#### 조건문 형태

```swift
if seen.contains(num) {
    return true
}
```

### 최종 권장 Swift 코드

```swift
class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var seen = Set<Int>(minReservingCapacity: nums.count)

        for num in nums {
            if seen.contains(num) {
                return true
            }
            seen.insert(num)
        }

        return false
    }
}
```

---

## 8. 대체 풀이: 정렬 기반

```swift
class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var sorted = nums
        sorted.sort()

        for i in 1..<sorted.count {
            if sorted[i] == sorted[i - 1] {
                return true
            }
        }

        return false
    }
}
```

### 특징

- 시간 복잡도: `O(n log n)`
- 추가 공간: Swift 기준 `O(n)`
- 해시 테이블을 사용하지 않습니다.

### 사용 시점

- 추가 공간을 극도로 절약하고 싶은 경우
- `n`이 작거나 정렬이 허용되는 경우
- Hashing보다 정렬이 더 자연스러운 문제 유형일 때

하지만 LeetCode 217에서는 일반적으로 **HashSet 풀이가 더 우수합니다.**

---

## 9. 최종 평가

| 항목 | 평가 |
|---|---|
| 시간 복잡도 | `O(n)`, 최적 |
| 공간 복잡도 | `O(n)`, 허용 범위 내 |
| 알고리즘 적절성 | 매우 적절, 정석 풀이 |
| 엣지 케이스 | 빈 배열, 1개 요소, 전체 중복 등 정상 처리 |
| Swift idiomatic | 대체로 양호, 변수명과 소소한 가독성 개선 가능 |
| 개선 필요도 | 낮음 |

### 총평

제시된 코드는 **LeetCode 217에 대한 매우 적합한 풀이**입니다.  
핵심 알고리즘은 이미 정석에 가까우며, 큰 설계 변경은 필요하지 않습니다.

가장 권장되는 수정은 다음과 같습니다.

```swift
class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var seen = Set<Int>(minReservingCapacity: nums.count)

        for num in nums {
            if seen.contains(num) {
                return true
            }
            seen.insert(num)
        }

        return false
    }
}
```

이렇게 다듬으면 시간 복잡도, 공간 복잡도, 가독성, Swift idiomatic함에서 모두 균형 잡힌 코드가 됩니다.