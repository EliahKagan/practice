def correct_shape?(grid)
  grid.each_with_index(1).all? { |row, count| row.size == count }
end

def read_grid(io = ARGF)
  grid = io.each_line.map(&.split.map(&.to_i)).to_a
  raise "wrong grid shape" unless correct_shape?(grid)
  grid
end

def max_path_sum(grid)
  (grid.size - 2).downto(0) do |i|
    0.upto(i) do |j|
      grid[i][j] += Math.max(grid[i + 1][j], grid[i + 1][j + 1])
    end
  end

  grid[0][0]
end

puts max_path_sum(read_grid)
