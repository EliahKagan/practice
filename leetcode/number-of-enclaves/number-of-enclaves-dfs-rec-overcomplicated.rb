# LeetCode #1020 - Number of Enclaves
# https://leetcode.com/problems/number-of-enclaves/
# By recursive DFS (excessively complicated version).

# @param {Integer[][]} grid
# @return {Integer}
def num_enclaves(grid)
  height = grid.size
  width = grid.first.size

  dfs = lambda do |i, j|
    return 0 unless i.between?(0, height - 1) && j.between?(0, width - 1)
    return 0 if grid[i][j].zero?

    grid[i][j] = 0

    1 + dfs.call(i, j - 1) + dfs.call(i, j + 1) +
        dfs.call(i - 1, j) + dfs.call(i + 1, j)
  end

  [0, height - 1].each { |i| (0...width).each { |j| dfs.call(i, j) } }
  [0, width - 1].each { |j| 1.upto(height - 2) { |i| dfs.call(i, j) } }

  1.upto(height - 2).sum { |i| 1.upto(width - 2).sum { |j| dfs.call(i, j) } }
end
