# LeetCode #1020 - Number of Enclaves
# https://leetcode.com/problems/number-of-enclaves/
# By BFS.

# @param {Integer[][]} grid
# @return {Integer}
def num_enclaves(grid)
  height = grid.size
  width = grid.first.size

  bfs = lambda do |i, j|
    queue = [[i, j]]

    until queue.empty?
      i, j = queue.shift

      next unless i.between?(0, height - 1) && j.between?(0, width - 1)
      next if grid[i][j].zero?

      grid[i][j] = 0
      queue << [i, j - 1] << [i, j + 1] << [i - 1, j] << [i + 1, j]
    end
  end

  [0, height - 1].each { |i| (0...width).each { |j| bfs.call(i, j) } }
  [0, width - 1].each { |j| 1.upto(height - 2) { |i| bfs.call(i, j) } }

  grid.sum(&:sum)
end
