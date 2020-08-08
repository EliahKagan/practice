def correct_shape?(grid)
  grid.each_with_index(1).all? { |row, count| row.size == count }
end

def read_grid(io = ARGF)
  grid = io.each_line.map(&.split.map(&.to_i)).to_a
  raise "wrong grid shape" unless correct_shape?(grid)
  grid
end

def max_path_sum_to_dest(grid, i, j)
  sum_above =
    if i.zero?
      0
    elsif j.zero?
      max_path_sum_to_dest(grid, i - 1, j)
    elsif j == i
      max_path_sum_to_dest(grid, i - 1, j - 1)
    else
      Math.max(max_path_sum_to_dest(grid, i - 1, j - 1),
               max_path_sum_to_dest(grid, i - 1, j))
    end

  grid[i][j] + sum_above
end

def max_path_sum(grid)
  i = grid.size - 1
  (0..i).max_of { |j| max_path_sum_to_dest(grid, i, j) }
end

puts max_path_sum(read_grid)
