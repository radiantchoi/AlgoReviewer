# LeetCode No.70 Climbing Stairs Code Review

# LeetCode No.70 Climbing Stairs 코드 리뷰

## 1. 요약

제시된 코드는 **LeetCode No.70 Climbing Stairs** 문제를 `n`에 대해 반복적으로 DP를 계산하는 방식으로 풀어낸 것입니다.

```python
class Solution:
    def climbStairs(self, n: int) -> int:
        stairs = [0, 1, 2]

        current = 2
        while current < n:
            stairs.append(stairs[current] + stairs[current - 1])
            current += 1
        
        return stairs[n]
```

LeetCode의 일반적인 제약 조건인 `1 <= n <= 45`를 전제로 한다면 **기능적으로는 정상 동작**합니다.  
다만, 이 문제는 **Fibonacci DP**의 대표 문제이므로 다음과 같은 개선 여지가 있습니다.

- 공간 복잡도를 `O(n)`에서 `O(1)`으로 줄일 수 있음
- `while` 대신 Python적인 `for` loop 사용 가능
- `n = 0`, `n < 0` 등 엣지 케이스에 대한 방어 코드 추가 가능
- 문제의 DP 특성을 더 명확하게 드러내는 코드로 개선 가능

종합적으로, **통과 가능한 풀이**이지만 **공간 효율성과 Python적 표현력 측면에서 개선 권장**합니다.

---

## 2. 시간 복잡도 분석

### 현재 코드

```python
current = 2
while current < n:
    stairs.append(stairs[current] + stairs[current - 1])
    current += 1
```

`n >= 3`일 때 while 루프는 `n - 2`번 실행됩니다.  
각 iteration에서 수행되는 작업은 다음과 같습니다.

- 리스트 접근: `stairs[current]`, `stairs[current - 1]`
- 덧셈: `+`
- 리스트 append: `append`
- 변수 증가: `current += 1`

이 작업들은 모두 상수 시간입니다.

따라서 시간 복잡도는:

```text
O(n)
```

### 최적화 가능성

시간 복잡도 자체는 이 문제의 일반적인 DP 풀이 기준으로 충분합니다.  
LeetCode 70의 `n` 범위가 작기 때문에 `O(n)`은 practically enough입니다.

만약 `n`이 매우 큰 수, 예를 들어 `10^9` 이상인 경우에는 다른 방법을 고려할 수 있습니다.

- **Matrix Exponentiation**: `O(log n)`
- **Fast Doubling Fibonacci**: `O(log n)`

하지만 LeetCode 70에서는 `O(n)` DP가 가장 자연스럽고, 실전에서는 가장 많이 사용되는 정석 풀이입니다.

---

## 3. 공간 복잡도 분석

### 현재 코드

```python
stairs = [0, 1, 2]
```

이후 `n`이 커질수록 리스트에 계속 값을 추가합니다.

최종 리스트 길이는:

```text
n + 1
```

예를 들어 `n = 45`이면 리스트 길이는 46입니다.

따라서 공간 복잡도는:

```text
O(n)
```

### 개선 가능성

이 문제는 `dp[i]`를 계산할 때 이전 두 값만 필요 합니다.

```text
dp[i] = dp[i - 1] + dp[i - 2]
```

즉, 전체 리스트를 저장할 필요가 없습니다.

다음 두 값만 유지하면 됩니다.

- `dp[i - 1]`
- `dp[i - 2]`

따라서 공간 복잡도는:

```text
O(1)
```

으로 개선할 수 있습니다.

---

## 4. 정석적인 풀이 방법

이 문제는 전형적인 **1D DP / Fibonacci** 문제입니다.

### 문제 모델링

계단을 `1`칸 또는 `2`칸씩 오를 때, `n`번째 계단에 도달하는 방법의 수를 구합니다.

`n`번째 계단에 도달하는 마지막 선택은 두 가지입니다.

1. `n - 1`번째 계단에서 `1`칸 올라감
2. `n - 2`번째 계단에서 `2`칸 올라감

따라서 다음 점화식이 성립합니다.

```text
ways(n) = ways(n - 1) + ways(n - 2)
```

base case:

```text
ways(1) = 1
ways(2) = 2
```

이는 Fibonacci sequence와 동일한 형태입니다.

만약 Fibonacci를 `F(1) = 1`, `F(2) = 1`이라고 정의하면:

```text
ways(n) = F(n + 1)
```

입니다.

---

## 5. 현재 풀이의 적절성

### 장점

#### 1. DP 아이디어를 올바르게 적용함

현재 코드는 다음 관계를 따릅니다.

```python
stairs[current] + stairs[current - 1]
```

이는 `dp[i] = dp[i - 1] + dp[i - 2]`를 구현한 것입니다.

따라서 알고리즘적 관점에서는 올바른 접근입니다.

#### 2. LeetCode 일반 제약 조건에서 정상 동작

LeetCode 70의 일반 입력 범위인 `1 <= n <= 45`에서는 정상적으로 동작합니다.

예:

```text
n = 1 -> 1
n = 2 -> 2
n = 3 -> 3
n = 4 -> 5
n = 5 -> 8
```

#### 3. 구현이 단순하고 이해하기 쉬움

리스트를 이용해서 DP 테이블을 직접 만들고 있으므로 DP 구조가 눈에 잘 드러납니다.

---

### 단점 및 개선 포인트

#### 1. 불필요하게 `O(n)` 공간 사용

현재 코드는 최종 답만 필요함에도 전체 DP 테이블을 리스트에 저장합니다.

```python
stairs = [0, 1, 2]
```

하지만 실제 계산에는 이전 두 값만 필요하므로 리스트 없이도 가능합니다.

개선 예:

```python
class Solution:
    def climbStairs(self, n: int) -> int:
        if n <= 2:
            return n

        prev2, prev1 = 1, 2

        for _ in range(3, n + 1):
            prev2, prev1 = prev1, prev2 + prev1

        return prev1
```

이 경우:

```text
시간 복잡도: O(n)
공간 복잡도: O(1)
```

입니다.

---

#### 2. `while` 루프보다 `for` 루프가 더 Pythonic

현재 코드:

```python
current = 2
while current < n:
    stairs.append(stairs[current] + stairs[current - 1])
    current += 1
```

Python에서는 반복 횟수가 명확할 때 `for` loop를 더 선호합니다.

예:

```python
for current in range(3, n + 1):
    ...
```

또는 `O(1)` 공간 버전:

```python
for _ in range(3, n + 1):
    ...
```

이 방식이 더 간결하고 Pythonic합니다.

---

#### 3. `n = 0` 엣지 케이스

현재 코드:

```python
stairs = [0, 1, 2]
return stairs[n]
```

만약 `n = 0`이면:

```python
stairs[0]
```

즉 `0`을 반환합니다.

하지만 수학적으로 “0번째 계단에서 시작해서 0번째 계단에 도달하는 방법의 수”는 보통 `1`로 정의하기도 합니다.

즉, 입력이 `0`을 포함하는 문제라면:

```text
ways(0) = 1
```

이 더 자연스러운 정의일 수 있습니다.

LeetCode 70은 보통 `n >= 1`을 전제하지만, 코드 리뷰 관점에서는 방어적으로 처리하는 것이 좋습니다.

예:

```python
if n == 0:
    return 1
if n <= 2:
    return n
```

또는 LeetCode 제약 조건을 그대로 따른다면:

```python
if n <= 2:
    return n
```

만으로도 충분합니다.

---

#### 4. 음수 입력에 대한 방어

현재 코드는 `n`이 음수인 경우를 처리하지 않습니다.

예:

```python
n = -1
```

이 경우:

```python
stairs[-1]
```

가 반환됩니다.

Python 리스트의 negative indexing 때문에 예외 없이 `2`를 반환합니다.

하지만 알고리즘 문제에서 음수 입력은 보통 invalid input이므로, silent behavior보다는 명시적으로 처리하는 것이 좋습니다.

예:

```python
if n < 0:
    raise ValueError("n must be non-negative")
```

또는 문제 제약 조건을 명시적으로 가정하고 코드를 작성할 수도 있습니다.

---

#### 5. 리스트 초기값이 DP 의미를 명확하게 드러냄

현재 코드:

```python
stairs = [0, 1, 2]
```

이는:

```text
stairs[0] = 0
stairs[1] = 1
stairs[2] = 2
```

를 의미합니다.

`n = 1`, `n = 2` base case를 잘 표현하고 있습니다.

다만 `stairs[0] = 0`은 `n = 0`을 `0`으로 정의하는 의미입니다.  
만약 `n = 0`을 `1`로 정의하고 싶다면:

```python
stairs = [1, 1, 2]
```

또는 별도 if 처리가 필요합니다.

---

## 6. Python Idiomatic Code 관점

### 현재 코드의 Pythonic 요소

#### 1. Type hint 사용

```python
def climbStairs(self, n: int) -> int:
```

입력과 반환 타입을 명시하고 있어 좋습니다.

#### 2. 리스트 append 사용

```python
stairs.append(...)
```

리스트를 동적으로 확장하는 방법으로 적절합니다.

#### 3. 가독성

코드가 짧고 DP 구조가 비교적 명확합니다.

---

### 더 Pythonic하게 개선할 부분

#### 1. 반복 횟수가 명확한 루프는 `for` 사용

`while`도 가능하지만, Python에서는 반복 횟수가 정해져 있을 때 `for`를 더 선호합니다.

개선:

```python
for i in range(3, n + 1):
    ...
```

#### 2. 더 이상 필요 없는 리스트는 생략 가능

이 문제는 최종 값만 필요하므로 리스트 없이 변수 두 개로 충분합니다.

개선:

```python
prev2, prev1 = 1, 2
```

#### 3. tuple unpacking 사용

Python에서는 동시에 값을 갱신할 때 tuple unpacking을 자주 사용합니다.

```python
prev2, prev1 = prev1, prev2 + prev1
```

이 표현은 간결하고 Pythonic합니다.

---

## 7. 개선안

### 개선안 1: LeetCode 제약 조건 기반 최소 개선

LeetCode 70은 보통 `n >= 1`을 가정합니다.  
이 전제 하에서 가장 간단한 `O(1)` 공간 풀이는 다음과 같습니다.

```python
class Solution:
    def climbStairs(self, n: int) -> int:
        if n <= 2:
            return n

        prev2, prev1 = 1, 2

        for _ in range(3, n + 1):
            prev2, prev1 = prev1, prev2 + prev1

        return prev1
```

복잡도:

```text
시간 복잡도: O(n)
공간 복잡도: O(1)
```

이것이 이 문제에 대한 가장 균형 잡힌 풀이입니다.

---

### 개선안 2: `n = 0`까지 방어하는 버전

입력이 `0`을 포함할 수 있고, `ways(0) = 1`로 정의한다면:

```python
class Solution:
    def climbStairs(self, n: int) -> int:
        if n < 0:
            raise ValueError("n must be non-negative")

        if n == 0:
            return 1

        if n <= 2:
            return n

        prev2, prev1 = 1, 2

        for _ in range(3, n + 1):
            prev2, prev1 = prev1, prev2 + prev1

        return prev1
```

복잡도:

```text
시간 복잡도: O(n)
공간 복잡도: O(1)
```

---

### 개선안 3: DP 테이블을 명확히 드러내는 버전

DP 개념을 교육적으로 보여주고 싶다면 리스트를 사용할 수도 있습니다.

```python
class Solution:
    def climbStairs(self, n: int) -> int:
        if n < 0:
            raise ValueError("n must be non-negative")

        if n == 0:
            return 1

        if n == 1:
            return 1

        dp = [0] * (n + 1)
        dp[1] = 1
        dp[2] = 2

        for i in range(3, n + 1):
            dp[i] = dp[i - 1] + dp[i - 2]

        return dp[n]
```

복잡도:

```text
시간 복잡도: O(n)
공간 복잡도: O(n)
```

이 버전은 DP 테이블 구조가 명확하지만, 공간 효율성은 떨어집니다.

---

## 8. 엣지 케이스 정리

| 입력 | 현재 코드 동작 | 비고 |
|---:|---|---|
| `n = 1` | `1` | 정상 |
| `n = 2` | `2` | 정상 |
| `n = 3` | `3` | 정상 |
| `n = 0` | `0` | 문제 정의에 따라 `1`이 더 자연스러울 수 있음 |
| `n < 0` | negative indexing으로 잘못된 값 반환 가능 | 방어 코드 권장 |
| `n`이 매우 큼 | `O(n)` 공간 사용 | `O(1)` 공간 권장 |

---

## 9. 종합 평가

| 항목 | 평가 |
|---|---|
| 알고리즘 정확성 | LeetCode 일반 제약 조건에서 정확 |
| 시간 복잡도 | `O(n)`으로 적절 |
| 공간 복잡도 | `O(n)`으로 개선 가능 |
| DP 적용 | 적절하게 적용 |
| Pythonic | `while` 리스트 append 방식은 가능하나, `for` + 변수 두 개 방식이 더 좋음 |
| 엣지 케이스 | `n = 0`, 음수 입력에 대한 방어 권장 |
| 최종 판단 | 통과 가능, 개선 권장 |

---

## 10. 최종 추천 코드

LeetCode 70 기준으로 가장 권장되는 풀이는 다음과 같습니다.

```python
class Solution:
    def climbStairs(self, n: int) -> int:
        if n <= 2:
            return n

        prev2, prev1 = 1, 2

        for _ in range(3, n + 1):
            prev2, prev1 = prev1, prev2 + prev1

        return prev1
```

이 코드는:

```text
시간 복잡도: O(n)
공간 복잡도: O(1)
```

이며, 이 문제의 정석적인 DP 풀이를 Python적으로 잘 표현하고 있습니다.