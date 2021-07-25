# LeetCde #1254 - Number of Closed Islands
# https://leetcode.com/problems/number-of-closed-islands/
# By iterative DFS.

# @param {Integer[][]} grid
# @return {Integer}
def closed_island(grid)
  height = grid.size
  width = grid.first.size

  dfs = lambda do |i, j|
    closed = true
    stack = [[i, j]]

    until stack.empty?
      i, j = stack.pop

      unless i.between?(0, height - 1) && j.between?(0, width - 1)
        closed = false
        next
      end

      next unless grid[i][j].zero?

      grid[i][j] = 1
      stack << [i, j - 1] << [i, j + 1] << [i - 1, j] << [i + 1, j]
    end

    closed
  end

  (0...height).sum do |i|
    (0...width).count { |j| grid[i][j].zero? && dfs.call(i, j) }
  end
end
