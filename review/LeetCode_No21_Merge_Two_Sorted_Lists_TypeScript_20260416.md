# LeetCode No.21 Merge Two Sorted Lists Code Review

시니어 알고리즘 리뷰어입니다. 제출해주신 `Merge Two Sorted Lists` 풀이를 검토했습니다. 전체적으로 문제의 핵심인 포인터 이동 로직을 정확히 파악하고 구현하셨습니다. 코드 품질을 높이기 위한 피드백을 드립니다.

---

### 1. 시간 및 공간 복잡도 분석
*   **시간 복잡도**: **O(n + m)**
    *   두 리스트의 길이를 각각 $n, m$이라 할 때, 각 노드를 최대 한 번씩 방문하므로 최적의 시간 복잡도입니다.
*   **공간 복잡도**: **O(1)**
    *   입력된 노드의 메모리를 재사용하며, 추가적인 데이터 구조(배열 등)를 생성하지 않으므로 매우 효율적입니다.

### 2. 코드 리뷰 및 개선 제안

#### A. 더 깔끔한 구조: "Dummy Node" 패턴
현재 작성하신 코드의 초기 시작 부분(null 체크 및 첫 번째 노드 선정)은 조건문이 많아 다소 복잡합니다. 연결 리스트 문제에서 관용적으로 사용하는 **`dummy node`** 기법을 사용하면 코드가 훨씬 간결해집니다.

*   **이유**: `dummy` 노드를 활용하면 시작점을 고민할 필요 없이 `result.next`를 계속 붙여나가기만 하면 됩니다. 결과적으로 `dummy.next`를 반환하면 되므로 엣지 케이스 처리 로직을 획기적으로 줄일 수 있습니다.

#### B. 타입스크립트의 언어적 특성 (Idiomatic Code)
현재 코드는 `if-else` 분기가 많아 가독성이 떨어집니다. `dummy` 노드를 도입하면 `if`문의 깊이를 줄일 수 있습니다. 또한, 타입스크립트의 옵셔널 체이닝 등을 활용할 수도 있지만, 알고리즘 풀이에서는 명시적인 포인터 조작이 더 안전합니다.

---

### 3. 개선된 코드 제안 (Dummy Node 적용)

```typescript
function mergeTwoLists(
  list1: ListNode | null,
  list2: ListNode | null,
): ListNode | null {
  // 1. 더미 노드 생성 (시작점 고민 해결)
  const dummy = new ListNode();
  let current = dummy;

  // 2. 두 리스트 모두 존재할 때까지 순회
  while (list1 !== null && list2 !== null) {
    if (list1.val < list2.val) {
      current.next = list1;
      list1 = list1.next;
    } else {
      current.next = list2;
      list2 = list2.next;
    }
    current = current.next;
  }

  // 3. 남은 노드 연결 (한쪽이 null이면 나머지를 바로 붙임)
  current.next = list1 || list2;

  // 4. 더미 노드의 다음 노드가 실제 시작점
  return dummy.next;
}
```

### 4. 총평 및 피드백 요약

1.  **엣지 케이스**: 기존 코드의 `!list1 && !list2` 등 초기 분기 처리는 정확하지만, 위와 같이 `dummy` 노드를 사용하면 자연스럽게 커버되어 가독성이 훨씬 좋아집니다.
2.  **연결 로직**: `while` 루프가 끝난 뒤 `result.next = list1 || list2`와 같이 작성하면, 남은 리스트를 한 번에 연결할 수 있어 코드 줄 수를 줄이고 논리를 명확히 할 수 있습니다.
3.  **가독성**: `result` 변수 대신 `current`나 `tail`과 같은 변수명을 사용하면 "현재 리스트의 끝을 가리키고 있다"는 의미가 더 명확해집니다.

**결론**: 시간/공간 복잡도는 이미 최적입니다. **더미 노드 패턴**을 체득하시면 향후 더 복잡한 연결 리스트 문제(예: `Merge k Sorted Lists` 등)에서 훨씬 효율적인 코드를 작성하실 수 있을 것입니다. 잘 구현하셨습니다!