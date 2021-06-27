# LeetCode #797 - All Paths From Source to Target
# https://leetcode.com/problems/all-paths-from-source-to-target/
# Iteratively implemented backtracking solution. The state machine implements
# the same logic as in all-paths-from-source-to-target-rec.rb.

# @param {Integer[][]} graph
# @return {Integer[][]}
def all_paths_source_target(graph)
  raise 'empty graph' if graph.empty?

  all_paths = []
  each_path(graph, 0, graph.size - 1) { |path| all_paths << path }
  all_paths
end

# Yields each path from start to finish in the given graph.
def each_path(graph, start, finish)
  path = []
  vis = [false] * graph.size
  stack = [Frame.new(start)]

  until stack.empty?
    frame = stack.last

    case frame.state
    when :advance
      if vis[frame.src]
        stack.pop
        next
      end

      vis[frame.src] = true
      path << frame.src

      if frame.src == finish
        yield path.dup
        frame.state = :retreat
      else
        frame.state = :explore
      end
    when :explore
      dest = graph[frame.src][frame.index]

      if dest
        frame.index += 1
        stack << Frame.new(dest)
      else
        frame.state = :retreat
      end
    when :retreat
      path.pop
      vis[frame.src] = false
      stack.pop
    else
      raise "unrecognized state: #{frame.state}"
    end
  end
end

# A stack frame for iteratively implemented recursive graph traversal.
class Frame
  attr_reader :src
  attr_accessor :index
  attr_accessor :state

  def initialize(src)
    @src = src
    @index = 0
    @state = :advance
  end
end
