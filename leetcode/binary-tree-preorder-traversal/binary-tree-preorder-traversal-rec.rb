# LeetCode #144 - Binary Tree Preorder Traversal
# https://leetcode.com/problems/binary-tree-preorder-traversal/
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
def preorder_traversal(root)
  out = []

  dfs = ->(node) do
    return unless node

    out << node.val
    dfs.call(node.left)
    dfs.call(node.right)
  end

  dfs.call(root)
  out
end
