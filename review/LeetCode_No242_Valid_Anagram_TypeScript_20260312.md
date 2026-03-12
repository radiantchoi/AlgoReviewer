# LeetCode No.242 Valid Anagram Code Review

훌륭한 문제 선택과 깔끔한 코드입니다. LeetCode No.242 "Valid Anagram" 문제에 대한 TypeScript 풀이를 시니어 알고리즘 코드 리뷰어의 관점에서 심도 있게 분석해 드리겠습니다.

---

### LeetCode No.242 Valid Anagram - 코드 리뷰

**요약:**
제시된 코드는 `Map`을 사용하여 두 문자열의 각 문자에 대한 빈도수를 계산하고 비교하는 방식으로 아나그램 여부를 판단합니다. 이 접근 방식은 정확하며, `Map`을 사용하는 것이 TypeScript/JavaScript에서 문자열 빈도수를 효율적으로 관리하는 일반적인 방법 중 하나입니다. `??` 연산자를 사용하여 `Map.get()`의 결과가 `undefined`일 때 기본값 `0`을 설정하는 방식은 매우 간결하고 idiomatic TypeScript 코드입니다.

하지만 시간 복잡도, 공간 복잡도, 그리고 특히 엣지 케이스 처리 및 최적화 측면에서 개선할 수 있는 여지가 있습니다.

---

#### 1. 시간 복잡도 (Big-O 분석 및 최적화 가능성)

*   **현재 코드 분석:**
    *   첫 번째 루프 (`for (const letter of s)`): `s`의 길이 `N`에 비례합니다. `Map.get` 및 `Map.set` 작업은 평균적으로 `O(1)`입니다. 따라서 `O(N)`.
    *   두 번째 루프 (`for (const letter of t)`): `t`의 길이 `M`에 비례합니다. `O(M)`.
    *   세 번째 루프 (`for (const pair of so)`): `so` 맵에 있는 고유 문자의 개수 `K_s`에 비례합니다. `Map.get` 작업은 `O(1)`. 따라서 `O(K_s)`.
    *   네 번째 루프 (`for (const pair of to)`): `to` 맵에 있는 고유 문자의 개수 `K_t`에 비례합니다. `Map.get` 작업은 `O(1)`. 따라서 `O(K_t)`.
    *   **총 시간 복잡도:** `O(N + M + K_s + K_t)`.
    *   주어진 제약 조건(예: 소문자 영어 알파벳) 하에서는 `K_s`와 `K_t`는 최대 26으로 상수가 됩니다. 따라서 일반적인 문자열 길이에 따라 `O(N + M)`으로 간주할 수 있습니다. 이는 두 문자열을 모두 읽어야 하므로 이 문제에 대한 최적의 시간 복잡도입니다.

*   **최적화 가능성:**
    1.  **길이 비교 조기 종료:** 아나그램이 되려면 두 문자열의 길이가 반드시 같아야 합니다. `s.length !== t.length`일 경우 즉시 `false`를 반환함으로써 불필요한 빈도수 계산 작업을 생략할 수 있습니다. 이는 `O(1)` 체크로 전체 알고리즘의 실행 시간을 크게 단축시킬 수 있는 가장 중요한 최적화입니다.
    2.  **단일 맵 사용:** 위에서 언급한 길이 조기 종료 조건이 추가되면, 두 개의 맵을 만들 필요 없이 하나의 맵만으로 충분합니다. `s`의 빈도수를 맵에 저장한 후, `t`의 문자를 순회하면서 맵의 해당 빈도수를 감소시킵니다. 만약 어떤 문자의 빈도수가 0이 되거나 이미 0인데 감소시키려 한다면 (즉, `t`가 `s`보다 특정 문자를 더 많이 가지고 있다면), 아나그램이 아닙니다. 이 방식은 `Map`을 한 번만 순회하는 효과를 줍니다.

#### 2. 공간 복잡도

*   **현재 코드 분석:**
    *   `so` 맵: `s`의 고유 문자 개수 `K_s`만큼의 공간을 사용합니다. `O(K_s)`.
    *   `to` 맵: `t`의 고유 문자 개수 `K_t`만큼의 공간을 사용합니다. `O(K_t)`.
    *   **총 공간 복잡도:** `O(K_s + K_t)`.
    *   알파벳 크기가 고정된 경우(예: 소문자 영어 알파벳 26개)에는 `K_s`, `K_t`가 상수이므로 `O(1)`로 간주할 수 있습니다. 그러나 일반적인 유니코드 문자열의 경우, 최악의 시나리오에서는 `K_s`가 `N`에, `K_t`가 `M`에 가까워질 수 있어 `O(N + M)`이 될 수 있습니다.

*   **최적화 가능성:**
    *   **단일 맵 사용:** 위에서 제안한 단일 맵 접근 방식을 사용하면, 필요한 공간이 `O(K_s)` (또는 `O(K_t)`와 비슷)로 줄어듭니다. 이는 공간 활용 측면에서 더 효율적입니다.
    *   **고정된 알파벳 크기 활용:** 만약 문제 조건이 "소문자 영어 알파벳"으로 명확히 제한된다면, `Map` 대신 크기 26의 `number[]` 배열을 사용하는 것이 공간 효율성 및 성능 면에서 더 유리합니다 (`O(1)` 공간).

#### 3. 보편적인 "정석" 풀이 방법

*   **빈도수 계산 (Frequency Count):** 현재 코드가 채택한 방식입니다. `Map` (또는 해시 테이블/객체)이나 고정 크기 배열을 사용하여 각 문자의 빈도수를 세는 방법은 아나그램 문제의 가장 보편적이고 "정석"적인 풀이 방법입니다. 문자열의 내용을 직접적으로 비교하는 대신 통계적인 특성을 이용하므로 유용합니다.
*   **정렬 (Sorting):** 다른 "정석"적인 방법은 두 문자열을 정렬한 후 비교하는 것입니다. `s.split('').sort().join('') === t.split('').sort().join('')`. 이 방법은 시간 복잡도가 `O(N log N + M log M)`이 되어 빈도수 계산보다 느릴 수 있지만, 구현이 매우 간단하다는 장점이 있습니다.

#### 4. 현재 풀이의 적절성과 개선 가능한 부분 (엣지 케이스 포함)

*   **적절성:**
    *   코드는 기능적으로 올바릅니다. `s`와 `t`가 아나그램인지 아닌지를 정확하게 판단합니다.
    *   `Map`을 사용한 빈도수 계산은 유니코드 문자 등 어떤 문자 집합에도 유연하게 대응할 수 있는 일반적인 해결책입니다.
*   **개선 가능한 부분:**
    1.  **길이 불일치 조기 종료 (Critical Improvement):**
        ```typescript
        // 개선 1: 길이 체크
        if (s.length !== t.length) {
          return false;
        }
        // ... (이후 로직 계속)
        ```
        이 한 줄 추가로 많은 엣지 케이스(예: `s="anagram", t="nagaramx"`)를 효율적으로 처리할 수 있으며, 불필요한 계산을 방지합니다. 현재 코드에서는 두 문자열의 길이가 다를 경우 모든 문자를 순회하고 맵을 비교하는 과정을 거쳐야 합니다. 예를 들어, `s="a", t="ab"`의 경우, 현재 코드는 두 맵을 모두 만들고 두 번의 맵 순회를 거쳐야 `false`를 반환합니다. 길이 체크를 먼저 하면 즉시 `false`를 반환합니다.
    2.  **단일 맵과 감소 방식 활용:**
        ```typescript
        function isAnagramOptimized(s: string, t: string): boolean {
          if (s.length !== t.length) {
            return false;
          }

          const charCounts = new Map<string, number>();

          // s의 문자 빈도수 증가
          for (const char of s) {
            charCounts.set(char, (charCounts.get(char) ?? 0) + 1);
          }

          // t의 문자 빈도수 감소
          for (const char of t) {
            const count = charCounts.get(char) ?? 0;
            if (count === 0) { // t가 s에 없는 문자를 가지고 있거나, s보다 더 많은 문자를 가지고 있음
              return false;
            }
            charCounts.set(char, count - 1);
          }

          // 모든 카운트가 0이어야 함 (길이가 같으므로 별도 검사 필요 없음)
          return true;
        }
        ```
        이 방식은 `s`를 순회하여 `charCounts`를 채우고, `t`를 순회하면서 `charCounts`를 감소시킵니다. 만약 어떤 문자에 대해 `t`가 `s`보다 더 많은 빈도수를 가졌다면 (또는 `s`에 없는 문자라면) `count`가 0이 되어 즉시 `false`를 반환합니다. 두 문자열의 길이가 같다는 조건 덕분에 `t` 순회가 끝난 후 `charCounts`의 모든 값이 0인지 명시적으로 확인할 필요가 없습니다. (0이 아닌 값이 있다면 그것은 `s`에만 있는 문자이며 `t`에서 해당 문자를 발견하지 못해 감소시키지 못한 것이므로, `t`의 길이에 도달했을 때 불일치가 발생하지 않았다면 자동으로 모든 카운트는 0이 됩니다.)
    3.  **엣지 케이스 처리:**
        *   `s = "", t = ""`: 현재 코드 및 개선 코드 모두 `true`를 반환합니다. (정확)
        *   `s = "a", t = ""`: 현재 코드는 `false`를 반환합니다. 개선 코드도 `s.length !== t.length`에서 `false`를 반환합니다. (정확)
        *   `s = "abc", t = "bca"`: 현재 코드 및 개선 코드 모두 `true`를 반환합니다. (정확)
        *   `s = "rat", t = "car"`: 현재 코드 및 개선 코드 모두 `false`를 반환합니다. (정확)
        *   `s = "a", t = "b"`: 현재 코드 및 개선 코드 모두 `false`를 반환합니다. (정확)

#### 5. TypeScript의 언어적 특성(Idiomatic Code)을 잘 살렸는지 준수 여부

*   **양호합니다.**
    *   `new Map<string, number>()`: 제네릭 타입을 명시하여 `Map`의 키와 값 타입을 명확히 선언한 것은 TypeScript 관점에서 아주 좋습니다.
    *   `for (const letter of s)`: 문자열을 순회하는 `for...of` 루프는 TypeScript/JavaScript에서 문자열, 배열, 맵 등을 순회하는 현대적이고 권장되는 방식입니다.
    *   `const existing = so.get(letter) ?? 0;`: `nullish coalescing operator (??)`를 사용하여 `Map.get()`이 `undefined`를 반환할 때 기본값 `0`을 할당하는 패턴은 매우 간결하고 TypeScript 3.7+부터 권장되는 idiomatic 코드입니다. 가독성을 높이고 불필요한 `if` 조건문을 줄여줍니다.
    *   변수명(`so`, `to`)은 명확하나, `sCounts`, `tCounts` 등 더 명시적인 이름을 사용하는 것도 고려해볼 수 있습니다. (`so`는 "s object"나 "s map"의 약어일 수 있지만 명확성이 떨어질 수 있습니다.)
    *   `for (const pair of so)`: `Map`의 엔트리를 순회하는 방식은 올바르지만, 구조 분해 할당(destructuring assignment)을 사용하면 더 깔끔하게 키와 값을 바로 얻을 수 있습니다.
        ```typescript
        // 현재:
        for (const pair of so) {
          const letter = pair[0];
          // ...
        }

        // 개선:
        for (const [letter, count] of so) {
          // count 변수도 바로 사용할 수 있습니다.
          if (count !== to.get(letter) || to.get(letter) === undefined) { // to.get(letter) === undefined 추가 (count가 0이 아닌데 to에 없는 경우)
             return false;
          }
        }
        ```
        (다만, 제안된 단일 맵 감소 방식에서는 이 맵 순회가 불필요해집니다.)

---

### 최종 권고 및 리팩토링 제안

현재 코드는 `Map`을 효과적으로 사용하여 문제의 본질을 해결하고 있으며, TypeScript의 최신 문법(`??` 연산자)을 잘 활용하고 있습니다. 하지만 성능과 간결성을 더욱 향상시키기 위해 다음 리팩토링된 코드를 권장합니다.

```typescript
// LeetCode No.242 Valid Anagram - Refactored

function isAnagram(s: string, t: string): boolean {
  // 1. 길이 체크: 아나그램이 되려면 두 문자열의 길이가 같아야 합니다.
  if (s.length !== t.length) {
    return false;
  }

  // 2. 단일 Map을 사용하여 문자 빈도수 계산 및 비교
  const charCounts = new Map<string, number>();

  // s의 각 문자에 대해 빈도수를 증가시킵니다.
  for (const char of s) {
    charCounts.set(char, (charCounts.get(char) ?? 0) + 1);
  }

  // t의 각 문자에 대해 빈도수를 감소시킵니다.
  // 만약 맵에 해당 문자가 없거나(즉, s에 없는 문자),
  // 이미 0인데 감소시키려 한다면 (즉, t가 s보다 해당 문자를 더 많이 가지고 있다면),
  // 아나그램이 아닙니다.
  for (const char of t) {
    const count = charCounts.get(char) ?? 0; // 해당 문자의 현재 빈도수를 가져옵니다.

    if (count === 0) {
      // s에는 이 문자가 없거나, t가 이미 s에 있는 모든 문자를 소비했습니다.
      return false;
    }

    charCounts.set(char, count - 1); // 빈도수를 1 감소시킵니다.
  }

  // 모든 t의 문자를 성공적으로 처리했다면,
  // 그리고 s와 t의 길이가 같으므로,
  // charCounts 맵의 모든 빈도수는 0이 되어야 합니다.
  // 따라서 추가적인 맵 순회 없이 true를 반환할 수 있습니다.
  return true;
}
```

이 개선된 코드는 시간 복잡도를 `O(N)` (여기서 `N`은 문자열의 길이)로 유지하면서도, 공간 복잡도를 `O(K)` (여기서 `K`는 고유 문자의 개수)로 최적화하고 가독성 및 효율성을 높였습니다. TypeScript의 언어적 특성도 잘 살리고 있습니다.