# LeetCode #100 - Same Tree
# https://leetcode.com/problems/same-tree/
# By BFS.

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
  queue = [[p, q]]

  until queue.empty?
    p, q = queue.shift
    next if p.nil? && q.nil?
    return false if p.nil? || q.nil? || p.val != q.val
    queue << [p.left, q.left] << [p.right, q.right]
  end

  true
end
