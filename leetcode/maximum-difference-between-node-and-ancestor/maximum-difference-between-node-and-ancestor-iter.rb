# LeetCode 1026 - Maximum Difference Between Node and Ancestor
# https://leetcode.com/problems/maximum-difference-between-node-and-ancestor/
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
# @return {Integer}
def max_ancestor_diff(root)
  acc = 0
  stack = [[root, root.val, root.val]]

  until stack.empty?
    root, min, max = stack.pop

    acc = [acc, root.val - min, max - root.val].max
    min = [min, root.val].min
    max = [max, root.val].max
    stack << [root.left, min, max] if root.left
    stack << [root.right, min, max] if root.right
  end

  acc
end
