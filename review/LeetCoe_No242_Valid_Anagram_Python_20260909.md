# LeetCoe No.242 Valid Anagram Code Review

# LeetCode No.242 Valid Anagram 코드 리뷰

## 1. 시간 복잡도

현재 코드는 `s`와 `t`를 각각 한 번씩 순회하며 문자 빈도를 세고, 마지막으로 두 딕셔너리를 비교합니다.

- `s` 순회: `O(len(s))`
- `t` 순회: `O(len(t))`
- 딕셔너리 비교: `O(k)`  
  여기서 `k`는 두 문자열에 등장하는 고유 문자 수입니다.

따라서 전체 시간 복잡도는:

```text
O(len(s) + len(t))
```

또는 `n = len(s) + len(t)`로 볼 때:

```text
O(n)
```

이 문제는 정렬을 사용하지 않는다면 **시간 복잡도 측면에서 이미 거의 최적**입니다.  
정렬 기반 풀이는 `O(n log n)`이 되므로, 현재 방식보다 비효율적입니다.

---

## 2. 공간 복잡도

현재 코드는 `s_letters`, `t_letters` 두 개의 딕셔너리를 사용합니다.

- `s_letters`: `s`에 포함된 고유 문자 수만큼 저장
- `t_letters`: `t`에 포함된 고유 문자 수만큼 저장

따라서 공간 복잡도는:

```text
O(u_s + u_t)
```

여기서 `u_s`, `u_t`는 각각 `s`, `t`에 포함된 고유 문자 수입니다.

LeetCode 242의 기본 제약이 **lowercase English letters**라면, 고유 문자 수는 최대 26개이므로 실제로는:

```text
O(1)
```

으로 볼 수도 있습니다.

다만, 입력이 Unicode 문자열까지 포함할 수 있다면 고유 문자 수에 따라 공간이 증가하므로:

```text
O(k)
```

라고 표현하는 것이 더 정확합니다.

---

## 3. 보편적인 정석 풀이

이 문제는 전형적인 **문자 빈도 비교** 문제입니다.  
정석적인 접근은 다음과 같습니다.

### 방법 1. `collections.Counter` 사용

Python에서는 가장 간결하고 직관적인 방법입니다.

```python
from collections import Counter

class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        return Counter(s) == Counter(t)
```

- 시간 복잡도: `O(len(s) + len(t))`
- 공간 복잡도: `O(k)`

### 방법 2. 한 개의 딕셔너리로 증감 처리

`s`에서는 `+1`, `t`에서는 `-1`을 적용한 뒤 모든 값이 `0`인지 확인합니다.

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        counts = {}

        for c in s:
            counts[c] = counts.get(c, 0) + 1

        for c in t:
            counts[c] = counts.get(c, 0) - 1

        return all(v == 0 for v in counts.values())
```

- 시간 복잡도: `O(len(s) + len(t))`
- 공간 복잡도: `O(k)`

이 방법은 두 개의 딕셔너리를 만들지 않으므로 공간 사용량에서 약간 유리합니다.

### 방법 3. 고정 크기 배열 사용

문제가 소문자 `a~z`만 주어지는 경우, 길이 26 배열을 사용할 수 있습니다.

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False

        counts = [0] * 26

        for c in s:
            counts[ord(c) - ord('a')] += 1

        for c in t:
            counts[ord(c) - ord('a')] -= 1

        return all(x == 0 for x in counts)
```

- 시간 복잡도: `O(len(s) + len(t))`
- 공간 복잡도: `O(1)`

이 방식은 문제가 **ASCII lowercase letters**임을 전제로 할 때 매우 효율적입니다.

### 방법 4. 정렬 후 비교

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        return sorted(s) == sorted(t)
```

- 시간 복잡도: `O(n log n)`
- 공간 복잡도: `O(n)`

간단하지만, 이 문제에서는 시간 복잡도 기준 정석 풀이보다 비효율적입니다.

---

## 4. 현재 풀이의 적절성과 개선 가능한 부분

### 현재 풀이 평가

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        s_letters = {}
        t_letters = {}

        for letter in s:
            s_letters[letter] = s_letters.get(letter, 0) + 1
        
        for letter in t:
            t_letters[letter] = t_letters.get(letter, 0) + 1
        
        return s_letters == t_letters
```

현재 코드는 **정답적으로 정확**합니다.

장점:

- 문자 빈도를 직접 비교하는 정석적인 접근
- 시간 복잡도 `O(n)` 수준
- 추가 라이브러리 없이 구현
- 빈 문자열, 문자열 길이 차이, 중복 문자 등 기본 엣지 케이스를 자연스럽게 처리

예를 들어:

```python
s = ""
t = ""
# True

s = "anagram"
t = "nagaram"
# True

s = "rat"
t = "car"
# False
```

이런 케이스 모두 정상 동작합니다.

---

### 개선 포인트 1: 길이 체크 추가

anagram이 되려면 먼저 두 문자열의 길이가 같아야 합니다.

```python
if len(s) != len(t):
    return False
```

현재 코드도 최종적으로 `False`를 반환하지만, 길이 차이가 명확한 경우 불필요한 계산을 줄일 수 있습니다.

개선 예:

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False

        s_letters = {}
        t_letters = {}

        for letter in s:
            s_letters[letter] = s_letters.get(letter, 0) + 1

        for letter in t:
            t_letters[letter] = t_letters.get(letter, 0) + 1

        return s_letters == t_letters
```

---

### 개선 포인트 2: `collections.Counter` 사용

Python에서는 빈도 비교를 `Counter`로 작성하는 것이 훨씬 Pythonic합니다.

```python
from collections import Counter

class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False

        return Counter(s) == Counter(t)
```

또는 길이 체크 없이도:

```python
from collections import Counter

class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        return Counter(s) == Counter(t)
```

`Counter` 비교 자체가 길이와 빈도를 함께 비교하므로 문제 해결에는 충분합니다.

장점:

- 코드 가독성 향상
- Python 표준 라이브러리 활용
- 빈도 비교 의도가 명확
- 유지보수성 향상

---

### 개선 포인트 3: 두 개의 딕셔너리 대신 하나 사용

현재 코드는 `s_letters`와 `t_letters`를 따로 만듭니다.  
이 대신 하나의 딕셔너리로 `+1`, `-1` 처리하면 공간과 코드 구조가 더 깔끔해질 수 있습니다.

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False

        counts = {}

        for c in s:
            counts[c] = counts.get(c, 0) + 1

        for c in t:
            counts[c] = counts.get(c, 0) - 1

        return all(v == 0 for v in counts.values())
```

이 방식은:

- 두 개의 딕셔너리를 만들지 않음
- 최종적으로 모든 문자의 차이가 0인지 확인
- 공간 사용량을 줄일 수 있음

---

### 개선 포인트 4: 문제 제약에 맞는 고정 배열 사용

LeetCode 242는 일반적으로:

```text
s and t consist of lowercase English letters.
```

라는 조건을 가집니다.

따라서 일반 딕셔너리보다 고정 크기 배열을 사용하는 것이 더 효율적입니다.

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False

        counts = [0] * 26

        for c in s:
            counts[ord(c) - ord('a')] += 1

        for c in t:
            counts[ord(c) - ord('a')] -= 1

        return all(x == 0 for x in counts)
```

장점:

- 공간 복잡도 `O(1)`
- 딕셔너리 해시 오버헤드 제거
- 문제 제약에 최적화

단, 입력이 Unicode 문자까지 포함할 수 있다면 이 방식은 제약 조건에 맞지 않습니다.

---

## 5. Python Idiomatic Code 준수 여부

현재 코드는 Python으로 동작하는 데 문제가 없지만, Pythonic 관점에서는 개선 여지가 있습니다.

### 현재 코드의 Pythonic 수준

```python
s_letters[letter] = s_letters.get(letter, 0) + 1
```

이 표현은 유효하고 일반적인 Python 코드입니다.  
다만, 빈도 계산을 하는 상황에서는 `collections.Counter`를 사용하는 것이 더 자연스럽습니다.

### 더 Pythonic한 예시

```python
from collections import Counter

class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        return Counter(s) == Counter(t)
```

또는:

```python
from collections import Counter

class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False

        return Counter(s) == Counter(t)
```

이 방식이 가장 간결하고 Python의 특징을 잘 살립니다.

### `defaultdict`를 사용하는 경우

```python
from collections import defaultdict

class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        counts = defaultdict(int)

        for c in s:
            counts[c] += 1

        for c in t:
            counts[c] -= 1

        return all(v == 0 for v in counts.values())
```

이 방식도 Pythonic합니다.  
다만, 이 문제에서는 `Counter`가 더 직관적입니다.

---

## 최종 추천 코드

### 가장 간결하고 Pythonic한 풀이

```python
from collections import Counter

class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False

        return Counter(s) == Counter(t)
```

- 시간 복잡도: `O(len(s) + len(t))`
- 공간 복잡도: `O(k)`
- 가독성: 매우 높음
- 유지보수성: 높음

---

### 문제 제약이 lowercase English letters인 경우 최적 풀이

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False

        counts = [0] * 26

        for c in s:
            counts[ord(c) - ord('a')] += 1

        for c in t:
            counts[ord(c) - ord('a')] -= 1

        return all(x == 0 for x in counts)
```

- 시간 복잡도: `O(len(s) + len(t))`
- 공간 복잡도: `O(1)`
- LeetCode 242 제약 조건에 가장 잘 맞춤

---

## 종합 의견

현재 코드는 **알고리즘적으로 정확하고 시간 복잡도도 적절**합니다.  
문자 빈도를 비교하는 정석적인 접근을 사용하고 있으며, 기본 엣지 케이스도 문제없이 처리합니다.

다만 Python 코드로서는:

1. `collections.Counter`를 사용해 가독성을 높일 수 있음
2. 길이 차이가 있을 경우 early return을 추가할 수 있음
3. 두 개의 딕셔너리 대신 하나의 딕셔너리로 증감 처리할 수 있음
4. 문제가 소문자만 주어지는 경우 고정 길이 배열로 공간 최적화가 가능함

이런 개선이 가능합니다.

가장 추천하는 최종 형태는 다음과 같습니다.

```python
from collections import Counter

class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False

        return Counter(s) == Counter(t)
```

이 코드가 이 문제에 대해 가장 균형 잡힌 Python 풀이입니다.