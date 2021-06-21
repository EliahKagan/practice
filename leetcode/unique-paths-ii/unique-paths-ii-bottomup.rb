# LeetCode #63 - Unique Paths II
# https://leetcode.com/problems/unique-paths-ii/
# By iterative bottom-up DP (tabulation)

# @param {Integer[][]} obstacle_grid
# @return {Integer}
def unique_paths_with_obstacles(obstacle_grid)
  height = obstacle_grid.size
  width = obstacle_grid.first.size
  dp = Array.new(height) { [0] * width }

  dp[0][0] = 1 if obstacle_grid[0][0].zero?

  (1...width).each do |j|
    dp[0][j] = dp[0][j - 1] if obstacle_grid[0][j].zero?
  end

  (1...height).each do |i|
    dp[i][0] = dp[i - 1][0] if obstacle_grid[i][0].zero?
  end

  (1...height).each do |i|
    (1...width).each do |j|
      dp[i][j] = dp[i - 1][j] + dp[i][j - 1] if obstacle_grid[i][j].zero?
    end
  end

  dp[-1][-1]
end
