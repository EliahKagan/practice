def correct_shape?(grid)
  grid.each_with_index(1).all? { |row, count| row.size == count }
end

def read_grid(io = ARGF)
  grid = io.each_line.map(&.split.map(&.to_i)).to_a
  raise "wrong grid shape" unless correct_shape?(grid)
  grid
end

def max_path_sum(grid)
  cur = grid.last.clone
  nxt = Array(Int32).new(grid.size, 0)

  (grid.size - 2).downto(0) do |i|
    0.upto(i) { |j| nxt[j] = grid[i][j] + Math.max(cur[j], cur[j + 1]) }
    cur, nxt = nxt, cur
  end

  cur[0]
end

puts max_path_sum(read_grid)
