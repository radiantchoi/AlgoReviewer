# LeetCode No.125 Valid Palindrome

class Solution:
    def isPalindrome(self, s: str) -> bool:
        letters = list(filter(lambda x: x.isalnum(), s.lower()))

        left = 0
        right = len(letters) - 1

        while left <= right:
            if letters[left] != letters[right]:
                return False

            left += 1
            right -= 1

        return True
