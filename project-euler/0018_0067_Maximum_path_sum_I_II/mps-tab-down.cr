def correct_shape?(grid)
  grid.each_with_index(1).all? { |row, count| row.size == count }
end

def read_grid(io = ARGF)
  grid = io.each_line.map(&.split.map(&.to_i)).to_a
  raise "wrong grid shape" unless correct_shape?(grid)
  grid
end

def fill_downward_path_sums(grid)
  1.upto(grid.size - 1) do |i| # upto moves geometrically "down" in the grid.
    grid[i][0] += grid[i - 1][0]

    1.upto(i - 1) do |j|
      grid[i][j] += Math.max(grid[i - 1][j - 1], grid[i - 1][j])
    end

    grid[i][i] += grid[i - 1][i - 1]
  end
end

def max_path_sum(grid)
  fill_downward_path_sums(grid)
  grid.last.max
end

puts max_path_sum(read_grid)
