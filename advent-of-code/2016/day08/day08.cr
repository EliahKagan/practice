# Advent of Code 2016, day 8, parts A and B
# (For part B, pass the -v option and read the output.)

require "option_parser"

class Board
  def initialize
    @rows = Board.make_rows(50, 6)
  end

  def to_s(io)
    io << @rows.map { |row| row.map { |b| b ? '#' : '.' }.join }.join('\n')
  end

  def redimension(width, height)
    @rows = Board.make_rows(width, height)
    nil
  end

  def rect(width, height)
    0.upto(height - 1) do |i|
      0.upto(width - 1) do |j|
        @rows[i][j] = true
      end
    end
  end

  def rotate_row(row_index, count)
    @rows[row_index].rotate!(-count)
    nil
  end

  def rotate_column(col_index, count)
    # This implementation is very inefficient, but the grid is extremely small.
    cols = @rows.transpose
    cols[col_index].rotate!(-count)
    @rows = cols.transpose
    nil
  end

  def popcount
    @rows.sum { |row| row.count { |b| b } }
  end

  protected def self.make_rows(width, height)
    Array.new(height) { [false] * width }
  end

  @rows : Array(Array(Bool))
end

verbose = false
OptionParser.parse do |parser|
  parser.on "-h", "--help", "Show options help" do
    puts parser
    exit
  end
  parser.on "-v", "--verbose", "Print board after each step" do
    verbose = true
  end
  parser.on "-q", "--quiet", "Don't print board (default)" do
    verbose = false
  end
end

board = Board.new

ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
  case line
  when /REDIM\s+(\d+)x(\d+)/
    _, width, height = $~
    board.redimension(width.to_i, height.to_i)
  when /rect\s+(\d+)x(\d+)/
    _, width, height = $~
    board.rect(width.to_i, height.to_i)
  when /rotate\s+row\s+y=(\d+)\s+by\s+(\d+)/
    _, row_index, count = $~
    board.rotate_row(row_index.to_i, count.to_i)
  when /rotate\s+column\s+x=(\d+)\s+by\s+(\d+)/
    _, col_index, count = $~
    board.rotate_column(col_index.to_i, count.to_i)
  else
    raise "Bad command: #{line}"
  end

  if verbose
    puts board
    puts
  end
end

puts board.popcount
