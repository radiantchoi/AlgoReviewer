// LeetCode No.217 Contains Duplicate

class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var occured: [Int: Bool] = [:]

        for num in nums {
            if let isOccured = occured[num] {
                return true
            } else {
                occured[num] = true
            }
        }

        return false
    }
}
