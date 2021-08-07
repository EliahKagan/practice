# LeetCode #200 - Number of Islands
# https://leetcode.com/problems/number-of-islands/
# By recursive DFS.

# @param {Character[][]} grid
# @return {Integer}
def num_islands(grid)
  height = grid.size
  width = grid.first.size

  dfs = lambda do |i, j|
    return false unless i.between?(0, height - 1) && j.between?(0, width - 1)
    return false if grid[i][j] == '0'

    grid[i][j] = '0'

    dfs.call(i, j - 1)
    dfs.call(i, j + 1)
    dfs.call(i - 1, j)
    dfs.call(i + 1, j)

    true
  end

  (0...height).sum { |i| (0...width).count { |j| dfs.call(i, j) } }
end
