# LeetCode 700 - Search in a Binary Search Tree
# https://leetcode.com/problems/search-in-a-binary-search-tree/
# Iterative solution.

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
  while root
    if val < root.val
      root = root.left
    elsif root.val < val
      root = root.right
    elsif root.val == val
      return root
    else
      raise %q("==" not compatible with "<")
    end
  end

  nil
end
