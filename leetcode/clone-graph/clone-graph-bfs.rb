# LeetCode #133 - Clone Graph
# https://leetcode.com/problems/clone-graph/
# By BFS. Does not rely on any node-value constraints.

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
  queue = [node]

  until queue.empty?
    src = queue.shift
    src_copy = copies[src]

    src.neighbors.each do |dest|
      dest_copy = copies[dest]

      unless dest_copy
        copies[dest] = dest_copy = Node.new(dest.val)
        queue << dest
      end

      src_copy.neighbors << dest_copy
    end
  end

  copies[node]
end
