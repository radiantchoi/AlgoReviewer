# LeetCode No.98 Validate Binary Seacrh Tree

# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    # In LeetCode Environment, it is marked as Optional[TreeNode]. Substituted to TreeNode | None
    def isValidBST(self, root: TreeNode | None) -> bool:
        criteria = 2**31
        return self.isValidNode(root, -(criteria + 1), criteria)

    def isValidNode(self, root: TreeNode | None, minimum: int, maximum: int) -> bool:
        if root is None:
            return True
        elif root.val <= minimum or root.val >= maximum:
            return False

        return self.isValidNode(root.left, minimum, root.val) and self.isValidNode(
            root.right, root.val, maximum
        )
