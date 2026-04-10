# LeetCode No.104 Maximum Depth of Binary Tree Code Review

안녕하세요. 시니어 알고리즘 코드 리뷰어입니다. 
제출해주신 `Maximum Depth of Binary Tree` 풀이에 대해 리뷰를 진행하겠습니다.

전반적으로 두 가지 접근 방식(Top-down 재귀 호출 시 `inout` 파라미터 사용 방식, Bottom-up 재귀 방식)을 모두 시도하신 점이 인상적입니다.

---

### 1. 시간 복잡도 분석
*   **시간 복잡도**: $O(N)$
    *   두 방식 모두 트리 내의 모든 노드를 정확히 한 번씩 방문하므로 $N$(노드의 개수)에 비례하는 시간 복잡도를 가집니다.
*   **최적화 가능성**: 현재 상태에서 $O(N)$보다 더 효율적인 방법은 없습니다. 트리 전체를 순회해야 최대 깊이를 확정할 수 있기 때문입니다.

### 2. 공간 복잡도 분석
*   **공간 복잡도**: $O(H)$ (여기서 $H$는 트리의 높이)
    *   재귀 호출 스택(Recursion Stack)의 깊이는 트리의 높이에 비례합니다. 
    *   최악의 경우(Skewed Tree) $O(N)$, 균형 잡힌 트리일 경우 $O(\log N)$의 공간을 사용합니다.

### 3. "정석" 풀이 방법
이 문제는 크게 두 가지 방식으로 나뉩니다.
1.  **DFS (Top-down)**: `maxDepth2`와 같은 방식입니다. 각 하위 노드에서 반환된 값 중 큰 값에 1을 더하는 **Bottom-up** 형태가 훨씬 직관적이고 보편적입니다.
2.  **BFS (Level-order Traversal)**: 큐(Queue)를 사용하여 레벨별로 순회하며 카운트를 올리는 방식입니다. 트리가 매우 깊을 때 재귀 호출로 인한 스택 오버플로우를 방지할 수 있습니다.

### 4. 현재 풀이의 적절성 및 개선 제안

#### `traverse` 방식 (Top-down)의 피드백:
*   `inout`을 사용하는 방식은 사이드 이펙트(Side-effect)를 발생시키므로, 함수형 프로그래밍 관점에서는 권장되지 않습니다.
*   `guard let` 이후 `result = max(result, currentDepth)`를 호출하는 로직에서, `nil` 노드에 도달했을 때 불필요한 비교가 발생합니다.

#### `maxDepth2` 방식 (Bottom-up)의 피드백:
*   이 방식이 훨씬 깔끔하고 정석적인 풀이입니다.
*   **엣지 케이스**: `root`가 `nil`일 때 `0`을 반환하는 처리가 정확합니다.

### 5. Swift 언어적 특성(Idiomatic Code) 반영

제시하신 `maxDepth2`를 더 Swift답게 다듬어 보겠습니다.

```swift
class Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        // Swift의 고차함수나 간결한 문법을 활용하면 더 읽기 쉽습니다.
        guard let root = root else { return 0 }
        
        return 1 + max(maxDepth(root.left), maxDepth(root.right))
    }
}
```

**수정 제안:**
1.  **불필요한 함수 제거**: `traverse`와 같이 상태를 외부 변수(`inout`)로 제어하는 함수는 코드를 복잡하게 만듭니다. `maxDepth2`의 로직만으로 충분히 해결 가능합니다.
2.  **가독성**: `guard let root = root`는 `guard let root else`로 짧게 쓸 수 있습니다(Swift 5.7+). 이미 작성하신 코드는 최신 Swift 버전을 잘 사용하고 계십니다.
3.  **명명 규칙**: 문제에서 요구하는 인터페이스에 맞춰 `maxDepth` 하나만 남기고, 내부 로직을 최적화하는 방향을 추천합니다.

### 최종 리뷰 총평
작성하신 `maxDepth2`는 매우 훌륭한 **Bottom-up 재귀 풀이**입니다. `inout`을 사용하는 `traverse` 방식은 코드 복잡도만 높이므로, 향후 알고리즘 문제 해결 시에는 **재귀 함수의 반환값(Return Value)을 활용하는 구조**로 통일하시는 것을 강력히 권장합니다. 

코드의 완성도는 높으며, 개념을 아주 잘 이해하고 계십니다! 다음 단계로 **BFS를 이용한 반복문(Iterative) 풀이**도 시도해 보시면 더욱 좋습니다.