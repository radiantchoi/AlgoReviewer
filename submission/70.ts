// LeetCode No.70 Climbing Stairs

function climbStairs(n: number): number {
  let steps = [1, 1, 2];

  while (steps.length <= n) {
    let first = steps[steps.length - 1];
    let second = steps[steps.length - 2];

    steps.push(first + second);
  }

  return steps[n];
}
