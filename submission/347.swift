// LeetCode No.347 Top K Frequent Elements

class Solution {
    func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
        var occurences: [Int: Int] = [:]

        for num in nums {
            if let occurence = occurences[num] {
                occurences[num] = occurence + 1
            } else {
                occurences[num] = 1
            }
        }

        var result = occurences.keys.sorted { occurences[$0]! < occurences[$1]! }

        var answer: [Int] = []
        var k = k

        while k > 0 {
            answer.append(result.removeLast())
            k -= 1
        }

        return answer
    }
}
