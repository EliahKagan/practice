# LeetCode 1026 - Maximum Difference Between Node and Ancestor
# https://leetcode.com/problems/maximum-difference-between-node-and-ancestor/
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
# @return {Integer}
def max_ancestor_diff(root)
  acc = 0

  dfs = lambda do |node, min, max|
    return unless node

    acc = [acc, node.val - min, max - node.val].max
    min = [min, node.val].min
    max = [max, node.val].max
    dfs.call(node.left, min, max)
    dfs.call(node.right, min, max)
  end

  dfs.call(root, root.val, root.val)
  acc
end
