# https://leetcode.com/problems/find-a-corresponding-node-of-a-binary-tree-in-a-clone-of-that-tree

# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

def _dfs(root1: TreeNode, root2: TreeNode, target1: TreeNode) -> TreeNode:
    if root1 is None:
        return None

    if root1 is target1:
        return root2

    return (_dfs(root1.left, root2.left, target1)
            or _dfs(root1.right, root2.right, target1))


class Solution:
    def getTargetCopy(self,
                      original: TreeNode,
                      cloned: TreeNode,
                      target: TreeNode) -> TreeNode:
        return _dfs(original, cloned, target)
