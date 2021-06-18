# LeetCode 700 - Search in a Binary Search Tree
# https://leetcode.com/problems/search-in-a-binary-search-tree/
# Recursive solution.

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
# @param {Integer} val
# @return {TreeNode}
def search_bst(root, val)
  return nil unless root

  if val < root.val
    search_bst(root.left, val)
  elsif root.val < val
    search_bst(root.right, val)
  elsif root.val == val
    root
  else
    raise %q("==" not compatible with "<")
  end
end
