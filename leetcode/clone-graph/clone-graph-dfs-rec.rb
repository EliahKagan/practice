# LeetCode #133 - Clone Graph
# https://leetcode.com/problems/clone-graph/
# By recursive DFS. Does not rely on any node-value constraints.

# Definition for a Node.
# class Node
#     attr_accessor :val, :neighbors
#     def initialize(val = 0, neighbors = nil)
#		  @val = val
#		  neighbors = [] if neighbors.nil?
#         @neighbors = neighbors
#     end
# end

# @param {Node} node
# @return {Node}
def cloneGraph(node)
  return nil unless node

  copies = {}

  dfs = lambda do |src|
    src_copy = copies[src]
    return src_copy if src_copy

    copies[src] = src_copy = Node.new(src.val)
    src.neighbors.each { |dest| src_copy.neighbors << dfs.call(dest) }
    src_copy
  end

  dfs.call(node)
end
