// LeetCode No.217 Contains Duplicate

function containsDuplicate(nums: number[]): boolean {
  let occured = new Map<number, boolean>();

  for (const num of nums) {
    const alreadyExists = occured.get(num) ?? false;

    if (alreadyExists) {
      return true;
    } else {
      occured.set(num, true);
    }
  }

  return false;
}
