# LeetCode #144 - Binary Tree Preorder Traversal
# https://leetcode.com/problems/binary-tree-preorder-traversal/
# Simple iterative solution with a node stack.

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
  stack = []
  stack << root if root

  until stack.empty?
    node = stack.pop
    out << node.val
    stack << node.right if node.right
    stack << node.left if node.left
  end

  out
end
