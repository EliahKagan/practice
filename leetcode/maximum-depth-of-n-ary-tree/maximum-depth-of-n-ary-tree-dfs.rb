# LeetCode 559 - Maximum Depth of N-ary Tree
# https://leetcode.com/problems/maximum-depth-of-n-ary-tree/
# By recursive DFS.

# Definition for a Node.
# class Node
#     attr_accessor :val, :children
#     def initialize(val)
#         @val = val
#         @children = []
#     end
# end

# @param {Node} root
# @return {int}
def maxDepth(root)
  return 0 unless root

  dfs = ->(node) { 1 + (node.children.map(&dfs).max || 0) }
  dfs.call(root)
end
