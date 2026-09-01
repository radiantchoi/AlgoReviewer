// LeetCode No.217 Contains Duplicate

class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var occured = Set<Int>()

        for num in nums {
            if occured.contains(num) { return true }

            occured.insert(num)
        }

        return false
    }
}
