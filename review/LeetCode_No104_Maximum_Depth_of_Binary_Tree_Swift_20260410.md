# LeetCode No.104 Maximum Depth of Binary Tree Code Review

시니어 알고리즘 리뷰어로서, 제출하신 `Maximum Depth of Binary Tree` 풀이에 대한 코드 리뷰를 진행하겠습니다.

---

### 1. 코드 리뷰 총평
제출하신 코드는 재귀(Recursion)를 사용하여 트리의 모든 경로를 탐색하며 최대 깊이를 찾는 논리를 담고 있습니다. 결과적으로 정답을 도출하는 데는 문제가 없으나, **함수형 프로그래밍과 Swift의 언어적 특성을 고려할 때 개선할 여지가 많습니다.**

---

### 2. 상세 리뷰

#### 1) 시간 복잡도 (Time Complexity)
*   **분석**: $O(N)$ (단, $N$은 노드의 개수)
*   모든 노드를 정확히 한 번씩 방문하므로 시간 복잡도는 최적입니다.

#### 2) 공간 복잡도 (Space Complexity)
*   **분석**: $O(H)$ (단, $H$는 트리의 높이)
*   재귀 호출 스택(Recursion Stack)에 의해 사용되는 공간입니다. 최악의 경우(Skewed Tree) $O(N)$, 균형 잡힌 트리라면 $O(\log N)$이 됩니다. 메모리 사용량은 준수합니다.

#### 3) 보편적인 "정석" 풀이 방법
이 문제는 크게 두 가지 접근법이 있습니다.
*   **Bottom-up (재귀적 반환)**: 현재 노드의 왼쪽 자식 높이와 오른쪽 자식 높이를 받아 `max(left, right) + 1`을 반환하는 방식. (가장 직관적이고 간결함)
*   **Top-down (현재 풀이 방식)**: 전역 변수나 참조 변수를 사용하여 탐색하며 깊이를 갱신하는 방식. (상태를 추적해야 하는 경우에 유리함)

#### 4) 현재 풀이의 개선 사항
*   **불필요한 `inout` 사용**: `result`라는 변수를 외부에서 관리하기 위해 `inout`을 사용했는데, 이는 Swift에서 함수를 비순수(Impure)하게 만듭니다. **재귀 함수가 값을 직접 반환하도록 설계하는 것이 훨씬 더 Swift답고(Idiomatic) 이해하기 쉽습니다.**
*   **가독성**: `guard let`을 사용하여 `root`가 nil일 때 `result`를 갱신하는 방식은 다소 장황합니다.

#### 5) Swift의 언어적 특성 (Idiomatic Code)
Swift에서는 함수가 명확한 값을 반환하도록 구성하는 것이 권장됩니다. 현재 `traverse`는 부수 효과(side-effect)를 일으키는 함수인데, 이를 순수 함수로 바꾸면 테스트와 유지보수가 훨씬 용이해집니다.

---

### 3. 개선된 코드 제안 (추천)

Bottom-up 재귀 방식을 사용하면 코드를 훨씬 간결하고 명확하게 작성할 수 있습니다.

```swift
class Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        // Base case: 노드가 없으면 깊이는 0
        guard let root = root else { return 0 }
        
        // Recursive step: 왼쪽과 오른쪽 서브트리의 깊이 중 큰 값 + 1
        let leftDepth = maxDepth(root.left)
        let rightDepth = maxDepth(root.right)
        
        return max(leftDepth, rightDepth) + 1
    }
}
```

#### 개선점 요약:
1.  **가독성 극대화**: `inout` 파라미터와 보조 함수(`traverse`)를 제거하여 가독성이 좋아졌습니다.
2.  **함수형 스타일**: 함수가 `Int`를 반환하도록 하여, 재귀 단계에서의 상태 값을 외부에서 관리할 필요가 없어졌습니다.
3.  **간결함**: 코드가 5줄 이내로 줄어들며 논리가 명확해졌습니다.

### 결론
현재의 `inout` 방식은 문제 해결 능력은 보여주지만, Swift 환경에서는 **'반환 값 기반의 재귀(Return-based Recursion)'**가 표준적인 관례(Best Practice)입니다. 위와 같이 코드를 리팩토링하시면 훨씬 더 전문적이고 유지보수가 쉬운 코드가 될 것입니다.