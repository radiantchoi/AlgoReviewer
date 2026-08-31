# LeetCode No.217 Contains Duplicate Code Review

# LeetCode No.217 Contains Duplicate 코드 리뷰

## 1. 총평

제시된 코드는 **정답적으로 동작합니다**.

```swift
class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var occured: [Int: Bool] = [:]

        for num in nums {
            if let occurence = occured[num] {
                return true
            } else {
                occured[num] = true
            }
        }

        return false
    }
}
```

- 해시를 기반으로 중복 여부를 확인하는 올바른 접근입니다.
- 시간 복잡도는 평균적으로 **O(n)** 입니다.
- 다만 Swift에서는 중복 여부 확인에 `Dictionary<Int, Bool>`보다 **`Set<Int>`**을 사용하는 것이 더 자연스럽고, 메모리/성능 측면에서도 일반적으로 더 좋습니다.

따라서 이 코드는 **통과는 가능하지만, Swift idiomatic 관점에서 개선할 여지가 있는 풀이**입니다.

---

## 2. 시간 복잡도

### 현재 코드

```swift
for num in nums {
    if let occurence = occured[num] {
        return true
    } else {
        occured[num] = true
    }
}
```

- `Dictionary`의 조회와 삽입은 평균적으로 **O(1)** 입니다.
- 전체 배열을 한 번만 순회하므로 평균 시간 복잡도는 **O(n)** 입니다.

### 이론적 최악 경우

- 해시 충돌이 심하게 발생하면 `Dictionary` 연산이 평균보다 느려질 수 있습니다