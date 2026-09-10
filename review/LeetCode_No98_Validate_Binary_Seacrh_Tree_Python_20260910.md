# LeetCode No.98 Validate Binary Seacrh Tree Code Review

# LeetCode No.98 Validate Binary Search Tree 코드 리뷰

## 1. 총평

현재 코드는 **BST 검증의 가장 정석적인 방법 중 하나인 “재귀 + 범위 체크”**를 사용하고 있습니다.  
각 노드가 허용되는 `(low, high)` 범위 내에 있는지 확인하면서 좌/우 자식 트리로 내려가는 방식이며, 알고리즘적으로는 충분히 적절합니다.

다만 다음 부분은 개선하거나 명시적으로 고려하면 좋습니다.

1. **재귀 깊이 제한 문제**  
   - skewed tree가 깊으면 Python 기본 recursion limit을 초과할 수 있음
2. **경계 값 하드코딩 문제**  
   - `-2 ** 31 - 1`, `2 ** 31`은 32-bit signed int 제약을 가정한 값
   - 더 일반적이고 안전한 `float('-inf')`, `float('inf')` 또는 `math.inf` 사용이 좋음
3. **Python 호환성 / idiomatic code**  
   - `TreeNode | None`은 Python 3.10+ 필요
   - LeetCode 환경에서는 `Optional[TreeNode]`이 더 안전
   - helper method 이름은 snake_case 또는 private naming이 더 Pythonic

---

## 2. 시간 복잡도

### 현재 풀이

```python
return self.isValid(root.left, low, root.val) and self.isValid(root.right, root.val, high)
```

- 각 노드는 **최대 1회** 방문
- 최악의 경우 전체 노드를 확인해야 하므로:

\[
O(n)
\]

여기서 `n`은 트리 노드 수입니다.

### 최적화 가능성

- BST 검증 문제에서 최악의 경우 **모든 노드를 확인해야 할 수 있음**
- 따라서 `O(n)`은 이론적으로 최적
- 현재 코드는 `and` 덕분에 왼쪽이 이미 invalid하면 오른쪽을 가지지 않는 **조기 탈출** 효과도 있음

### 결론

- 시간 복잡도는 **최적**
- 추가 최적화보다는 **재귀 깊이 안정성**이 더 중요

---

## 3. 공간 복잡도

### 현재 풀이

- 함수 호출 스택만 사용
- 추가 자료구조 없음

공간 복잡도는 트리의 높이 `h`에 비례:

\[
O(h)
\]

### 케이스별

- **완전 균형 트리**: \(O(\log n)\)
- **skewed tree**: \(O(n)\)

### 주의할 점

Python은 기본 recursion limit이 보통 `1000`입니다.  
LeetCode 98의 노드 수는 최대 `10^4` 수준일 수 있으므로,

- 왼쪽 또는 오른쪽으로만 길게 이어진 skewed tree
- 깊이 `1000` 초과 트리

가 테스트에 포함되면 `RecursionError`가 발생할 수 있습니다.

### 개선 방향

- 재귀를 유지하되 `sys.setrecursionlimit()` 조정
- 또는 **iterative in-order traversal**로 재귀 깊이 문제 제거

---

## 4. 보편적인 정석 풀이

BST 검증 문제는 보통 아래 두 가지 정석 중 하나로 풀 수 있습니다.

---

### 방법 1. 재귀 + 범위 체크

현재 코드가 사용하는 방식입니다.

- 각 노드는 부모 경로에 의해 허용되는 값 범위가 존재
- root에서는 전체 범위
- 왼쪽으로 내려가면 `high = parent.val`
- 오른쪽으로 내려가면 `low = parent.val`

장점:

- 구현이 직관적
- BST 성질을 직접 검증
- 조기 탈출 가능

단점:

- 재귀 깊이가 깊으면 Python에서 recursion limit 문제 가능

---

### 방법 2. Iterative In-order Traversal

BST의 in-order traversal 결과는 **엄격히 증가하는 순서**여야 합니다.  
따라서 in-order로 한 번에 순회하면서 이전 값과 비교하면 됩니다.

장점:

- 재귀 깊이 문제 회피
- 전체 결과를 저장하지 않고 `prev`만 비교하면 공간 효율적
- skewed tree에 강함

단점:

- BST 범위 논리보다 “in-order가 정렬되어 있는지” 관점이라 처음에는 직관성이 약간 낮을 수 있음

---

### 이 문제에 DP나 그래프가 필요한가?

필요하지 않습니다.

- 이 문제는 **트리 검증 / DFS 기반 문제**
- DP는 중복 상태가 있을 때 적합
- 그래프 탐색도 가능하지만 BST의 구조적 성질을 이용하는 것이 더 자연스러움

---

## 5. 현재 풀이의 적절성과 개선 포인트

### 5.1. 알고리즘 적절성

현재 풀이는 **적절합니다.**

아래 조건을 정확히 검증합니다:

- 왼쪽 모든 노드 < 현재 노드
- 오른쪽 모든 노드 > 현재 노드
- 중복 값은 invalid

특히 다음 코드가 정확합니다:

```python
if not (low < root.val < high):
    return False
```

이것은 **strict inequality**를 사용하므로 중복 값을 올바르게 `False`로 판단합니다.

---

### 5.2. 엣지 케이스

#### 1) 빈 트리

```python
if not root:
    return True
```

- `root is None`이면 `True`
- 문제 제약을 따르더라도 일반적으로 BST에서 빈 트리는 valid로 보는 경우가 많음

#### 2) 노드 1개

- 범위 체크 통과
- `True`

#### 3) 중복 값

예:

```text
   5
  /
 5
```

- 왼쪽 자식은 `low < 5 < high`가 아니므로 `False`
- 올바르게 판단

#### 4) 경계 값

현재 코드:

```python
return self.isValid(root, -2 ** 31 - 1, 2 ** 31)
```

이것은 보통 `-2^31 <= val <= 2^31 - 1`인 환경에서는 동작합니다.  
하지만 다음과 같은 상황에서는 취약합니다:

- `val`이 32-bit signed int 범위를 벗어남
- 문제 제약을 전혀 주지 않은 환경
- `val == 2 ** 31`인 경우
- `val == -2 ** 31 - 1` 이하인 경우

더 안전한 방법:

```python
import math

self.isValid(root, -math.inf, math.inf)
```

또는:

```python
self.isValid(root, float("-inf"), float("inf"))
```

#### 5) 깊은 skewed tree

```text
1
 \
  2
   \
    3
     \
      ...
```

- 재귀 깊이가 `n`
- Python 기본 recursion limit 초과 가능
- iterative 방식 권장

---

## 6. Python 언어적 특성 / Idiomatic Code

### 6.1. 타입 힌트 호환성

현재:

```python
def isValid(self, root: TreeNode | None, low: int, high: int) -> bool:
```

`TreeNode | None` 문법은 **Python 3.10 이상**에서 가능합니다.  
LeetCode 환경이 Python 3.11이면 괜찮지만, 보수적으로 쓰려면:

```python
from typing import Optional

def isValid(self, root: Optional[TreeNode], low: int, high: int) -> bool:
```

또는 파일 상단에:

```python
from __future__ import annotations
```

를 넣고 `TreeNode | None`을 사용할 수도 있습니다.

---

### 6.2. 함수/메서드 네이밍

Python에서는 보통 snake_case를 사용합니다.

현재:

```python
def isValid(...)
```

보다는:

```python
def _is_valid(...)
```

또는:

```python
def is_valid(...)
```

가 더 Pythonic합니다.

다만 LeetCode에서 외부에 노출할 메서드는 `isValidBST`로 고정되어 있으므로,  
helper만 private naming으로 바꾸면 됩니다.

---

### 6.3. `not root` vs `root is None`

현재:

```python
if not root:
    return True
```

문제에서는 `TreeNode` 인스턴스만 오므로 동작합니다.  
하지만 더 명시적이고 안전한 코딩은:

```python
if root is None:
    return True
```

입니다.

---

### 6.4. 매직 넘버

현재:

```python
-2 ** 31 - 1, 2 ** 31
```

는 의미상 “32-bit signed int보다 작은 lower bound, 큰 upper bound”를 표현한 것입니다.  
하지만 가독성과 일반성 측면에서:

```python
import math

-math.inf, math.inf
```

가 더 좋습니다.

---

### 6.5. helper method를 class method로 두는 것

현재:

```python
def isValid(self, root, low, high):
    ...

def isValidBST(self, root):
    return self.isValid(root, -2 ** 31 - 1, 2 ** 31)
```

이것은 LeetCode에서 충분히 받아들여지는 방식입니다.  
다만 더 깔끔하게는 **nested function**를 사용하는 것이 좋습니다.

```python
def isValidBST(self, root):
    def dfs(node, low, high):
        ...
    return dfs(root, -math.inf, math.inf)
```

장점:

- helper를 class scope에 드러내지 않음
- `self` 불필요
- 가독성 개선

---

## 7. 개선 코드 예시

### 7.1. 재귀 방식 개선본

```python
import math
from typing import Optional


# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        def is_valid(node: Optional[TreeNode], low: float, high: float) -> bool:
            if node is None:
                return True

            if not (low < node.val < high):
                return False

            return (
                is_valid(node.left, low, node.val)
                and is_valid(node.right, node.val, high)
            )

        return is_valid(root, -math.inf, math.inf)
```

### 장점

- 경계값 문제를 제거
- Pythonic naming
- helper를 nested function으로 깔끔하게 분리
- strict inequality 유지

### 단점

- 여전히 재귀이므로 skewed tree에서 recursion limit 문제 가능

---

### 7.2. Iterative In-order 방식

```python
from typing import Optional


# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        stack = []
        prev = float("-inf")

        while stack or root:
            while root:
                stack.append(root)
                root = root.left

            root = stack.pop()

            if root.val <= prev:
                return False

            prev = root.val
            root = root.right

        return True
```

### 장점

- 재귀 깊이 문제 없음
- skewed tree에 강함
- 전체 in-order 결과를 저장하지 않고 `prev`만 비교
- Python에서 생산 코드로도 더 안정적

### 시간/공간 복잡도

- 시간: \(O(n)\)
- 공간: \(O(h)\)
  - balanced: \(O(\log n)\)
  - skewed: \(O(n)\)

---

## 8. 최종 평가

| 항목 | 평가 |
|---|---|
| 알고리즘 적절성 | 매우 적절, BST 검증 정석 |
| 시간 복잡도 | \(O(n)\), 최적 |
| 공간 복잡도 | \(O(h)\), 균형 트리 기준 양호 |
| 엣지 케이스 처리 | 중복/빈 트리/범위 체크는 적절 |
| 경계값 처리 | 32-bit 가정은 동작하지만 일반성 부족 |
| 재귀 깊이 안정성 | skewed tree에서 취약 |
| Python idiomatic | 일부 개선 가능 |
| LeetCode 통과 가능성 | 보통 환경에서는 통과, 깊은 skewed tree 테스트 시 주의 |

---

## 9. 추천 개선 우선순위

1. **`float('-inf')`, `float('inf')` 또는 `math.inf`로 경계값 교체**
2. **helper를 nested function 또는 `_is_valid`로 Pythonic하게 정리**
3. **테스트 트리가 깊을 수 있으므로 iterative in-order 방식도 함께 알아둘 것**
4. **`TreeNode | None` 대신 `Optional[TreeNode]`으로 호환성 확보**

---

## 10. 결론

현재 코드는 **BST 검증 문제를 알고리즘적으로 정확하고 정석적으로 풀고 있습니다.**  
시간 복잡도 측면에서는 이미 최적이며, 개선의 핵심은 알고리즘 자체보다는 다음 세 가지입니다:

- **경계값의 일반성**
- **Python 재귀 깊이 안정성**
- **idiomatic code**

따라서 LeetCode 제출용으로는 현재 코드도 충분히 가능하지만,  
**더 견고한 코드**로 쓰려면 `math.inf`와 nested function을 사용한 재귀 버전, 또는 **iterative in-order traversal** 버전을 권장합니다.