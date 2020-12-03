# Advent of Code 2020, day 3, part A

def grid_dimensions(grid)
  height = grid.size
  return {0, 0} if height.zero?

  width = grid.first.size
  unless grid.all? { |row| row.size == width }
    raise "Jagged grid not supported"
  end

  {width, height}
end

def count_trees(grid, right, down)
  width, height = grid_dimensions(grid)
  raise "Empty grid not supported" if width.zero? || height.zero?

  j = 0
  0.upto(height - 1).step(down).count do |i|
    cell = grid[i][j]
    j = (j + right) % width
    raise "Unrecognized cell contents" unless ".#".includes?(cell)
    cell == '#'
  end
end

grid = ARGF.each_line.map(&.strip).reject(&.empty?).to_a
puts count_trees(grid, right: 3, down: 1)
