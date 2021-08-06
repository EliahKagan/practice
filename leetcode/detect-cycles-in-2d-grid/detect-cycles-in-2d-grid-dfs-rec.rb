# LeetCode #1559 - Detect Cycles in 2D Grid
# https://leetcode.com/problems/detect-cycles-in-2d-grid/
# By recursive DFS, keeping track of previous vertex.

# @param {Character[][]} grid
# @return {Boolean}
def contains_cycle(grid)
  height = grid.size
  width = grid.first.size
  vis = Array.new(height) { [false] * width }

  dfs = proc do |prev_i, prev_j, cur_i, cur_j|
    return true if vis[cur_i][cur_j]

    vis[cur_i][cur_j] = true

    [[cur_i, cur_j - 1], [cur_i, cur_j + 1],
        [cur_i - 1, cur_j], [cur_i + 1, cur_j]].each do |next_i, next_j|
      next unless next_i.between?(0, height - 1)
      next unless next_j.between?(0, width - 1)
      next if prev_i == next_i && prev_j == next_j
      next if grid[cur_i][cur_j] != grid[next_i][next_j]
      dfs.call(cur_i, cur_j, next_i, next_j)
    end
  end

  0.upto(height - 1) do |start_i|
    0.upto(width - 1) do |start_j|
      dfs.call(start_i, start_j, start_i, start_j) unless vis[start_i][start_j]
    end
  end

  false
end
