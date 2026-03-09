# LeetCode No.128 Longest Consecutive Sequence

from typing import List

class Solution:
    def longestConsecutive(self, nums: List[int]) -> int:
        nums_set = set(nums)
        result = 0

        for num in nums_set:
            if (num - 1) not in nums_set:
                current = num
                length = 0

                while current in nums_set:
                    length += 1
                    current += 1
                
                result = max(result, length)

        return result
