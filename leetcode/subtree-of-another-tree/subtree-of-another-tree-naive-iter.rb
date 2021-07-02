# LeetCode #572 - Subtree of Another Tree
# https://leetcode.com/problems/subtree-of-another-tree/
# Naive solution, quadratic O(MN) runtime, implemented iteratively.

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
  return true unless sub_root

  stack = [root]

  until stack.empty?
    root = stack.pop
    next unless root
    return true if equal_trees?(root, sub_root)
    stack << root.left << root.right
  end

  false
end

def equal_trees?(root1, root2)
  stack = [[root1, root2]]

  until stack.empty?
    root1, root2 = stack.pop
    next unless root1 || root2
    return false unless root1 && root2 && root1.val == root2.val
    stack << [root1.left, root2.left] << [root1.right, root2.right]
  end

  true
end
