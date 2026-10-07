# LeetCode No.39 Combination Sum

class Solution:
    def combinationSum(self, candidates: list[int], target: int) -> list[list[int]]:
        result = []

        def traverse(candidates, current, currentSum, currentIndex):
            if currentSum == target:
                result.append(current)
                return
            elif currentSum > target:
                return

            for (index, candidate) in enumerate(candidates):
                if currentIndex > index:
                    continue

                newCurrent = [x for x in current]
                newCurrent.append(candidate)
                newSum = currentSum + candidate

                traverse(candidates, newCurrent, newSum, index)

        traverse(candidates, [], 0, 0)

        return result
