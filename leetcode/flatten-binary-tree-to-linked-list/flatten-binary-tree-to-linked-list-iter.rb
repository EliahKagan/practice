# LeetCode #114 - Flatten Binary Tree to Linked List
# https://leetcode.com/problems/flatten-binary-tree-to-linked-list/
# Iterative preorder traversal, single chain, appending nodes to the end.

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
# @return {Void} Do not return anything, modify root in-place instead.
def flatten(root)
  parent = sentinel = TreeNode.new
  stack = []
  stack << root if root

  until stack.empty?
    root = stack.pop

    stack << root.right if root.right
    stack << root.left if root.left

    root.left = nil
    parent = parent.right = root
  end

  parent.right = nil
  sentinel.right
end
