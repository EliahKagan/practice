# LeetCode #98 - Validate Binary Search Tree
# https://leetcode.com/problems/validate-binary-search-tree/
# By recursive bounds-propagating preorder traversal.

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
  bounded_bst?(root, -Float::INFINITY, Float::INFINITY)
end

def bounded_bst?(root, low, high)
  return true unless root

  low < root.val && root.val < high &&
      bounded_bst?(root.left, low, root.val) &&
      bounded_bst?(root.right, root.val, high)
end
