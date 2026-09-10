# LeetCode No.98 Validate Binary Seacrh Tree

# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    # In LeetCode Environment, it is marked as Optional[TreeNode]. Substituted to TreeNode | None
    def isValid(self, root: TreeNode | None, low: int, high: int) -> bool:
        if not root:
            return True
        
        if not (low < root.val < high):
            return False
        
        return self.isValid(root.left, low, root.val) and self.isValid(root.right, root.val, high)

    def isValidBST(self, root: TreeNode | None) -> bool:
        return self.isValid(root, -2 ** 31 - 1, 2 ** 31)