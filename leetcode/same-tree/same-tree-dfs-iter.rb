# LeetCode #100 - Same Tree
# https://leetcode.com/problems/same-tree/
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
# @param {TreeNode} p
# @param {TreeNode} q
# @return {Boolean}
def is_same_tree(p, q)
  stack = [[p, q]]

  until stack.empty?
    p, q = stack.pop
    next if p.nil? && q.nil?
    return false if p.nil? || q.nil? || p.val != q.val
    stack << [p.left, q.left] << [p.right, q.right]
  end

  true
end
