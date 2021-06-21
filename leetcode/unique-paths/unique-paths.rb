# LeetCode #62 - Unique Paths
# https://leetcode.com/problems/unique-paths/
# By iterative bottom-up DP (tabulation)

# @param {Integer} m
# @param {Integer} n
# @return {Integer}
def unique_paths(m, n)
  grid = Array.new(m) { [1] * n }

  (1...m).each do |i|
    (1...n).each do |j|
      grid[i][j] = grid[i - 1][j] + grid[i][j - 1]
    end
  end

  grid[m - 1][n - 1]
end
