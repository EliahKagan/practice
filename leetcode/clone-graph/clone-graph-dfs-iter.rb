# LeetCode #133 - Clone Graph
# https://leetcode.com/problems/clone-graph/
# By iterative DFS. Does not rely on any node-value constraints.

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

  copies = {node => Node.new(node.val)}
  stack = [node]

  until stack.empty?
    src = stack.pop
    src_copy = copies[src]

    src.neighbors.each do |dest|
      dest_copy = copies[dest]

      unless dest_copy
        copies[dest] = dest_copy = Node.new(dest.val)
        stack << dest
      end

      src_copy.neighbors << dest_copy
    end
  end

  copies[node]
end
