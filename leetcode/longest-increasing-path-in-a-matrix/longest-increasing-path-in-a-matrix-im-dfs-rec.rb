# LeetCode #329 - Longest Increasing Path in a Matrix
# https://leetcode.com/problems/longest-increasing-path-in-a-matrix/
# By memoized recursive implicit-graph postorder DFS, similar to DFS toposort.

# @param {Integer[][]} matrix
# @return {Integer}
def longest_increasing_path(matrix)
  height = matrix.size
  width = matrix.first.size

  neighbors = lambda do |i, j|
    [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].filter do |h, k|
      h.between?(0, height - 1) && k.between?(0, width - 1) &&
          matrix[i][j] < matrix[h][k]
    end
  end

  dp = Array.new(height) { [nil] * width } # maximum forward path lengths

  dfs = lambda do |i, j|
    dp[i][j] ||=
      (neighbors.call(i, j).map { |h, k| dfs.call(h, k) }.max || 0) + 1
  end

  (0...height).each { |i| (0...width).each { |j| dfs.call(i, j) } }
  dp.map(&:max).max
end
