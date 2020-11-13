# Advent of Code 2016, day 2, part B

require "option_parser"

class Board
  @grid : Array(String)
  @i : Int32
  @j : Int32

  def initialize(grid, start_char)
    @grid = grid.clone
    check
    pad
    @i, @j = find(start_char)
  end

  def get
    @grid[@i][@j]
  end

  def go(direction)
    case direction
    when 'U'
      go_delta(-1, 0)
    when 'D'
      go_delta(1, 0)
    when 'L'
      go_delta(0, -1)
    when 'R'
      go_delta(0, 1)
    else
      raise ArgumentError.new("unrecognized direction '#{direction}'")
    end
  end

  private def go_delta(di, dj)
    return if @grid[@i + di][@j + dj] == ' '
    @i += di
    @j += dj
    nil
  end

  private def check
    raise ArgumentError.new("empty grid not allowed") if @grid.empty?

    if @grid.any? { |row| row.size != width }
      raise ArgumentError.new("jagged grid not allowed")
    end

    raise ArgumentError.new("empty row not allowed") if @grid.any?(&.empty?)
  end

  private def pad
    # Pad left and right.
    @grid.map! { |row| " #{row} " }

    # Pad top and bottom.
    horizontal = " " * width
    @grid.unshift(horizontal)
    @grid.push(horizontal)
  end

  private def height
    @grid.size
  end

  private def width
    @grid.first.size
  end

  private def find(ch)
    1.upto(height - 2) do |i|
      1.upto(width - 2) do |j|
        return {i, j} if @grid[i][j] == ch
      end
    end
    raise ArgumentError.new("character '#{ch}' not found in grid")
  end
end

GRIDS = {
  'A' => [
    "123",
    "456",
    "789",
  ],
  'B' => [
    "  1  ",
    " 234 ",
    "56789",
    " ABC ",
    "  D  ",
  ]
}

grid = GRIDS['B']
OptionParser.parse do |parser|
  parser.on "-A", "--part-a", "Use part A grid" do
    grid = GRIDS['A']
  end
  parser.on "-B", "--part-b", "Use part B grid (default)" do
    grid = GRIDS['B']
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end

board = Board.new(grid, '5')

ARGF.each_line do |line|
  line.strip.each_char { |direction| board.go(direction) }
  print board.get
end

puts
