# LeetCode #145 - Binary Tree Postorder Traversal
# https://leetcode.com/problems/binary-tree-postorder-traversal/
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
def postorder_traversal(root)
  out = []

  dfs = ->(node) do
    return unless node

    dfs.call(node.left)
    dfs.call(node.right)
    out << node.val
  end

  dfs.call(root)
  out
end
