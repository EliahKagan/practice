# LeetCode #101 - Symmetric Tree
# https://leetcode.com/problems/symmetric-tree/
# By recursive DFS.

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
def is_symmetric(root)
  root.nil? || mirror?(root.left, root.right)
end

def mirror?(left, right)
  return left.nil? && right.nil? if left.nil? || right.nil?

  left.val == right.val &&
      mirror?(left.left, right.right) &&
      mirror?(left.right, right.left)
end
