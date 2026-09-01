// LeetCode No.1 Two Sum

class Solution {
    // previous try - O(nlogn)
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        let pairs = nums.enumerated().sorted { $0.element < $1.element }

        for i in 0..<pairs.count - 1 {
            var left = i + 1
            var right = pairs.count - 1
            let searching = target - pairs[i].element

            while left <= right {
                let mid = (left + right) / 2

                if pairs[mid].element == searching {
                    return [pairs[i].offset, pairs[mid].offset]
                } else if pairs[mid].element < searching {
                    left = mid + 1
                } else {
                    right = mid - 1
                }
            }
        }

        return []
    }

    // second try - based on correct approach
    func twoSum2(_ nums: [Int], _ target: Int) -> [Int] {
        var pool: [Int: Int] = [:]

        for (offset, number) in nums.enumerated() {
            let searching = target - number

            if let candidate = pool[searching] {
                return [offset, candidate]
            }

            pool[number] = offset
        }

        return []
    }

    // try after a while - two pointer O(nlogn)
    func twoSum3(_ nums: [Int], _ target: Int) -> [Int] {
        let pairs = nums.enumerated().sorted { $0.element < $1.element }

        var left = 0
        var right = pairs.count - 1

        while left < right {
            let current = pairs[left].element + pairs[right].element

            if current == target {
                return [pairs[left].offset, pairs[right].offset]
            } else if current < target {
                left += 1
            } else {
                right -= 1
            }
        }

        return []
    }
}
