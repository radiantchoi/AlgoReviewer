# LeetCode No.238 Product of Array Except Self

from typing import List

class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        product = 1
        zeroes = 0

        for num in nums:
            if num != 0:
                product *= num
            else:
                zeroes += 1

        if zeroes > 1:
            return [0] * len(nums)
        
        result = []

        for num in nums:
            if not zeroes:
                result.append(product // num)
            else:
                if num == 0:
                    result.append(product)
                else:
                    result.append(0)
        
        return result