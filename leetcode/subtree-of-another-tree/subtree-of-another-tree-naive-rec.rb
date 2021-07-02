# LeetCode #572 - Subtree of Another Tree
# https://leetcode.com/problems/subtree-of-another-tree/
# Naive solution, quadratic O(MN) runtime, implemented reursively.

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
# @param {TreeNode} sub_root
# @return {Boolean}
def is_subtree(root, sub_root)
  return true if equal_trees?(root, sub_root)

  return false if root.nil?

  is_subtree(root.left, sub_root) || is_subtree(root.right, sub_root)
end

def equal_trees?(root1, root2)
  return root1.nil? && root2.nil? if root1.nil? || root2.nil?

  root1.val == root2.val &&
      equal_trees?(root1.left, root2.left) &&
      equal_trees?(root1.right, root2.right)
end
