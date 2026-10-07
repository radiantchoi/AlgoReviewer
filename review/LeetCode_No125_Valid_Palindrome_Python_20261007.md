# LeetCode No.125 Valid Palindrome Code Review

## 총평

현재 풀이는 **정답이며 읽기 쉽습니다.** 입력을 소문자로 바꾼 뒤 영숫자만 남기고, 양끝에서 가운데로 이동하며 비교하는 방식입니다. 시간 복잡도는 최적이지만, 필터링한 문자를 별도 리스트에 저장하므로 공간을 줄일 수 있습니다.

## 복잡도

문자열 길이를 `n`이라 하면:

- **시간 복잡도: O(n)**  
  소문자 변환과 영숫자 필터링에 O(n), 양끝 비교에 최대 O(n)이 걸립니다. 전체적으로 O(n)이며 점근적으로 더 빠르게 만들 수는 없습니다.
- **공간 복잡도: O(n)**  
  `lower()` 결과와 `letters` 리스트를 만들어 입력 크기에 비례하는 추가 메모리를 사용합니다.

## 풀이 방식과 개선점

이 문제는 DP나 그래프 탐색이 필요한 유형이 아닙니다. 흔한 정석은 **양쪽 포인터를 원본 문자열에 직접 두고**, 영숫자가 아닌 문자를 건너뛰면서 비교하는 방식입니다. 이 방법은 시간 O(n)을 유지하면서 추가 공간을 O(1)로 줄일 수 있습니다.

```python
class Solution:
    def isPalindrome(self, s: str) -> bool:
        left, right = 0, len(s) - 1

        while left < right:
            while left < right and not s[left].isalnum():
                left += 1
            while left < right and not s[right].isalnum():
                right -= 1

            if s[left].lower() != s[right].lower():
                return False

            left += 1
            right -= 1

        return True
```

## 엣지 케이스 및 언어 특성

- 빈 문자열이나 영숫자가 전혀 없는 문자열은 현재 코드에서도 `True`를 반환합니다. 필터링 후 비교할 문자가 없기 때문입니다.
- 문자 하나만 있거나, 비교할 영숫자가 하나만 남는 경우도 올바르게 처리됩니다.
- `while left <= right`는 현재 로직에서 올바릅니다. 가운데 문자를 자기 자신과 비교해도 결과가 달라지지 않습니다. 정석적인 양끝 포인터 풀이에서는 보통 `left < right`를 사용합니다.
- `filter(lambda ...)`도 동작하지만, Python에서는 다음과 같이 리스트 컴프리헨션을 사용하면 의도가 더 명확합니다.

  ```python
  letters = [char for char in s.lower() if char.isalnum()]
  ```

- Python의 `isalnum()`은 유니코드 문자도 영숫자로 취급합니다. LeetCode 문제의 일반적인 입력 범위에서는 문제되지 않지만, 명세가 ASCII 영문자와 숫자만 대상으로 한다면 그에 맞는 판별 조건을 사용해야 합니다.

**결론:** 현재 풀이는 정확하고 시간 효율도 좋습니다. 추가 메모리를 줄이고 싶다면 문자열을 별도 리스트로 만들지 않는 양끝 포인터 방식이 더 적합합니다.