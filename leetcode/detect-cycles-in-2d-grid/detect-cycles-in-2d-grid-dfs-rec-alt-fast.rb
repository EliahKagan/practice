# LeetCode #1559 - Detect Cycles in 2D Grid
# https://leetcode.com/problems/detect-cycles-in-2d-grid/
# By recursive DFS, counting graph statistics per component.

# @param {Character[][]} grid
# @return {Boolean}
def contains_cycle(grid)
  height = grid.size
  width = grid.first.size
  vis = Array.new(height) { [false] * width }

  dfs = lambda do |i, j| # Returns vertex_count, neighbor_count.
    return [0, 0] if vis[i][j]

    vis[i][j] = true

    vertex_count = 1
    neighbor_count = 0

    [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].each do |h, k|
      next unless h.between?(0, height - 1) && k.between?(0, width - 1)
      next if grid[i][j] != grid[h][k]

      sub_vertex_count, sub_neighbor_count = dfs.call(h, k)
      vertex_count += sub_vertex_count
      neighbor_count += 1 + sub_neighbor_count
    end

    [vertex_count, neighbor_count]
  end

  0.upto(height - 1) do |i|
    0.upto(width - 1) do |j|
      next if vis[i][j]

      vertex_count, neighbor_count = dfs.call(i, j)
      return true if vertex_count - neighbor_count / 2 != 1
    end
  end

  false
end
