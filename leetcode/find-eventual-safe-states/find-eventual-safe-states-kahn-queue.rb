# LeetCode #802 - Find Eventual Safe States
# https://leetcode.com/problems/find-eventual-safe-states/
# By Kahn's algorithm with a queue.

# @param {Integer[][]} graph
# @return {Integer[]}
def eventual_safe_nodes(graph)
  indegrees = compute_indegrees(graph)
  roots = indegrees.indices(&:zero?)

  until roots.empty?
    graph[roots.shift].each do |dest|
      roots << dest if (indegrees[dest] -= 1).zero?
    end
  end

  indegrees.indices(&:zero?)
end

def compute_indegrees(graph)
  indegrees = [0] * graph.size
  graph.each { |row| row.each { |dest| indegrees[dest] += 1 } }
  indegrees
end

# Convenicence extensions for arrays.
class Array
  def indices
    ret = []
    each_with_index { |elem, index| ret << index if yield elem }
    ret
  end
end
