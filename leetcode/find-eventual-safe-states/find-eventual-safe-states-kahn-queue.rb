# LeetCode #802 - Find Eventual Safe States
# https://leetcode.com/problems/find-eventual-safe-states/
# By Kahn's algorithm (with a queue) on the transpose graph.

# @param {Integer[][]} graph
# @return {Integer[]}
def eventual_safe_nodes(graph)
  indegrees = graph.map(&:size)
  graph = transpose_graph(graph)
  roots = indegrees.indices(&:zero?)

  until roots.empty?
    graph[roots.shift].each do |dest|
      roots << dest if (indegrees[dest] -= 1).zero?
    end
  end

  indegrees.indices(&:zero?)
end

def transpose_graph(graph)
  tr_graph = Array.new(graph.size) { [] }

  graph.each_with_index do |row, src|
    row.each { |dest| tr_graph[dest] << src }
  end

  tr_graph
end

# Convenicence extensions for arrays.
class Array
  def indices
    ret = []
    each_with_index { |elem, index| ret << index if yield elem }
    ret
  end
end
