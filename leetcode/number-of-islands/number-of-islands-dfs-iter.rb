# LeetCode #200 - Number of Islands
# https://leetcode.com/problems/number-of-islands/
# By iterative DFS.

# @param {Character[][]} grid
# @return {Integer}
def num_islands(grid)
  height = grid.size
  width = grid.first.size

  dfs = lambda do |i, j|
    return false if grid[i][j] == '0'

    grid[i][j] = '0'
    stack = [[i, j]]

    until stack.empty?
      i, j = stack.pop

      [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].each do |h, k|
        next unless h.between?(0, height - 1) && k.between?(0, width - 1)
        next if grid[h][k] == '0'

        grid[h][k] = '0'
        stack << [h, k]
      end
    end

    true
  end

  (0...height).sum { |i| (0...width).count { |j| dfs.call(i, j) } }
end
