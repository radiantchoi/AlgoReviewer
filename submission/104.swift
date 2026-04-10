// LeetCode No.104 Maximum Depth of Binary Tree

// Definition for a binary tree node.
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

class Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        var depth = 0

        traverse(&depth, 0, root)

        return depth
    }

    func traverse(_ result: inout Int, _ currentDepth: Int, _ root: TreeNode?) {
        guard let root else {
            result = max(result, currentDepth)
            return
        }

        traverse(&result, currentDepth + 1, root.left)
        traverse(&result, currentDepth + 1, root.right)
    }

    func maxDepth2(_ root: TreeNode?) -> Int {
        guard let root else { return 0 }

        let maxLeft = maxDepth2(root.left)
        let maxRight = maxDepth2(root.right)

        return max(maxLeft, maxRight) + 1
    }
}
