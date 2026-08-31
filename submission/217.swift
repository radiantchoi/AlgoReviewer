// LeetCode No.271 Contains Duplicate

class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var occurences: [Int: Int] = [:]

        for num in nums {
            if let occurence = occurences[num] {
                return true
            } else {
                occurences[num] = 1
            }
        }

        return false
    }
}
