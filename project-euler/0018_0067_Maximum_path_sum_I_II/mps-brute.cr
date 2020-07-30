def correct_shape?(grid)
  grid.each_with_index(1).all? { |row, count| row.size == count }
end

def read_grid(io = ARGF)
  grid = io.each_line.map(&.split.map(&.to_i)).to_a
  raise "wrong grid shape" unless correct_shape?(grid)
  grid
end

def max_path_sum(grid, i, j)
  return 0 if i == grid.size

  grid[i][j] + Math.max(max_path_sum(grid, i + 1, j),
                        max_path_sum(grid, i + 1, j + 1))
end

puts max_path_sum(read_grid, 0, 0)
