# LeetCode #802 - Find Eventual Safe States
# https://leetcode.com/problems/find-eventual-safe-states/
# By Kahn's algorithm (implemented recursively) on the transpose graph.

# @param {Integer[][]} graph
# @return {Integer[]}
def eventual_safe_nodes(graph)
  indegrees = graph.map(&:size)
  graph = transpose_graph(graph)

  dfs = lambda do |src|
    graph[src].each do |dest|
      dfs.call(dest) if (indegrees[dest] -= 1).zero?
    end
  end

  indegrees.indices(&:zero?).each(&dfs)
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
