# LeetCode #145 - Binary Tree Postorder Traversal
# https://leetcode.com/problems/binary-tree-postorder-traversal/
# Iterative solution by reversing right-to-left preorder.

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
  stack = []
  stack << root if root

  until stack.empty?
    node = stack.pop
    out << node.val
    stack << node.left if node.left
    stack << node.right if node.right
  end

  out.reverse!
end
