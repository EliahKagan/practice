# LeetCode #1905 - Count Sub Islands
# https://leetcode.com/problems/count-sub-islands/
# By iterative DFS.

# @param {Integer[][]} grid1
# @param {Integer[][]} grid2
# @return {Integer}
def count_sub_islands(grid1, grid2)
  height, width = dimensions(grid1)
  raise 'different dimensions' if [height, width] != dimensions(grid2)

  land_at = lambda do |i, j|
    i.between?(0, height - 1) && j.between?(0, width - 1) && grid2[i][j] != 0
  end

  subisland = lambda do |i, j|
    return false unless land_at.call(i, j)

    grid2[i][j] = 0
    ret = true
    stack = [[i, j]]

    until stack.empty?
      i, j = stack.pop
      ret = false if grid1[i][j].zero?

      each_neighbor(i, j) do |h, k|
        next unless land_at.call(h, k)

        grid2[h][k] = 0
        stack << [h, k]
      end
    end

    ret
  end

  (0...height).sum { |i| (0...width).count { |j| subisland.call(i, j) } }
end

def dimensions(grid)
  height = grid.size
  return [0, 0] if height.zero?

  width = grid.first.size
  raise 'jagged grid' unless grid.all? { |row| row.size == width }

  [height, width]
end

def each_neighbor(i, j)
  yield i, j - 1
  yield i, j + 1
  yield i - 1, j
  yield i + 1, j
end
