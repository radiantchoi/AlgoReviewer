# LeetCode No.238 Product of Array Except Self Code Review

# LeetCode 238 Product of Array Except Self 코드 리뷰

## 총평

제시한 코드는 **0의 개수를 세고, 0이 아닌 값들의 곱을 이용해 답을 계산**하는 방식입니다.  
0이 1개, 2개 이상, 0이 없는 경우를 구분하는 논리는 대체로 정확하며, 출력 배열을 제외하면 추가 공간을 거의 사용하지 않는다는 장점이 있습니다.

다만 LeetCode 238의 후속 조건에서 보통 **“O(n) 시간, 나눗셈 없이 풀어라”** 를 요구하기 때문에, 현재 코드의 `product // num` 부분은 문제가 요구 조건에 따라 부적합할 수 있습니다.  
이 문제의 정석 풀이는 **prefix product / suffix product** 방식입니다.

---

## 1. 시간 복잡도

### 현재 코드

```python
for num in nums:
    ...

for num in nums:
    ...
```

- 배열을 2번 순회하므로 **시간 복잡도 O(n)** 입니다.
- `n`의 크기에 대해 추가적인 반복 구조가 없으므로 알고리즘적 복잡도는 문제 요구사항을 만족합니다.

### 세부 고려 사항

Python에서는 정수가 크기 제한이 없는 **big integer**로 동작합니다.  
`nums` 값이 크고 배열 길이가 길면 `product`가 매우 큰 정수가 될 수 있고, 이 경우:

- `product *= num`
- `product // num`

연산의 실제 비용은 정수의 비트 길이에 따라 증가할 수 있습니다.

즉, 일반적인 알고리즘 분석에서는 **O(n)** 이지만, Python big integer 비용을 엄밀히 고려하면 정수 연산 비용이 입력 값 크기에 의존할 수 있습니다.

---

## 2. 공간 복잡도

### 현재 코드

```python
result = []
...
return result
```

- 반환할 결과 배열 `result`는 **O(n)** 공간이 필요합니다.
- 이는 문제에서 요구하는 출력 공간입니다.
- `product`, `zeroes` 변수만 추가적으로 사용하므로 **출력 배열을 제외하면 O(1) 추가 공간**입니다.

따라서 공간 복잡도는 다음과 같이 정리할 수 있습니다.

| 항목 | 공간 복잡도 |
|---|---:|
| 결과 배열 포함 | O(n) |
| 결과 배열 제외 추가 공간 | O(1) |

이 부분은 현재 코드의 장점입니다.

---

## 3. 보편적인 정석 풀이: Prefix / Suffix Product

이 문제는 전형적인 **prefix product + suffix product** 문제입니다.

핵심 아이디어:

```text
answer[i] = (i 이전 모든 값의 곱) * (i 이후 모든 값의 곱)
```

예를 들어:

```python
nums = [2, 3, 4, 5]
```

`i = 2`에서 원하는 값은:

```text
(2 * 3) * (5) = 30
```

즉:

```text
left_product[i] * right_product[i]
```

를 계산하면 됩니다.

### O(n) 시간, O(1) 추가 공간, 나눗셈 없는 정석 풀이

```python
from typing import List

class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        n = len(nums)
        answer = [1] * n

        # 왼쪽에서 오른쪽으로 prefix product 저장
        prefix = 1
        for i in range(n):
            answer[i] = prefix
            prefix *= nums[i]

        # 오른쪽에서 왼쪽으로 suffix product를 곱해 최종 answer 완성
        suffix = 1
        for i in range(n - 1, -1, -1):
            answer[i] *= suffix
            suffix *= nums[i]

        return answer
```

### 이 풀이의 장점

| 항목 | 설명 |
|---|---|
| 시간 복잡도 | O(n) |
| 추가 공간 복잡도 | O(1), 결과 배열 제외 |
| 나눗셈 사용 여부 | 없음 |
| 0 처리 | 별도 처리 없이 자연스럽게 동작 |
| 문제 후속 조건 만족 | LeetCode 238의 “no division” 조건을 만족 |
| 코드 안정성 | 0, 음수, 1, 큰 값에 대해 특별한 분기 불필요 |

예를 들어:

```python
nums = [0, 0]
```

prefix/suffix 풀이는 자동으로:

```python
[0, 0]
```

을 반환합니다.

```python
nums = [0, 1, 2]
```

에서는:

```python
[2, 0, 0]
```

을 반환합니다.

따라서 이 문제가 요구하는 **가장 정석적이고 안전한 풀이**는 prefix/suffix product 방식입니다.

---

## 4. 현재 풀이의 적절성과 개선 가능한 부분

## 4.1. 현재 코드의 정확성

현재 코드는 다음과 같은 경우를 처리합니다.

### 0이 없는 경우

```python
nums = [2, 3, 4]
product = 24
```

각 위치에서:

```python
24 // 2 = 12
24 // 3 = 8
24 // 4 = 6
```

따라서:

```python
[12, 8, 6]
```

를 반환합니다.

### 0이 1개인 경우

```python
nums = [0, 1, 2]
product = 2
zeroes = 1
```

- `num == 0`인 위치에는 `product`를 넣습니다.
- 나머지 위치에는 0을 넣습니다.

결과:

```python
[2, 0, 0]
```

### 0이 2개 이상인 경우

```python
nums = [0, 0, 1]
```

어느 위치를 제외해도 곱에 0이 포함되므로:

```python
[0, 0, 0]
```

현재 코드는:

```python
if zeroes > 1:
    return [0] * len(nums)
```

으로 올바르게 처리합니다.

### 음수

Python의 `//` 연산은 음수에도 동작합니다.  
여기서 `product // num`은 `product`가 `num`의 정수 배이므로 정확합니다.

예:

```python
-12 // 3 == -4
-12 // -3 == 4
```

따라서 음수 입력에서도 현재 코드는 논리적으로 문제없습니다.

### 1개 요소

```python
nums = [5]
```

- `product = 5`
- `zeroes = 0`
- `5 // 5 = 1`

결과:

```python
[1]
```

이것도 정답입니다.

### 빈 배열

```python
nums = []
```

현재 코드는:

```python
[]
```

를 반환합니다.  
LeetCode 238 공식 제약에서는 보통 빈 배열이 주어지지 않지만, 현재 코드 자체는 빈 배열에서도 에러 없이 동작합니다.

---

## 4.2. 현재 코드의 가장 큰 한계: 나눗셈 사용

```python
result.append(product // num)
```

이 부분은 0이 없는 경우에만 실행되므로 **구문적으로는 0으로 나누는 에러는 없습니다.**

하지만 LeetCode 238은 다음과 같은 후속 조건을 자주 요구합니다:

> Can you solve it in O(n) time complexity and **without using division**?

따라서 현재 코드는:

- 일반적인 알고리즘 문제로서는 충분히 동작하지만,
- LeetCode 238의 후속 조건이 요구된다면 **완전 정답 풀이로 보기 어렵습니다.**

또한 `product // num`은 “전체 곱을 각각의 값으로 나누어 답을 만든다”는 방식이므로, 0 처리를 별도 해주지 않으면 불가능한 구조입니다.  
현재 코드는 0을 미리 카운트해서 이를 해결하고 있으므로 실용적으로는 괜찮지만, 정석적인 prefix/suffix 방식보다는 문제의 의도와 거리가 있습니다.

---

## 4.3. 0이 2개 이상인 경우에도 product를 계산하는 부분

현재 코드:

```python
for num in nums:
    if num != 0:
        product *= num
    else:
        zeroes += 1
```

`zeroes > 1`이면 최종 답은 전부 0인데도, 0이 아닌 값들의 곱을 계속 계산합니다.

예:

```python
nums = [1000000, 0, 0, 1000000, 1000000]
```

마지막 답은:

```python
[0, 0, 0, 0, 0]
```

인데도 `product`에 0이 아닌 값을 계속 곱합니다.

이건 기능상 버그는 아니지만, 불필요한 계산입니다.

### 개선 방향

0의 개수가 2 이상이면 이후 곱셈을 생략할 수 있습니다.

```python
if num == 0:
    zero_count += 1
elif zero_count <= 1:
    product *= num
```

이렇게 하면 0이 2개 이상 발견된 이후에는 `product`를 더 크게 만들지 않습니다.

다만 이 개선은 필수적이진 않고, 크고 긴 입력에서 불필요한 big integer 연산을 줄이는 정도의 미세 최적화입니다.

---

## 4.4. result를 append하는 방식

현재:

```python
result = []

for num in nums:
    ...
    result.append(...)

return result
```

이것도 충분히 자연스럽습니다.

다만 알고리즘 코드에서는 결과 배열을 미리 생성하고 인덱스로 채우는 방식이 더 명확할 때가 있습니다.

```python
answer = [0] * n

for i, num in enumerate(nums):
    answer[i] = ...
```

이 방식의 장점:

- 결과 배열 크기를 한 번에 명시
- append 호출 감소
- 특정 인덱스에 값을 넣는다는 의도가 명확
- LeetCode 스타일에서 흔히 사용하는 패턴

---

## 5. Python적 특성 / Idiomatic Code

## 5.1. 잘한 부분

### 타입 힌트 사용

```python
from typing import List

class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
```

- 타입 힌트가 명확합니다.
- LeetCode 환경에서도 자연스러운 작성법입니다.

### 반복문

```python
for num in nums:
```

- Pythonic한 리스트 순회 방식입니다.
- 인덱스 없이 값만 필요할 때는 좋습니다.

### 0 체크

```python
if num != 0:
    product *= num
else:
    zeroes += 1
```

- 가독성이 좋습니다.

---

## 5.2. 개선할 수 있는 Python적 표현

### 1) `zeroes` 대신 `zero_count`

```python
zeroes = 0
```

보다 의미 전달이 명확한 이름:

```python
zero_count = 0
```

알고리즘 코드에서는 변수명이 의도를 명확히 하는 것이 중요합니다.

---

### 2) `if not zeroes:` 대신 명시적 비교

현재:

```python
if not zeroes:
```

이건 Python적으로 동작하지만, 의도가 약간 모호할 수 있습니다.

```python
if zero_count == 0:
```

이쪽이 더 명확합니다.

---

### 3) 결과 배열 미리 생성하기

```python
result = []
...
result.append(...)
```

대신:

```python
answer = [0] * len(nums)
...
answer[i] = ...
```

이 방식이 더 안정적이고 명확합니다.

---

### 4) `enumerate` 사용

인덱스가 필요하면:

```python
for i, num in enumerate(nums):
```

를 사용하는 것이 Pythonic합니다.

---

## 6. 개선 코드 예시

## 6.1. 현재 아이디어를 유지하면서 다듬은 코드

0 카운팅 + 전체 곱 방식으로 풀이하면 다음과 같이 개선할 수 있습니다.

```python
from typing import List

class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        n = len(nums)
        zero_count = 0
        product = 1

        for num in nums:
            if num == 0:
                zero_count += 1
            elif zero_count <= 1:
                product *= num

        if zero_count > 1:
            return [0] * n

        answer = [0] * n

        if zero_count == 0:
            for i, num in enumerate(nums):
                answer[i] = product // num
        else:
            for i, num in enumerate(nums):
                if num == 0:
                    answer[i] = product

        return answer
```

### 이 코드의 특징

| 항목 | 설명 |
|---|---|
| 시간 복잡도 | O(n) |
| 추가 공간 복잡도 | O(1), 결과 배열 제외 |
| 0 처리 | 명시적으로 처리 |
| 0이 2개 이상인 경우 | 불필요한 곱셈을 줄임 |
| 나눗셈 사용 | 0이 없는 경우에만 사용 |
| LeetCode 후속 조건 | 나눗셈을 요구하지 않는다면 적합, 요구한다면 부적합 |

---

## 6.2. 가장 추천하는 정석 코드: Prefix / Suffix Product

```python
from typing import List

class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        n = len(nums)
        answer = [1] * n

        prefix = 1
        for i in range(n):
            answer[i] = prefix
            prefix *= nums[i]

        suffix = 1
        for i in range(n - 1, -1, -1):
            answer[i] *= suffix
            suffix *= nums[i]

        return answer
```

### 왜 이 코드가 더 좋은가?

1. **나눗셈을 사용하지 않습니다.**
2. **0을 별도로 처리할 필요가 없습니다.**
3. **음수, 1, 0, 큰 값 모두 자연스럽게 처리됩니다.**
4. **LeetCode 238의 후속 조건을 정확히 만족합니다.**
5. **추가 공간이 O(1)입니다.**
6. **코드 의도가 명확합니다.**

---

## 7. 엣지 케이스 분석

| 입력 | 현재 코드 동작 | 결과 |
|---|---|---|
| `[2, 3, 4, 5]` | 0 없음, 전체 곱을 각 값으로 나눔 | `[60, 40, 30, 24]` |
| `[0, 1, 2]` | 0이 1개, 0인 위치에만 product | `[2, 0, 0]` |
| `[0, 0, 1]` | 0이 2개 이상, 전부 0 | `[0, 0, 0]` |
| `[0]` | 0이 1개, product는 1 | `[1]` |
| `[1]` | 0 없음, 1 // 1 | `[1]` |
| `[-1, 2, -3]` | 0 없음, 음수 곱과 나눗셈 | `[-6, 3, -2]` |
| `[1, 1, 1]` | 0 없음, 전부 1 | `[1, 1, 1]` |
| `[]` | 빈 배열 그대로 반환 | `[]` |

현재 코드는 위 엣지 케이스에서 기능적으로 문제가 없습니다.

---

## 8. 최종 평가

| 기준 | 평가 |
|---|---|
| 시간 복잡도 | O(n)으로 적절 |
| 추가 공간 복잡도 | 결과 배열 제외 O(1)으로 적절 |
| 0 처리 | 정확하고 방어적으로 처리 |
| 엣지 케이스 | 대부분 정상 처리 |
| Pythonic | 대체로 준수, 일부 표현 개선 가능 |
| 문제 정석성 | 0 카운팅 + 나눗셈 방식이라 후속 조건 “no division”에는 부적합 |
| 최종 추천 | LeetCode 238 후속 조건을 고려하면 prefix/suffix product 방식이 더 적합 |

---

## 9. 결론

현재 코드는 **기능적으로는 정답을 내는 유효한 풀이**입니다.  
특히 0이 1개, 2개 이상, 0이 없는 경우를 구분하는 로직은 충분히 정확합니다.

하지만 LeetCode 238은 보통 **나눗셈 없이 O(n)으로 풀어라**는 후속 조건을 요구합니다.  
그 조건을 만족하려면 `product // num`을 사용하지 않는 **prefix/suffix product** 풀이가 더 적절합니다.

따라서 최종적으로는 다음 코드를 권장합니다.

```python
from typing import List

class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        n = len(nums)
        answer = [1] * n

        prefix = 1
        for i in range(n):
            answer[i] = prefix
            prefix *= nums[i]

        suffix = 1
        for i in range(n - 1, -1, -1):
            answer[i] *= suffix
            suffix *= nums[i]

        return answer
```