# LeetCode #226 - Invert Binary Tree
# https://leetcode.com/problems/invert-binary-tree/
# Iterative solution.

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
  stack = []
  stack << root if root

  until stack.empty?
    node = stack.pop
    node.left, node.right = node.right, node.left
    stack << node.left if node.left
    stack << node.right if node.right
  end

  root
end
