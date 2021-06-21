# LeetCode #63 - Unique Paths II
# https://leetcode.com/problems/unique-paths-ii/
# By recursive top-down DP (memoization)

# @param {Integer[][]} obstacle_grid
# @return {Integer}
def unique_paths_with_obstacles(obstacle_grid)
  height = obstacle_grid.size
  width = obstacle_grid.first.size
  dp = Array.new(height) { [nil] * width }

  solve = lambda do |i, j|
    return 0 unless obstacle_grid[i][j].zero?

    dp[i][j] ||=
      if i.zero? && j.zero?
        1
      elsif i.zero?
        solve.call(0, j - 1)
      elsif j.zero?
        solve.call(i - 1, 0)
      else
        solve.call(i - 1, j) + solve.call(i, j - 1)
      end
  end

  solve.call(height - 1, width - 1)
end
