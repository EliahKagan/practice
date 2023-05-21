# LeetCode #934 - Shortest Bridge
# https://leetcode.com/problems/shortest-bridge/
# By DFS to explore the first component, then BFS to find the second.

# @param {Integer[][]} grid
# @return {Integer}
def shortest_bridge(grid)
  # Explore the first component.
  queue = explore(grid, *find_land(grid))
  dist = Array.new(grid.size) { [nil] * grid.size }
  queue.each { |i, j| dist[i][j] = 0 }

  # Find the shortest distance to the second component.
  until queue.empty?
    i, j = queue.shift

    [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].each do |dest_i, dest_j|
      next unless exists?(dist, dest_i, dest_j) && dist[dest_i][dest_j].nil?

      return dist[i][j] unless grid[dest_i][dest_j].zero?

      dist[dest_i][dest_j] = dist[i][j] + 1
      queue << [dest_i, dest_j]
    end
  end

  raise 'no second island found (grid has only one component)'
end

# Find coordinates of an arbitrary "land" cell.
def find_land(grid)
  0.upto(grid.size - 1) do |i|
    grid[i].each_with_index do |elem, j|
      return [i, j] unless elem.zero?
    end
  end

  raise 'land not found (grid is all zeros)'
end

# Explore a component. Return an array of its coordinates.
def explore(grid, start_i, start_j)
  vis = Set.new

  dfs = lambda do |i, j|
    return unless land?(grid, i, j) && !vis.include?([i, j])

    vis << [i, j]

    dfs.call(i, j - 1)
    dfs.call(i, j + 1)
    dfs.call(i - 1, j)
    dfs.call(i + 1, j)
  end

  dfs.call(start_i, start_j)
  vis.to_a
end

# Check if indices are valid for a *square* array.
def exists?(matrix, i, j)
  i.between?(0, matrix.size - 1) && j.between?(0, matrix.size - 1)
end

# Check if indices are coordinates of "land" in a square grid.
def land?(grid, i, j)
  exists?(grid, i, j) && !grid[i][j].zero?
end
