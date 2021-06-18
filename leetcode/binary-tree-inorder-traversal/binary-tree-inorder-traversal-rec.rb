# LeetCode #94 - Binary Tree Inorder Traversal
# https://leetcode.com/problems/binary-tree-inorder-traversal/
# Simple recursive solution.

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
# @return {Integer[]}
def inorder_traversal(root)
  out = []

  dfs = ->(node) do
    return unless node

    dfs.call(node.left)
    out << node.val
    dfs.call(node.right)
  end

  dfs.call(root)
  out
end
