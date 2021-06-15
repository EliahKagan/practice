# LeetCode #437 - Path Sum III
# https://leetcode.com/problems/path-sum-iii/
# Prefix-sum hashing solution. Runs in linear time.

# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    @staticmethod
    def pathSum(root: TreeNode, targetSum: int) -> int:
        history = collections.Counter((0,))

        def dfs(node, acc):
            if not node:
                return 0

            acc += node.val
            count = history[acc - targetSum]

            history[acc] += 1
            count += dfs(node.left, acc)
            count += dfs(node.right, acc)
            history[acc] -= 1

            return count

        return dfs(root, 0)
