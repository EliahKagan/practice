# LeetCode #98 - Validate Binary Search Tree
# https://leetcode.com/problems/validate-binary-search-tree/
# By iterative bounds-propagating preorder traversal.

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
# @return {Boolean}
def is_valid_bst(root)
  stack = []
  stack << [root, -Float::INFINITY, Float::INFINITY] if root

  until stack.empty?
    root, low, high = stack.pop
    return false unless low < root.val && root.val < high

    stack << [root.left, low, root.val] if root.left
    stack << [root.right, root.val, high] if root.right
  end

  true
end
