# LeetCode No.242 Valid Anagram Code Review

안녕하세요, 시니어 알고리즘 코드 리뷰어입니다.
LeetCode No.242 Valid Anagram 문제 풀이 코드에 대한 리뷰를 시작하겠습니다.

전반적으로 `Map`을 사용하여 문자의 빈도를 계산하는 방식은 `Valid Anagram` 문제의 **표준적이고 효율적인 풀이**입니다. TypeScript의 언어적 특성도 잘 활용하고 계십니다. 다만, 몇 가지 개선할 수 있는 부분이 있습니다.

---

### 코드 리뷰

#### 1. 시간 복잡도 (Time Complexity)

*   **현재 풀이 분석:**
    *   첫 번째 `for...of s` 루프: `s`의 길이 `N`에 비례합니다. `Map.set()` 및 `Map.get()`은 평균적으로 `O(1)` 시간 복잡도를 가집니다. 따라서 `O(N)`.
    *   두 번째 `for...of t` 루프: `t`의 길이 `M`에 비례합니다. 마찬가지로 `O(M)`.
    *   세 번째 `for...of so` 루프: `s`에 있는 유니크한 문자의 개수 `k`에 비례합니다. `Map.get()`은 `O(1)`. 따라서 `O(k)`.
    *   네 번째 `for...of to` 루프: `t`에 있는 유니크한 문자의 개수 `j`에 비례합니다. `Map.get()`은 `O(1)`. 따라서 `O(j)`.
    *   **총 시간 복잡도:** `O(N + M + k + j)` 입니다.
        알파벳의 크기가 고정되어 있다고 가정하면 (`k`, `j`는 최대 26) `k`와 `j`는 상수로 취급할 수 있으므로, 최종적으로 `O(N + M)` 입니다.
*   **최적화 가능성:**
    *   `O(N + M)`은 문자열의 모든 문자를 한 번씩 읽어야 하므로, 이 문제에서 달성할 수 있는 **최적의 시간 복잡도**입니다. 추가적인 시간 복잡도 최적화는 어렵습니다.
    *   다만, 코드 내에서 불필요한 연산을 제거하여 상수를 줄일 수는 있습니다. (아래 4번에서 설명)

#### 2. 공간 복잡도 (Space Complexity)

*   **현재 풀이 분석:**
    *   `so` Map: `s`에 있는 유니크한 문자의 개수 `k`만큼의 공간을 사용합니다.
    *   `to` Map: `t`에 있는 유니크한 문자의 개수 `j`만큼의 공간을 사용합니다.
    *   **총 공간 복잡도:** `O(k + j)` 입니다.
        알파벳의 크기가 고정되어 있다면 (예: 소문자 영어 알파벳 26개), `k`와 `j`는 최대 26이므로, 이는 사실상 `O(1)` (상수 공간)으로 볼 수 있습니다. (알파벳 크기에 종속적)
*   **최적화 가능성:**
    *   두 개의 `Map` 대신 하나의 `Map`만 사용하여 공간을 약간 절약할 수 있습니다. (아래 4번에서 설명) `O(k)` 또는 `O(j)`가 됩니다. 이 역시 알파벳 크기 고정 시 `O(1)`입니다.

#### 3. 보편적인 "정석" 풀이 방법

*   **해당 문제의 "정석" 풀이:**
    *   현재 사용하신 **문자 빈도수 세기 (Frequency Counting)** 방식이 가장 보편적이고 효율적인 "정석" 풀이 방법입니다. `Map`이나 배열(소문자 알파벳 26개 등 특정 조건 하에)을 사용하여 각 문자의 출현 횟수를 기록하고 비교하는 것이 핵심입니다.
    *   다른 접근법으로는 두 문자열을 각각 정렬하여 비교하는 방법이 있지만, 이 경우 `O(N log N + M log M)`의 시간 복잡도를 가지므로 빈도수 세기 방식보다 효율적이지 못합니다.
*   **DP, 그래프 등 문제 유형에 맞는 접근법:**
    *   `Valid Anagram` 문제는 DP(동적 계획법)나 그래프 이론을 적용하기에 적합한 유형이 아닙니다. 문자열 조작 및 빈도수 비교에 중점을 둡니다.

#### 4. 현재 풀이의 적절성과 개선 가능한 부분 (엣지 케이스 포함)

*   **장점:**
    *   `Map`을 사용하여 어떤 문자(`string`)라도 키로 사용할 수 있어, 알파벳 제한이 없는 경우에도 유연하게 대처할 수 있습니다.
    *   `existing = so.get(letter) ?? 0;`와 같이 Nullish Coalescing Operator (`??`)를 사용하여 코드를 간결하고 안전하게 작성했습니다.
*   **개선 가능한 부분:**
    1.  **초기 길이 비교:** 애너그램이 되려면 두 문자열의 길이가 반드시 같아야 합니다. 이를 초기에 확인하는 것이 가장 효율적인 엣지 케이스 처리입니다.
        ```typescript
        if (s.length !== t.length) {
          return false;
        }
        ```
        이 조건을 추가하면 불필요한 Map 생성 및 루프를 피할 수 있습니다.
    2.  **중복된 비교 루프 제거:**
        `s.length === t.length`라는 조건이 추가되면, `for (const pair of to)` 루프는 더 이상 필요하지 않습니다.
        만약 두 문자열의 길이가 같고, `so` Map에 있는 모든 문자의 빈도수가 `to` Map의 빈도수와 일치한다면, `to` Map에는 `so` Map에 없는 문자가 존재할 수 없습니다. 존재한다면 `so`의 빈도수가 `to`의 빈도수와 다르게 되므로 첫 번째 비교 루프 (`for (const pair of so)`)에서 이미 `false`를 반환했을 것입니다.
    3.  **하나의 Map 사용:**
        두 개의 Map을 사용하는 대신, 하나의 Map만 사용하여 문제를 해결할 수 있습니다.
        *   `s`의 문자를 순회하며 Map에 빈도수를 `+1` 합니다.
        *   `t`의 문자를 순회하며 Map에 빈도수를 `-1` 합니다.
        *   이때, 만약 Map에 없는 문자가 `t`에 나타나거나, 빈도수가 `0` 아래로 떨어지면 애너그램이 아닙니다.
        *   마지막으로 Map의 모든 엔트리(빈도수)가 `0`인지 확인합니다.
        이 방식은 Map을 한 번만 생성하고, 마지막 확인 루프도 한 번만 돌면 되므로 미세하게 더 효율적일 수 있습니다.

*   **엣지 케이스 처리:**
    *   **빈 문자열:** `isAnagram("", "")` -> `true`. 현재 코드도 `so`, `to`가 비어있고 루프가 돌지 않아 `true`를 반환합니다. 적절합니다.
    *   **다른 길이의 문자열:** 현재 코드는 `s="ab"`, `t="a"`일 때 `so` 루프에서 `b`가 `to`에 없으므로 `so.get("b") !== to.get("b")` (1 !== undefined)가 되어 `false`를 반환합니다. `s="a"`, `t="ab"`일 때도 `so` 루프에서 `a`는 일치하지만 `to` 루프에서 `b`가 `so`에 없으므로 `false`를 반환합니다. 즉, 현재 코드도 작동은 하나, `s.length !== t.length` 체크가 가장 빠르고 명시적인 방법입니다.

#### 5. TypeScript의 언어적 특성(Idiomatic Code)을 잘 살렸는지 준수 여부

*   **매우 잘 준수하고 있습니다.**
    *   **명확한 타입 명시:** 함수 인자, 반환 값, 변수 (`Map<string, number>`)에 타입을 명확히 명시하여 코드의 가독성과 안정성을 높였습니다.
    *   **`for...of` 루프:** 문자열과 `Map`의 엔트리(Iterable)를 순회하는 데 `for...of`를 효과적으로 사용했습니다.
    *   **Nullish Coalescing Operator (`??`):** `so.get(letter) ?? 0`와 같이 `Map.get()`의 결과가 `undefined`일 때 기본값을 설정하는 TypeScript/JavaScript의 현대적인 문법을 사용하여 코드를 간결하고 안전하게 만들었습니다.
    *   **변수명:** `so`, `to`는 다소 축약되어 있지만, 문맥상 `s occurrences`, `t occurrences`로 유추 가능합니다. 좀 더 명시적으로 `sCharCounts`, `tCharCounts` 등으로 변경할 수도 있습니다.

---

### 개선된 코드 예시 (Refactored Code)

위에서 논의된 개선사항들을 반영한 코드입니다.

```typescript
// LeetCode No.242 Valid Anagram

function isAnagram(s: string, t: string): boolean {
  // 1. 초기 길이 비교: 애너그램이 되려면 두 문자열의 길이가 반드시 같아야 합니다.
  if (s.length !== t.length) {
    return false;
  }

  // 하나의 Map을 사용하여 문자 빈도수를 관리합니다.
  // s의 문자는 +1, t의 문자는 -1
  const charCounts = new Map<string, number>();

  for (const letter of s) {
    const existing = charCounts.get(letter) ?? 0;
    charCounts.set(letter, existing + 1);
  }

  for (const letter of t) {
    const existing = charCounts.get(letter) ?? 0;
    // t에 있는 문자를 처리할 때, 빈도수가 0이거나 음수가 되면 애너그램이 아님
    // (s에 해당 문자가 없었거나, s보다 t에 더 많은 문자가 있었음)
    if (existing === 0) { // s에는 없었거나 이미 모두 사용된 문자
      return false;
    }
    charCounts.set(letter, existing - 1);
  }

  // 최종 확인: 모든 문자의 빈도수가 0이 되어야 합니다.
  // (사실 위 두 번째 루프에서 이미 처리되어 이 루프는 불필요할 수 있습니다.
  //  existing === 0 체크가 빈도수 불일치를 모두 잡기 때문입니다.)
  // 하지만 명시적인 확인을 위해 남겨둘 수 있습니다.
  // 만약 두 번째 루프에서 existing === 0 체크를 하지 않는다면, 이 루프는 필수입니다.
  // 현재 로직에서는 위의 `if (existing === 0)`에서 대부분의 케이스를 잡으므로,
  // 이 최종 순회는 엄밀히 말하면 불필요합니다.
  // (s와 t의 길이가 같고, t를 순회하며 모두 0으로 만들었으므로)
  // 예를 들어, s = "a", t = "b" 인 경우:
  // s 루프: charCounts = {"a": 1}
  // t 루프: charCounts.get("b") ?? 0 => 0 이므로 즉시 false 반환.
  //
  // s = "rat", t = "car" 인 경우:
  // s 루프: {"r":1, "a":1, "t":1}
  // t 루프:
  //   "c": existing=0 -> false 반환
  //
  // 결론: `if (existing === 0)` 조건만 있으면 마지막 루프는 필요 없습니다.

  // 따라서 최종적으로 charCounts Map의 모든 값이 0인지 확인할 필요 없이,
  // 두 번째 루프에서 `existing === 0` 검사를 통해 모든 불일치를 잡을 수 있습니다.
  // 이 시점에서 함수가 `return true`에 도달했다는 것은 모든 문자의 빈도수가 일치한다는 의미입니다.
  return true;
}
```

### 개선된 코드 (최종 - 더 간결하게)

위의 설명에 따라 마지막 `charCounts` Map 확인 루프도 필요 없습니다.

```typescript
// LeetCode No.242 Valid Anagram - Refactored

function isAnagram(s: string, t: string): boolean {
  // 1. 길이 비교는 가장 빠른 검사입니다.
  if (s.length !== t.length) {
    return false;
  }

  // 2. 하나의 Map을 사용하여 빈도수를 추적합니다.
  const charCounts = new Map<string, number>();

  // s의 각 문자에 대해 빈도수를 증가시킵니다.
  for (const char of s) {
    charCounts.set(char, (charCounts.get(char) ?? 0) + 1);
  }

  // t의 각 문자에 대해 빈도수를 감소시킵니다.
  // 만약 Map에 해당 문자가 없거나(get()이 undefined), 이미 0이 되었다면
  // t에는 s에 없는 문자가 있거나, s보다 t에 해당 문자가 더 많다는 의미이므로 false를 반환합니다.
  for (const char of t) {
    const count = charCounts.get(char);
    if (count === undefined || count === 0) {
      return false; // s에 없거나, s의 해당 문자 개수가 이미 소진됨
    }
    charCounts.set(char, count - 1);
  }

  // 3. 길이가 같고, t를 순회하면서 모든 문자의 빈도수가 0으로 정확히 맞아떨어졌다면,
  // 모든 문자의 빈도수가 일치한다는 의미이므로 애너그램입니다.
  // 이 시점에서 charCounts Map의 모든 값은 0일 것이므로 별도의 검사 루프는 필요 없습니다.
  return true;
}
```

---

### 총평

초기 코드는 `Valid Anagram` 문제를 해결하기 위한 올바른 접근 방식과 TypeScript의 좋은 기능을 잘 활용하고 있었습니다. 특히 `Map`과 `??` 연산자의 사용은 인상 깊었습니다. 몇 가지 논리적인 개선과 엣지 케이스 처리를 위한 최적화 (초기 길이 비교, 단일 Map 사용)를 통해 더욱 견고하고 효율적인 코드로 발전시킬 수 있습니다.