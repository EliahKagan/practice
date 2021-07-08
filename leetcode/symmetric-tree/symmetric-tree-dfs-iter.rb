# LeetCode #101 - Symmetric Tree
# https://leetcode.com/problems/symmetric-tree/
# By iterative DFS.

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
  stack = [[left, right]]

  until stack.empty?
    left, right = stack.pop
    next if left.nil? && right.nil?
    return false if left.nil? || right.nil? || left.val != right.val
    stack << [left.left, right.right] << [left.right, right.left]
  end

  true
end
