// LeetCode No.2784 Check if Array is Good

class Solution {
    func isGood(_ nums: [Int]) -> Bool {
        var occurences: [Int: Int] = [:]

        for num in nums {
            if let occurence = occurences[num] {
                occurences[num] = occurence + 1
            } else {
                occurences[num] = 1
            }
        }

        let threshold = nums.count - 1
        var number = 1

        while number < threshold {
            guard let occurence = occurences[number], occurence == 1 else {
                return false
            }

            number += 1
        }

        guard let occurence = occurences[number], occurence == 2 else {
            return false
        }

        return true
    }
}
