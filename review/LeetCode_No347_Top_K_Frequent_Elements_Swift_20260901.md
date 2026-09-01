# LeetCode No.347 Top K Frequent Elements Code Review

# LeetCode No.347 Top K Frequent Elements Swift 코드 리뷰

## 1. 결론 요약

현재 코드는 **유효한 입력 조건에서는 정상 동작하는 풀이**입니다.  
주요 흐름은 다음과 같습니다.

1. `nums`에서 각 숫자의 등장 횟수를 카운트한다.
2. 등장 횟수 기준으로 키를 정렬한다.
3. 정렬된 배열의 뒤에서 `k`개를 꺼낸다.

이 방식은 직관적이고 구현이 간단하며, LeetCode 문제에서 통과할 가능성이 높습니다.  
다만 아래 부분들은 개선이 가능합니다.

- **시간 복잡도**: 전체 정렬을 수행하므로 `k`가 작을 때 비효율적입니다.
- **Swift 관용적 코드**: `force unwrap`, 불필요한 `if let`, 오타, `reserveCapacity` 누락 등이 있습니다.
- **엣지 케이스**: `k`가 유효하지 않거나 `nums`가 비어 있는 경우 크래시가 발생할 수 있습니다.
- **정석 최적 풀이**: 이 문제는 `Frequency Count + Heap` 또는 `Bucket Sort`가 더 적합합니다.

---

## 2. 시간 복잡도 분석

### 현재 코드

```swift
var occurences: [Int: Int] = [:]

for num in nums {
    if let occurence = occurences[num] {
        occurences[num] = occurence + 1
    } else {
        occurences[num] = 1
    }
}

var result = occurences.keys.sorted { occurences[$0]! < occurences[$1]! }

var answer: [Int] = []
var k = k

while k > 0 {
    answer.append(result.removeLast())
    k -= 1
}
```

각 단계별 복잡도는 다음과 같습니다.

| 단계 | 복잡도 |
|---|---:|
| 등장 횟수 카운트 | `O(n)` |
| 고유 숫자 `m`개 정렬 | `O(m log m)` |
| `k`개 추출 | `O(k)` |

여기서 `m`은 `nums`에 포함된 고유 숫자의 개수이며, `m <= n`입니다.

따라서 전체 시간 복잡도는:

```text
O(n + m log m + k)
```

최악 경우:

```text
O(n log n)
```

### 문제점

이 문제는 **Top-K Frequent Elements** 문제입니다.  
`k`가 전체 고유 숫자 개수에 비해 매우 작은 경우, 전체를 정렬하는 것은 비효율적입니다.

예를 들어:

```text
nums.length = 1,000,000
k = 1
```

이 경우에도 현재 코드는 모든 고유 값을 정렬합니다.

### 최적화 방향

#### 1. Heap 기반 풀이

최대 빈도 `k`개를 유지하는 min-heap을 사용할 수 있습니다.

```text
O(n + k log m)
```

`k`가 작을 때 유리합니다.

단, Swift 표준 라이브러리에는 heap이 기본 제공되지 않으므로 직접 구현해야 합니다.

#### 2. Bucket Sort 기반 풀이

각 숫자의 빈도는 `1` 이상 `n` 이하입니다.  
그래서 빈도별로 버킷을 만들고, 큰 빈도부터 내려가면 됩니다.

```text
O(n)
```

이 문제에서는 **Bucket Sort**가 가장 정석적인 최적 풀이 중 하나입니다.

---

## 3. 공간 복잡도 분석

### 현재 코드

| 저장 구조 | 공간 복잡도 |
|---|---:|
| `occurences` dictionary | `O(m)` |
| `result` sorted keys array | `O(m)` |
| `answer` result array | `O(k)` |

전체 공간 복잡도:

```text
O(m)
```

또는:

```text
O(n)
```

`m <= n`이므로 `O(n)`이라고 표현해도 무방합니다.

### 개선 가능성

공간 복잡도는 크게 나쁘지 않습니다.  
다만 `result` 전체를 만든 뒤 `removeLast()`를 반복하는 방식은 불필요하게 중간 결과를 유지합니다.

Swift에서는:

```swift
Array(sorted.prefix(k))
```

또는 버킷 정렬을 사용하는 것이 더 간결하고 효율적입니다.

---

## 4. 문제 유형에 맞는 정석 풀이

이 문제는 DP나 그래프 문제가 아니라, **Frequency / Top-K** 유형입니다.

### 핵심 접근법

1. **Hash Map으로 빈도 수 계산**
2. 빈도 수를 기준으로 Top-K 추출

### 방법 1: Sorting

```text
Frequency Count + Sort
```

현재 코드가 사용 중인 방식입니다.

- 장점: 구현이 간단
- 단점: `O(n log n)`

### 방법 2: Heap

```text
Frequency Count + Min-Heap of size k
```

- 장점: `k`가 작을 때 효율적
- 단점: Swift에는 기본 heap이 없음

### 방법 3: Bucket Sort

```text
Frequency Count + Bucket Sort
```

- 장점: `O(n)` 달성 가능
- 장점: 이 문제에서 가장 정석적인 최적 풀이 중 하나
- 단점: 빈도 최대치 `n` 크기의 버킷 배열을 만들므로 공간이 `O(n)`

이 문제에서 **최적 정석 풀이**로는 Bucket Sort를 권장합니다.

---

## 5. 현재 코드별 문제점

### 5.1 변수 이름 오타

```swift
var occurences: [Int: Int] = [:]
```

`occurences`는 `occurrences`로 쓰는 것이 일반적입니다.

또한:

```swift
if let occurence = occurences[num]
```

의 `occurence`도 `occurrence`가 적절합니다.

### 권장

```swift
var occurrences: [Int: Int] = [:]
```

---

### 5.2 `if let` 분리가 불필요함

현재:

```swift
for num in nums {
    if let occurence = occurences[num] {
        occurences[num] = occurence + 1
    } else {
        occurences[num] = 1
    }
}
```

Swift에서는 dictionary의 default subscript를 사용할 수 있습니다.

### 권장

```swift
for num in nums {
    occurrences[num, default: 0] += 1
}
```

또는:

```swift
let occurrences = nums.reduce(into: [Int: Int]()) {
    $0[$1, default: 0] += 1
}
```

두 번째 방식은 더 idiomatic합니다.

---

### 5.3 `force unwrap` 사용

```swift
var result = occurences.keys.sorted { occurences[$0]! < occurences[$1]! }
```

`$0`, `$1`은 `occurences.keys`에서 가져온 값이므로 실제로는 crash하지 않습니다.  
하지만 `force unwrap`은 Swift 코드 리뷰 관점에서 피하는 것이 좋습니다.

### 개선 방법 1: default subscript 사용

```swift
let result = occurrences.keys.sorted {
    occurrences[$0, default: 0] < occurrences[$1, default: 0]
}
```

### 개선 방법 2: 빈도와 키를 함께 정렬

```swift
let sorted = occurrences
    .map { ($0.key, $0.value) }
    .sorted { $0.1 > $1.1 }

return Array(sorted.prefix(k).map { $0.0 })
```

이 방식은 comparator에서 dictionary lookup을 반복하지 않아 더 깔끔하고 효율적입니다.

---

### 5.4 정렬 방향과 추출 방식

현재 코드는:

```swift
var result = occurences.keys.sorted { occurences[$0]! < occurences[$1]! }

while k > 0 {
    answer.append(result.removeLast())
    k -= 1
}
```

즉, 오름차순으로 정렬한 뒤 뒤에서 `k`개를 꺼냅니다.

이 방식은 동작하지만, Swift에서는 더 명확한 표현이 가능합니다.

### 권장 1: 내림차순 정렬 후 `prefix(k)`

```swift
let sorted = occurrences
    .map { ($0.key, $0.value) }
    .sorted { $0.1 > $1.1 }

return Array(sorted.prefix(k).map { $0.0 })
```

### 권장 2: 오름차순 정렬 후 `suffix(k)`

```swift
let sorted = occurrences
    .map { ($0.key, $0.value) }
    .sorted { $0.1 < $1.1 }

return Array(sorted.suffix(k).map { $0.0 })
```

다만 Top-K 문제에서는 **내림차순 정렬 후 `prefix(k)`**가 의도가 더 명확합니다.

---

### 5.5 `reserveCapacity` 누락

```swift
var answer: [Int] = []
```

`answer`에 `k`개까지 넣을 것이므로:

```swift
answer.reserveCapacity(k)
```

을 사용하는 것이 좋습니다.

다만 `k`가 음수이거나 매우 큰 값일 수 있으므로 안전하게 쓰려면:

```swift
answer.reserveCapacity(min(k, occurrences.count))
```

이 더 좋습니다.

---

### 5.6 `var k = k` shadowing

```swift
var k = k
```

파라미터 `k`를 지역 변수로 shadow하고 있습니다.  
동작에는 문제가 없지만, 의도가 명확하지 않습니다.

### 권장

```swift
var remaining = k
```

또는 `prefix(k)`를 사용하면 `k`를 직접 수정할 필요가 없습니다.

---

### 5.7 엣지 케이스 처리 부족

#### 경우 1: `k == 0`

현재 코드:

```swift
while k > 0 { ... }
```

`k == 0`이면 아무것도 추가하지 않고 빈 배열을 반환합니다.

문제 조건에서 `k >= 1`이면 괜찮지만, 방어적으로 쓰려면:

```swift
guard k > 0 else { return [] }
```

을 추가하는 것이 좋습니다.

#### 경우 2: `k < 0`

현재 코드는 `while k > 0`이므로 빈 배열을 반환합니다.  
하지만 문제 조건상 음수 `k`는 의미 없을 수 있습니다.

방어적 코드로는:

```swift
guard k > 0 else { return [] }
```

이 적절합니다.

#### 경우 3: `nums`가 비어 있고 `k > 0`

현재 코드:

```swift
var result = occurences.keys.sorted { ... }
```

`occurences`가 빈 dictionary이면 `result`도 빈 배열입니다.

그 후:

```swift
while k > 0 {
    answer.append(result.removeLast())
    k -= 1
}
```

`result`가 비어 있으므로 `removeLast()`에서 crash할 수 있습니다.

#### 경우 4: `k`가 고유 숫자 개수보다 큰 경우

예:

```swift
nums = [1, 1, 1]
k = 2
```

고유 숫자는 `1`개뿐입니다.  
현재 코드는 `result`에 `[1]`만 있고, `k = 2`이므로:

```swift
result.removeLast() // 1회 성공
result.removeLast() // crash
```

할 수 있습니다.

LeetCode 문제 조건에서 `k`가 항상 유효하다면 문제가 없지만, robust한 코드로는:

```swift
Array(sorted.prefix(k))
```

또는:

```swift
Array(result.suffix(k))
```

을 사용하는 것이 안전합니다.

---

## 6. Swift 관용적 코드 관점

### 현재 코드에서 개선할 Swift적 표현

| 항목 | 현재 코드 | 권장 |
|---|---|---|
| dictionary increment | `if let` / `else` | `occurrences[num, default: 0] += 1` |
| force unwrap | `occurences[$0]!` | default subscript 또는 tuple 정렬 |
| Top-K 추출 | `while` + `removeLast()` | `prefix(k)` 또는 `suffix(k)` |
| 배열 공간 예약 | 없음 | `reserveCapacity` |
| 이름 | `occurences` | `occurrences` |
| 불변성 | 가능하면 `let` 사용 | `occurrences`, `sorted`를 `let`으로 |
| shadowing | `var k = k` | `remaining` 또는 `prefix(k)` |

---

## 7. 개선 예시

## 7.1 간결한 `O(n log n)` 풀이

```swift
class Solution {
    func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
        guard k > 0 else {
            return []
        }

        var occurrences: [Int: Int] = [:]
        for num in nums {
            occurrences[num, default: 0] += 1
        }

        let sorted = occurrences
            .map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }

        return Array(sorted.prefix(k).map { $0.0 })
    }
}
```

### 장점

- force unwrap 없음
- `if let` 분기 없음
- `prefix(k)`로 Top-K 추출이 명확함
- `k == 0`, `k < 0`, `k`가 고유 값 개수보다 큰 경우에도 크래시 없이 동작함

### 단점

- 여전히 전체 정렬을 수행하므로 `O(n log n)`
- `k`가 매우 작을 때는 최적 아님

---

## 7.2 `O(n)` Bucket Sort 풀이

이 문제에서 가장 권장하는 최적 풀이입니다.

```swift
class Solution {
    func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
        guard k > 0 else {
            return []
        }

        var occurrences: [Int: Int] = [:]
        for num in nums {
            occurrences[num, default: 0] += 1
        }

        let maxCount = occurrences.values.max() ?? 0
        var buckets = [[Int]](repeating: [], count: maxCount + 1)

        for (num, count) in occurrences {
            buckets[count].append(num)
        }

        var answer: [Int] = []
        answer.reserveCapacity(min(k, occurrences.count))

        for count in stride(from: maxCount, through: 1, by: -1) {
            for num in buckets[count] {
                answer.append(num)
                if answer.count == k {
                    return answer
                }
            }
        }

        return answer
    }
}
```

### 동작 방식

1. 각 숫자의 빈도를 계산한다.
2. `buckets[count]`에 빈도가 `count`인 숫자들을 넣는다.
3. 가장 높은 빈도부터 내려가며 `k`개를 채운다.

### 시간 복잡도

```text
O(n)
```

### 공간 복잡도

```text
O(n)
```

### 장점

- 정렬을 사용하지 않음
- Top-K frequent 문제에서 정석적인 최적 풀이
- `k`가 작을 때도 효율적
- LeetCode 347에서 권장하는 풀이 방식 중 하나

### 단점

- `maxCount + 1` 크기의 bucket 배열을 만듦
- Swift에서 빈 `[[Int]]` 배열을 많이 만들면 메모리 오버헤드가 있을 수 있음
- 다만 이 문제에서는 일반적으로 허용되는 범위

---

## 8. 엣지 케이스 정리

| 입력 | 현재 코드 동작 | 개선 코드 동작 |
|---|---|---|
| `nums = []`, `k = 0` | `[]` | `[]` |
| `nums = []`, `k = 1` | crash 가능 | `[]` |
| `k = 0` | `[]` | `[]` |
| `k < 0` | `[]` | `[]` |
| `k > 고유 숫자 개수` | crash 가능 | 가능한 개수만큼 반환 |
| 모든 숫자가 동일 | 정상 | 정상 |
| 빈도 동률 | 순서 보장 없음 | 순서 보장 없음 |
| `k == 고유 숫자 개수` | 정상 | 정상 |

문제에서는 빈도가 같은 경우 순서를 요구하지 않으므로, 빈도 동률인 값의 순서는 보장되지 않아도 됩니다.

만약 deterministic한 순서가 필요하면 빈도 이후에 숫자 값으로 추가 정렬하면 됩니다.

예:

```swift
.sorted {
    if $0.1 != $1.1 {
        return $0.1 > $1.1
    }
    return $0.0 < $1.0
}
```

하지만 LeetCode 347에서는 일반적으로 불필요합니다.

---

## 9. 최종 평가

### 현재 코드 등급

```text
합격은 가능하지만, 최적화 및 Swift 관용적 코드 개선 필요
```

### 장점

- 문제 의도를 정확히 이해한 풀이
- 구현이 직관적
- 유효한 입력에서는 정상 동작
- 공간 복잡도가 합리적

### 단점

- `O(n log n)`이라 `k`가 작을 때 비효율적
- `force unwrap` 사용
- `if let` 분리가 불필요
- `reserveCapacity` 누락
- `k`가 유효하지 않을 때 crash 가능
- 변수 이름 오타
- Top-K 문제에 더 적합한 Bucket Sort 또는 Heap 고려 필요

### 최종 권장

실무나 인터뷰 관점에서 가장 좋은 개선 방향은 다음과 같습니다.

```text
1단계: force unwrap 제거 및 dictionary default subscript 사용
2단계: prefix(k)로 Top-K 추출 개선
3단계: O(n) Bucket Sort로 최적화
```

LeetCode 347에서는 **Bucket Sort**를 사용할 수 있다면 그것이 가장 정석적인 최적 풀이입니다.