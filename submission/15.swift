// LeetCode No.15 3Sum
 
class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [[Int: Int]] {
        var occurence: [Int: Int] = [:]
        var result: [[Int: Int]] = []

        for (index, number) in nums.enumerated() {
            if index == 0 { continue }

            let finding = target - number
            
            if let found = occurence[finding] {
                var inserting = [number: 1]
                
                if finding == number {
                    inserting[number] = 2
                } else {
                    inserting[finding] = 1
                }

                result.append(inserting)
            }

            occurence[number] = index
        }

        return result
    }

    func threeSum(_ nums: [Int]) -> [[Int]] {
        var result = Set<Triples>()

        for (index, number) in nums.enumerated() {
            let target = -number

            let candidates = twoSum(Array(nums[index...]), target).map { Triples(candidate: $0, host: number) }

            for candidate in candidates {
                result.insert(candidate)
            }
        }

        return Array(result).map { $0.parsed }
    }
}

struct Triples: Hashable {
    let info: [Int: Int]

    init(candidate: [Int: Int], host: Int) {
        var info = candidate

        if let existance = candidate[host] {
            info[host] = existance + 1
        } else {
            info[host] = 1
        }

        self.info = info
    }

    var parsed: [Int] {
        var result: [Int] = []

        for (key, value) in info {
            for _ in 0..<value {
                result.append(key)
            }
        }

        return result
    }
}
