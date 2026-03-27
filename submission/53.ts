// LeetCode No.53 Maximum Subarray

function maxSubArray(nums: number[]): number {
  let current = nums[0];
  let maximum = nums[0];

  if (nums.length > 1) {
    for (let i = 1; i < nums.length; i++) {
      current = Math.max(current + nums[i], nums[i]);
      maximum = Math.max(current, maximum);
    }
  }

  return maximum;
}
