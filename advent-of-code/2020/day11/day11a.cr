# Advent of Code 2020, day 11, part A

require "option_parser"

# When the adjacent population drops this low, a cell is populated.
BIRTH_THRESHOLD = 0

# When the adjacent population rises this high, a cells is depopulated.
DEATH_THRESHOLD = 4

# Cells with this symbol can never be populated. They are "holes" in the board.
BLOCKED = '.'

# Cells with this symbol are not currently populated but potentially could be.
VACANT = 'L'

# Cells with this symbol are currently populated.
OCCUPIED = '#'

class Board
  class Error < Exception
  end

  def initialize(io)
    lines = io.each_line.map(&.rstrip).to_a
    while !lines.empty? && lines.last.empty?
      lines.pop
    end
    raise Error.new("empty board not supported") if lines.empty?

    if lines.any? { |line| line.size != lines.first.size }
      raise Error.new("jagged board not supported")
    end

    if lines.first.empty?
      raise Error.new("zero-width board not supported")
    end

    @rows = lines.map(&.chars)

    0.upto(height - 1) do |i|
      0.upto(width - 1) do |j|
        unless {BLOCKED, VACANT, OCCUPIED}.includes?(@rows[i][j])
          raise Error.new("invalid character #{@rows[i][j]} at (#{i}, #{j})")
        end
      end
    end
  end

  def ==(other : Board)
    @rows == other.rows
  end

  def to_s(io)
    @rows.each { |row| io << row.join << '\n' }
    io
  end

  def height
    @rows.size
  end

  def width
    @rows.first.size
  end

  def successor
    Board.new(self, EvolveTag.new)
  end

  def count(ch : Char)
    @rows.sum(&.count(ch))
  end

  private struct EvolveTag
  end

  protected def initialize(original : Board, tag : EvolveTag)
    @rows = original.rows.map(&.dup)

    0.upto(height - 1) do |i|
      0.upto(width - 1) do |j|
        case original.rows[i][j]
        when VACANT
          if original.count_adjacent(i, j, OCCUPIED) <= BIRTH_THRESHOLD
            @rows[i][j] = OCCUPIED
          end
        when OCCUPIED
          if original.count_adjacent(i, j, OCCUPIED) >= DEATH_THRESHOLD
            @rows[i][j] = VACANT
          end
        when BLOCKED
          next # Spaces with no seat are never changed.
        else
          raise "Bug: invalid cell state"
        end
      end
    end
  end

  protected getter rows : Array(Array(Char))

  protected def count_adjacent(i, j, ch)
    count = 0

    (i - 1).upto(i + 1) do |h|
      (j - 1).upto(j + 1) do |k|
        count += 1 if has_pos?(h, k) && {h, k} != {i, j} && @rows[h][k] == ch
      end
    end

    count
  end

  private def has_pos?(i, j)
    0 <= i < height && 0 <= j < width
  end
end

verbosity = 0

OptionParser.parse do |parser|
  parser.on "-v", "--verbose",
            "Verbose output (pass multiple times for more verbosity)" do
    verbosity += 1
  end
  parser.on "-h", "--help", "Show options help" do
    puts parser
    exit
  end
end

if verbosity == 1
  STDERR.puts %Q[#{PROGRAM_NAME}: for more verbosity, pass "-v" twice ("-v -v")]
end

board = Board.new(ARGF)
loop do
  next_board = board.successor
  break if next_board == board
  puts board if verbosity >= 2
  board = next_board
end

puts board if verbosity >= 1
puts board.count(OCCUPIED)
