// LeetCode No.242 Valid Anagram

function isAnagram(s: string, t: string): boolean {
  let so = new Map<string, number>();
  let to = new Map<string, number>();

  for (const letter of s) {
    const existing = so.get(letter) ?? 0;
    so.set(letter, existing + 1);
  }

  for (const letter of t) {
    const existing = to.get(letter) ?? 0;
    to.set(letter, existing + 1);
  }

  for (const pair of so) {
    const letter = pair[0];

    if (so.get(letter) !== to.get(letter)) {
      return false;
    }
  }

  for (const pair of to) {
    const letter = pair[0];

    if (so.get(letter) !== to.get(letter)) {
      return false;
    }
  }

  return true;
}
