# LeetCode #329 - Longest Increasing Path in a Matrix
# https://leetcode.com/problems/longest-increasing-path-in-a-matrix/
# By memoized iterative postorder DFS, similar to DFS toposort.

# @param {Integer[][]} matrix
# @return {Integer}
def longest_increasing_path(matrix)
  build_graph(matrix).max_path_length
end

def build_graph(matrix)
  height = matrix.size
  width = matrix.first.size

  neighbors = lambda do |i, j|
    [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].filter do |h, k|
      h.between?(0, height - 1) && k.between?(0, width - 1) &&
          matrix[i][j] < matrix[h][k]
    end
  end

  graph = Graph.new(height * width)

  (0...height).each do |i|
    (0...width).each do |j|
      src = i * width + j
      neighbors.call(i, j).each { |h, k| graph.add_edge(src, h * width + k) }
    end
  end

  graph
end

# A directed graph, represented as an adjacency list.
class Graph
  def initialize(vertex_count)
    @adj = Array.new(vertex_count) { [] }
  end

  def add_edge(src, dest)
    raise 'vertex out of range' unless exists?(src) && exists?(dest)
    @adj[src] << dest
    nil
  end

  def max_path_length
    dp = [nil] * vertex_count

    dfs = lambda do |start|
      return unless dp[start].nil?

      stack = [Frame.new(start)]

      until stack.empty?
        frame = stack.last

        if (dest = @adj[frame.src][frame.index]).nil?
          dp[frame.src] = frame.acc + 1
          stack.pop
        elsif (length = dp[dest]).nil?
          stack << Frame.new(dest)
        else
          frame.acc = length if frame.acc < length
          frame.index += 1
        end
      end
    end

    (0...vertex_count).each(&dfs)
    dp.max
  end

  private

  def vertex_count
    @adj.size
  end

  def exists?(vertex)
    vertex.between?(0, vertex_count - 1)
  end
end

# A stack frame for iteratively implemented recursive implicit-graph DFS.
class Frame
  attr_reader :src
  attr_accessor :index, :acc

  def initialize(src)
    @src = src
    @index = 0
    @acc = 0
  end
end
