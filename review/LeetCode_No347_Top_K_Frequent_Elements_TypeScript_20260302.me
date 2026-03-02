# LeetCode No.347 Top K Frequent Elements Code Review

## 알고리즘 문제 풀이 코드 리뷰: LeetCode No.347 Top K Frequent Elements

안녕하세요, 시니어 알고리즘 코드 리뷰어입니다. LeetCode No.347 "Top K Frequent Elements" 문제에 대한 TypeScript 풀이 코드를 검토하겠습니다.

### 💡 개요 (Overview)

제공된 코드는 `Map`을 사용하여 각 숫자의 빈도수를 계산한 다음, 이 빈도수를 기준으로 정렬하여 상위 `k`개의 요소를 추출하는 방식입니다. 문제 해결에 접근하는 방식은 명확하고 이해하기 쉽습니다.

전반적으로 코드는 문제의 요구사항을 충족하며 올바르게 동작합니다. 다만, 시간 복잡도 측면에서 최적화의 여지가 있으며, TypeScript의 몇 가지 언어적 특성을 더 잘 활용하여 코드를 더욱 간결하게 만들 수 있습니다.

### 1. 시간 복잡도 (Time Complexity)

현재 풀이의 각 단계별 시간 복잡도를 분석하고, 최적화 가능성을 살펴보겠습니다.

1.  **빈도수 계산 (`occurences` Map 구축):**
    *   `for (const num of nums)` 루프는 `nums` 배열을 한 번 순회합니다. (N번)
    *   `Map.get()` 및 `Map.set()` 작업은 평균적으로 O(1)의 시간을 소요합니다.
    *   **결론: O(N)** (N은 `nums` 배열의 길이)

2.  **Map을 배열로 변환 및 정렬:**
    *   `Array.from(occurences)`: `occurences` Map에 있는 고유한 요소의 개수(M)만큼 요소를 배열로 변환합니다. **O(M)**
    *   `result.sort(...)`: M개의 요소를 정렬합니다. 표준 정렬 알고리즘(예: Timsort, QuickSort)은 **O(M log M)**의 시간을 소요합니다.
    *   **결론: O(M log M)** (M은 고유한 숫자의 개수)

3.  **상위 K개 요소 추출:**
    *   `result.map(...)`: M개의 요소를 순회하여 숫자(키)만 추출합니다. **O(M)**
    *   `mapped.slice(0, k)`: 처음부터 `k`개의 요소를 새 배열로 복사합니다. **O(k)**
    *   **결론: O(M)** (k <= M 이므로)

**총 시간 복잡도:** 위 단계들의 합산 중 가장 큰 복잡도를 따르므로 **O(N + M log M)** 입니다. 최악의 경우 (모든 숫자가 고유하여 M=N), **O(N log N)**이 됩니다.

**최적화 가능성:**
`O(M log M)` 정렬 단계가 주요 병목 지점입니다. "Top K" 문제의 일반적인 최적화 방법은 다음과 같습니다.

*   **Min-Heap (Priority Queue) 사용:**
    1.  빈도수를 계산합니다 (**O(N)**).
    2.  `occurences` Map의 `M`개 항목을 순회하며 `k` 크기의 최소 힙(Min-Heap)을 유지합니다.
    3.  힙의 크기가 `k`보다 작으면 요소를 푸시합니다. 힙의 크기가 `k`이고 현재 요소의 빈도수가 힙의 루트(가장 작은 빈도수)보다 크면, 루트를 팝하고 현재 요소를 푸시합니다.
    4.  힙에 남아있는 `k`개 요소가 상위 `k`개입니다.
    이 방법의 시간 복잡도는 **O(N + M log k)** 입니다. `k`가 `M`보다 훨씬 작을 때 큰 성능 향상을 기대할 수 있습니다. TypeScript에는 내장된 힙 자료구조가 없으므로 직접 구현해야 합니다.

*   **버킷 정렬 (Bucket Sort / Counting Sort) 사용:**
    이 방법은 `O(N)`의 선형 시간 복잡도로 최적의 성능을 제공합니다.
    1.  빈도수를 계산합니다 (**O(N)**).
    2.  최대 빈도수가 `N`이 될 수 있음을 이용하여, `buckets`라는 배열을 생성합니다. `buckets[freq]`는 해당 `freq`를 가진 모든 숫자의 목록을 저장합니다. (`Array<number[]> = new Array(N + 1).fill(0).map(() => [])`)
    3.  `occurences` Map을 순회하면서 각 숫자와 빈도수를 해당 `buckets[freq]`에 추가합니다 (**O(M)**).
    4.  `freq`를 `N`부터 1까지 역순으로 순회하며 `buckets[freq]`에 있는 숫자들을 결과 배열에 추가합니다. 결과 배열의 크기가 `k`가 되면 중단합니다 (**O(N)**).
    이 방법의 총 시간 복잡도는 **O(N + M + N) = O(N)** 입니다.

### 2. 공간 복잡도 (Space Complexity)

현재 풀이의 각 단계별 공간 복잡도를 분석합니다.

1.  **`occurences` Map:**
    *   고유한 숫자 `M`개와 그 빈도수를 저장합니다.
    *   **결론: O(M)**

2.  **`result` 배열:**
    *   `occurences` Map에서 변환된 `M`개의 `[숫자, 빈도수]` 쌍을 저장합니다.
    *   **결론: O(M)**

3.  **`mapped` 배열 및 최종 반환 배열:**
    *   `mapped` 배열은 `M`개의 숫자를 저장합니다. `slice`는 `k`개의 숫자를 가진 새 배열을 생성합니다.
    *   **결론: O(M)** (k <= M 이므로)

**총 공간 복잡도:** **O(M)** 입니다. 최악의 경우 (모든 숫자가 고유하여 M=N), **O(N)**이 됩니다.

### 3. 보편적인 "정석" 풀이 방법 (Standard Approaches)

"Top K Frequent Elements"는 "Top K" 유형 문제의 고전적인 예시입니다. 보편적인 "정석" 풀이 방법은 다음과 같습니다.

1.  **빈도수 계산 + 정렬 (현재 풀이):** 가장 직관적이고 구현이 쉬운 방법입니다. `M`이 작거나 `N`과 `k`의 크기가 비슷한 경우 적절합니다.
2.  **빈도수 계산 + Min-Heap (Priority Queue):** `k`가 `M`에 비해 상대적으로 작을 때 효율적입니다. `M log k`의 시간 복잡도를 가집니다. 많은 언어에서 기본 제공하는 힙 자료구조가 있어 쉽게 적용할 수 있습니다.
3.  **빈도수 계산 + 버킷 정렬:** 빈도수의 범위가 명확할 때 (최대 빈도수가 `N`을 넘지 않음) 사용할 수 있는 가장 효율적인 방법입니다. `O(N)`의 선형 시간 복잡도를 가집니다.

### 4. 현재 풀이의 적절성 및 개선점 (Appropriateness & Improvements)

*   **적절성:**
    *   **정확성:** 코드는 올바르게 작동하며 문제의 요구사항을 충족합니다.
    *   **가독성:** 전체적인 흐름이 명확하여 이해하기 쉽습니다.
    *   **문제 해결:** `k`개의 가장 빈번한 요소를 찾아 반환하는 목적을 달성합니다.

*   **개선 가능한 부분:**

    1.  **빈도수 계산 로직 간결화:**
        현재 코드는 `if/else` 블록을 사용하여 Map에 숫자가 있는지 확인합니다. 이를 더 간결하게 표현할 수 있습니다.

        ```typescript
        // 현재 코드:
        // if (occurences.get(num)) {
        //     const newValue = occurences.get(num);
        //     occurences.set(num, newValue + 1);
        // } else {
        //     occurences.set(num, 1);
        // }

        // 개선된 코드 (nullish coalescing operator 사용):
        occurences.set(num, (occurences.get(num) ?? 0) + 1);
        // 또는 (짧은 평가 && 연산자 사용):
        // occurences.set(num, (occurences.get(num) || 0) + 1);
        ```
        `??` 연산자(nullish coalescing operator)는 `undefined`나 `null`일 때만 기본값을 사용하므로, `0`이 유효한 값으로 올 수 있는 경우에 `||`보다 더 안전합니다. 이 경우 `Map.get()`은 `undefined`를 반환할 수 있으므로 `?? 0`이 적절합니다.

    2.  **메서드 체이닝을 통한 코드 간결화:**
        중간 변수(`result`, `mapped`)를 여러 번 선언하고 재할당하는 대신, 메서드 체이닝을 통해 코드를 더욱 간결하고 함수형 프로그래밍 스타일에 가깝게 만들 수 있습니다.

        ```typescript
        // 현재 코드:
        // let result = Array.from(occurences);
        // result = result.sort((a, b): number => { return b[1] - a[1] });
        // const mapped = result.map((a): number => { return a[0] })
        // return mapped.slice(0, k);

        // 개선된 코드 (메서드 체이닝):
        return Array.from(occurences.entries()) // Map의 [key, value] 쌍을 배열로 변환
                     .sort((a, b) => b[1] - a[1]) // 빈도수(value)를 기준으로 내림차순 정렬
                     .slice(0, k) // 상위 k개 요소만 추출
                     .map(pair => pair[0]); // 각 쌍에서 숫자(key)만 추출
        ```
        `occurences.entries()`를 사용하여 명시적으로 `[key, value]` 쌍을 가져오는 것이 더 명확할 수 있습니다. `Array.from(occurences)`도 동일한 결과를 반환합니다.

*   **엣지 케이스 처리:**
    *   `nums`가 비어있는 경우: 코드는 빈 배열을 올바르게 반환합니다.
    *   `k`가 `nums`의 고유 요소 수보다 큰 경우: LeetCode 문제 제약 조건에 따르면 `k`는 항상 고유 요소 수보다 작거나 같습니다. 하지만 코드는 `slice(0, k)`를 통해 안전하게 가능한 모든 고유 요소를 반환합니다.
    *   모든 숫자의 빈도수가 동일한 경우: `sort`의 안정성(stable sort) 여부에 따라 반환되는 `k`개의 요소 순서가 달라질 수 있지만, 문제에서는 어떤 순서로든 반환해도 된다고 명시되어 있으므로 문제가 없습니다.

### 5. TypeScript 언어적 특성 준수 여부 (TypeScript Idioms)

*   **타입 명시:**
    *   함수 시그니처 `topKFrequent(nums: number[], k: number): number[]`는 매우 잘 명시되어 있습니다.
    *   `Map<number, number>()`도 정확한 타입입니다.
    *   `sort` 콜백 `(a, b): number` 및 `map` 콜백 `(a): number`의 반환 타입 명시는 코드를 더욱 명확하게 만듭니다.

*   **타입 추론 활용:** `const newValue`와 같이, TypeScript 컴파일러가 타입을 추론할 수 있는 곳에서는 명시적으로 타입을 선언하지 않아도 됩니다. 이 코드에서는 적절히 활용되고 있습니다.

*   **Idiomatic JavaScript/TypeScript 패턴:**
    *   위에서 언급했듯이, `(occurences.get(num) ?? 0) + 1`와 같은 빈도수 계산 패턴과 메서드 체이닝을 활용하는 것은 TypeScript/JavaScript 커뮤니티에서 권장되는 간결하고 표현력 있는 코드 스타일입니다.

전반적으로 TypeScript의 기본적인 문법과 타입 시스템을 잘 활용하고 있습니다. 위에서 제안된 개선 사항들은 코드의 간결성과 가독성, 그리고 작은 성능 최적화를 위한 TypeScript/JavaScript idiom 적용에 중점을 둡니다.

---

### 📝 결론 (Conclusion)

제공된 `topKFrequent` 함수는 문제 해결에 있어 **정확하고 이해하기 쉬운 풀이**입니다. 특히 처음 알고리즘을 접하는 분들에게는 이 "Map + Sort" 방식이 가장 직관적이고 구현하기 쉬운 방법일 것입니다.

성능 측면에서 더 높은 효율을 요구하는 경우(`O(N)` 또는 `O(N + M log k)`), 힙이나 버킷 정렬과 같은 고급 자료구조/알고리즘을 고려할 수 있습니다.

**최종 권고사항:**

1.  **빈도수 계산 로직을 `occurences.set(num, (occurences.get(num) ?? 0) + 1);` 로 간결하게 변경하는 것을 추천합니다.**
2.  **메서드 체이닝을 활용하여 `Array.from(...).sort(...).slice(...).map(...)` 형태로 코드를 작성하면 더욱 간결하고 가독성이 높아집니다.**

이 외의 부분은 잘 작성되었습니다. 좋은 코드입니다!