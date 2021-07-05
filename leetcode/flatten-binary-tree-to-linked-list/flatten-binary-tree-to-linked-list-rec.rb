# LeetCode #114 - Flatten Binary Tree to Linked List
# https://leetcode.com/problems/flatten-binary-tree-to-linked-list/
# Recursive preorder traversal, single chain, appending nodes to the end.

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

  dfs = lambda do |node|
    return unless node

    left = node.left
    right = node.right

    node.left = nil
    parent = parent.right = node

    dfs.call(left)
    dfs.call(right)
  end

  dfs.call(root)
  parent.right = nil
  sentinel.right
end
