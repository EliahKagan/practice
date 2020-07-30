def read_grid(io = ARGF)
  grid = io.each_line.map(&.split.map(&.to_i)).to_a
  
  unless grid.each_with_index(1).all? { |row, count| row.size == count }
    raise "wrong grid shape"
  end
  
  grid
end

grid = read_grid
grid.each { |row| pp row }
