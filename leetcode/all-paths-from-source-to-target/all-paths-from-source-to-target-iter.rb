# LeetCode #797 - All Paths From Source to Target
# https://leetcode.com/problems/all-paths-from-source-to-target/
# Iteratively implemented backtracking solution.

# @param {Integer[][]} graph
# @return {Integer[][]}
def all_paths_source_target(graph)
  case graph.size
  when 0
    raise 'empty graph'
  when 1
    [[0]]
  else
    all_paths = []
    each_path(graph, 0, graph.size - 1) { |path| all_paths << path }
    all_paths
  end
end

# Yields each path from start to finish in the given graph.
def each_path(graph, start, finish)
  vis = [false] * graph.size
  vis[start] = true
  path = [start]
  stack = [Frame.new(graph, start)]

  until stack.empty?
    dest = stack.last.next_dest

    unless dest
      vis[stack.last.src] = false
      path.pop
      stack.pop
      next
    end

    next if vis[dest]

    path << dest

    if dest == finish
      yield path.dup
      path.pop
    else
      vis[dest] = true
      stack << Frame.new(graph, dest)
    end
  end
end

# A stack frame for iteratively implemented recursive graph traversal.
class Frame
  attr_reader :src

  def initialize(graph, src)
    @src = src
    @row = graph[src]
    @index = 0
  end

  def next_dest
    dest = @row[@index]
    @index += 1
    dest
  end
end
