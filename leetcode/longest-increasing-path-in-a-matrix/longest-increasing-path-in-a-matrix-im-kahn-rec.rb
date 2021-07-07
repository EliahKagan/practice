# LeetCode #329 - Longest Increasing Path in a Matrix
# https://leetcode.com/problems/longest-increasing-path-in-a-matrix/
# By Kahn's algorithm (recursive) on an implicit graph, marking lengths.

# @param {Integer[][]} matrix
# @return {Integer}
def longest_increasing_path(matrix)
  GridGraph.new(matrix).max_path_length
end

# An implicit digraph view of a grid with four-way adjacency subject to the
# requirement that the source value must be less than the destination value.
class GridGraph
  def initialize(grid)
    @grid = grid
    @height = grid.size
    @width = grid.first.size
  end

  # Computes the maximum path length in vertices. Assumes no cycles.
  def max_path_length
    lengths = Array.new(@height) { [1] * @width }
    indegrees = compute_indegrees

    dfs = lambda do |i, j|
      cur = lengths[i][j]

      each_neighbor(i, j) do |h, k|
        lengths[h][k] = cur + 1 if lengths[h][k] <= cur
        dfs.call(h, k) if (indegrees[h][k] -= 1).zero?
      end
    end

    roots_from_indegrees(indegrees).each { |i, j| dfs.call(i, j) }
    lengths.map(&:max).max
  end

  private

  def each_vertex
    (0...@height).each { |i| (0...@width).each { |j| yield i, j } }
  end

  def each_neighbor(i, j)
    value = @grid[i][j]

    yield i, j - 1 if j != 0 && value < @grid[i][j - 1]
    yield i, j + 1 if j + 1 != @width && value < @grid[i][j + 1]
    yield i - 1, j if i != 0 && value < @grid[i - 1][j]
    yield i + 1, j if i + 1 != @height && value < @grid[i + 1][j]
  end

  def compute_indegrees
    indegrees = Array.new(@height) { [0] * @width }
    each_vertex { |i, j| each_neighbor(i, j) { |h, k| indegrees[h][k] += 1 } }
    indegrees
  end

  def roots_from_indegrees(indegrees)
    roots = []
    each_vertex { |i, j| roots << [i, j] if indegrees[i][j].zero? }
    roots
  end
end
