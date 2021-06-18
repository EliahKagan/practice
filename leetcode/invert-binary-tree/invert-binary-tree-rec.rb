# LeetCode #226 - Invert Binary Tree
# https://leetcode.com/problems/invert-binary-tree/
# Recursive solution.

# Definition for a binary tree node.
# class TreeNode
#     attr_accessor :val, :left, :right
#     def initialize(val = 0, left = nil, right = nil)
#         @val = val
#         @left = left
#         @right = right
#     end
# end
# @param {TreeNode} root
# @return {TreeNode}
def invert_tree(root)
  dfs(root)
  root
end

def dfs(root)
  return unless root

  root.left, root.right = root.right, root.left
  dfs(root.left)
  dfs(root.right)

  nil
end
