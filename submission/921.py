# LeetCode No.921 Minimum Add to Make Parentheses Valid

class Solution:
    def minAddToMakeValid(self, s: str) -> int:
        stack = []

        for letter in s:
            if letter == "(":
                stack.append(letter)
            else:
                if stack and stack[-1] == "(":
                    stack.pop()
                else:
                    stack.append(letter)

        return len(stack)
