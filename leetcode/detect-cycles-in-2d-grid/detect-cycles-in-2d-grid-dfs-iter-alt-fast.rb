# LeetCode #1559 - Detect Cycles in 2D Grid
# https://leetcode.com/problems/detect-cycles-in-2d-grid/
# By iterative DFS, counting graph statistics per component.

# @param {Character[][]} grid
# @return {Boolean}
def contains_cycle(grid)
  height = grid.size
  width = grid.first.size
  vis = Array.new(height) { [false] * width }

  cycle_from = lambda do |i, j|
    return false if vis[i][j]

    vis[i][j] = true
    vertex_count = 1
    neighbor_count = 0
    stack = [[i, j]]

    until stack.empty?
      i, j = stack.pop

      [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].each do |h, k|
        next unless h.between?(0, height - 1) && k.between?(0, width - 1)
        next if grid[i][j] != grid[h][k]

        neighbor_count += 1
        next if vis[h][k]

        vis[h][k] = true
        vertex_count += 1
        stack << [h, k]
      end
    end

    vertex_count - neighbor_count / 2 != 1
  end

  (0...height).any? { |i| (0...width).any? { |j| cycle_from.call(i, j) } }
end
