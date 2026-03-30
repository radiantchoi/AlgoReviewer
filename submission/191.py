# LeetCode No.191 Number of 1 Bits


class Solution:
    def hammingWeight(self, n: int) -> int:
        return len([x for x in bin(n)[2:] if x == "1"])
