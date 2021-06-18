# LeetCode 559 - Maximum Depth of N-ary Tree
# https://leetcode.com/problems/maximum-depth-of-n-ary-tree/
# By BFS.

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
  depth = 0
  queue = []
  queue << root if root

  until queue.empty?
    depth += 1
    queue.size.times { queue.concat(queue.shift.children) }
  end

  depth
end
