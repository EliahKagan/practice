# LeetCde #1254 - Number of Closed Islands
# https://leetcode.com/problems/number-of-closed-islands/
# By recursive DFS.

# @param {Integer[][]} grid
# @return {Integer}
def closed_island(grid)
  height = grid.size
  width = grid.first.size

  dfs = lambda do |i, j|
    return false unless i.between?(0, height - 1) && j.between?(0, width - 1)

    return true unless grid[i][j].zero?

    grid[i][j] = 1

    dfs.call(i, j - 1) & dfs.call(i, j + 1) &
        dfs.call(i - 1, j) & dfs.call(i + 1, j)
  end

  (0...height).sum do |i|
    (0...width).count { |j| grid[i][j].zero? && dfs.call(i, j) }
  end
end
