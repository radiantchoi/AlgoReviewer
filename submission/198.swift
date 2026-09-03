// LeetCode No.198 House Robber

class Solution {
    func rob(_ nums: [Int]) -> Int {
        guard nums.count > 1 else {
            return nums[0]
        }

        var nums = nums

        if nums.count > 2 {
            nums[1] = max(nums[0], nums[1])

            for i in 2..<nums.count {
                nums[i] = max(nums[i - 1], nums[i] + nums[i - 2])
            }
        }

        return max(nums[nums.count - 1], nums[nums.count - 2])
    }
}
