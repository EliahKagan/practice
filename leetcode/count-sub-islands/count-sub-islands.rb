# LeetCode #1905 - Count Sub Islands
# https://leetcode.com/problems/count-sub-islands/
# By recursive DFS.

# @param {Integer[][]} grid1
# @param {Integer[][]} grid2
# @return {Integer}
def count_sub_islands(grid1, grid2)
  height, width = dimensions(grid1)
  raise 'different dimensions' if [height, width] != dimensions(grid2)

  exists = ->(i, j) { i.between?(0, height - 1) && j.between?(0, width - 1) }

  maybe_subisland = lambda do |i, j|
    # We might have just reached the edge of a subisland.
    return true unless exists.call(i, j) && grid2[i][j] != 0

    grid2[i][j] = 0

    # Check and recurse, but don't short-circuit, so the fill is completed.
    (grid1[i][j] != 0) &
        maybe_subisland.call(i, j - 1) &
        maybe_subisland.call(i, j + 1) &
        maybe_subisland.call(i - 1, j) &
        maybe_subisland.call(i + 1, j)
  end

  (0...height).sum do |i|
    (0...width).count do |j|
      found = grid2[i][j] != 0 && maybe_subisland.call(i, j)
      puts "(#{i}, #{j})" if found
      found
    end
  end
end

def dimensions(grid)
  height = grid.size
  return [0, 0] if height.zero?

  width = grid.first.size
  raise 'jagged grid' unless grid.all? { |row| row.size == width }

  [height, width]
end
