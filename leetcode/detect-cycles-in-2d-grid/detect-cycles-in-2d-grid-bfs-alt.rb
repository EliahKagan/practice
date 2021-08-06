# LeetCode #1559 - Detect Cycles in 2D Grid
# https://leetcode.com/problems/detect-cycles-in-2d-grid/
# By BFS, counting graph statistics.

# @param {Character[][]} grid
# @return {Boolean}
def contains_cycle(grid)
  height = grid.size
  width = grid.first.size
  vis = Array.new(height) { [false] * width }

  vertex_count = neighbor_count = component_count = 0

  dfs = lambda do |i, j|
    raise 'component already visited' if vis[i][j]

    vis[i][j] = true
    queue = [[i, j]]

    until queue.empty?
      i, j = queue.shift

      [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].each do |h, k|
        next unless h.between?(0, height - 1) && k.between?(0, width - 1)
        next if grid[i][j] != grid[h][k]

        neighbor_count += 1
        next if vis[h][k]

        vis[h][k] = true
        queue << [h, k]
      end

      vertex_count += 1
    end
  end

  0.upto(height - 1) do |i|
    0.upto(width - 1) do |j|
      next if vis[i][j]

      component_count += 1
      dfs.call(i, j)
    end
  end

  vertex_count != neighbor_count / 2 + component_count
end
