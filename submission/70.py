# LeetCode No.70 Climbing Stairs

class Solution:
    def climbStairs(self, n: int) -> int:
        stairs = [0, 1, 2]

        current = 2
        while current < n:
            stairs.append(stairs[current] + stairs[current - 1])
            current += 1
        
        return stairs[n]