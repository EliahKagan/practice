# LeetCode #329 - Longest Increasing Path in a Matrix
# https://leetcode.com/problems/longest-increasing-path-in-a-matrix/
# By Kahn's algorithm (with a stack), marking lengths.

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
    @indegrees = [0] * vertex_count
  end

  def add_edge(src, dest)
    raise 'vertex out of range' unless exists?(src) && exists?(dest)
    @adj[src] << dest
    @indegrees[dest] += 1
    nil
  end

  def max_path_length
    lengths = [1] * vertex_count
    indegs = @indegrees.dup
    roots = (0...vertex_count).filter { |i| indegs[i].zero? }

    until roots.empty?
      src = roots.pop
      cur = lengths[src]

      @adj[src].each do |dest|
        lengths[dest] = cur + 1 if lengths[dest] <= cur
        roots << dest if (indegs[dest] -= 1).zero?
      end
    end

    lengths.max
  end

  private

  def vertex_count
    @adj.size
  end

  def exists?(vertex)
    vertex.between?(0, vertex_count - 1)
  end
end
