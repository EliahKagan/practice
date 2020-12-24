# Advent of Code 2020, day 24, part B
# Hexagonal-grid game in the style of Conway's Game of Life.
# See also day 17 parts A and B (on 3D cube and 4D hypercube grids).

require "option_parser"

enum Direction
  E
  W
  SE
  SW
  NE
  NW
end

class String
  def to_direction
    Direction.parse(self)
  end
end

struct Tile
  def self.origin
    Tile.new(0, 0)
  end

  def initialize(@row : Int32, @col : Int32)
  end

  def_equals_and_hash @row, @col

  def +(direction : Direction)
    case direction
    when Direction::E
      Tile.new(@row, @col + 1)
    when Direction::W
      Tile.new(@row, @col - 1)
    when Direction::SE
      Tile.new(@row + 1, (@row.even? ? @col + 1 : @col))
    when Direction::SW
      Tile.new(@row + 1, (@row.even? ? @col : @col - 1))
    when Direction::NE
      Tile.new(@row - 1, (@row.even? ? @col + 1 : @col))
    when Direction::NW
      Tile.new(@row - 1, (@row.even? ? @col : @col - 1))
    else
      raise ArgumentError.new("Bug: bad direction")
    end
  end

  def each_neighbor(&block)
    Direction.each { |direction| yield self + direction }
  end
end

def initial_black_tiles
  black_tiles = Set(Tile).new

  ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
    tile = line.split(/(?<=[ew])(?!$)/).map(&.to_direction).sum(Tile.origin)

    if black_tiles.includes?(tile)
      black_tiles.delete(tile)
    else
      black_tiles.add(tile)
    end
  end

  black_tiles
end

def log(black_tiles, turn)
  printf "%4d: %d\n", turn, black_tiles.size
end

# Makes a hash that maps each tile that is black or that is adjacent to a black
# tile to the count of how many cells it is adjacent to. The result has a
# default value of 0, since all other cells are known to be empty. But active
# cells are stored explicitly even if they have no neighbors, since that's one
# of the situations where they must be updated.
def neighbor_counts(black_tiles)
  counts = Hash(Tile, Int32).new(0)
  black_tiles.each { |src| counts[src] = 0 }
  black_tiles.each(&.each_neighbor { |dest| counts[dest] += 1 })
  counts
end

def update(black_tiles)
  neighbor_counts(black_tiles).each do |tile, count|
    if black_tiles.includes?(tile)
      black_tiles.delete(tile) unless count == 1 || count == 2
    else
      black_tiles.add(tile) if count == 2
    end
  end
end

turns = 100
verbose = false

OptionParser.parse do |parser|
  parser.on "-t COUNT", "--turns=COUNT",
            "The number of turns to take" do |_turns|
    turns = _turns.to_i
  end
  parser.on "-v", "--verbose", "Show counts at every step" do
    verbose = true
  end
  parser.on "-h", "--help", "Show options help" do
    puts parser
    exit
  end
end

black_tiles = initial_black_tiles
log(black_tiles, 0) if verbose

1.upto(turns) do |turn|
  update(black_tiles)
  log(black_tiles, turn) if verbose
end

puts black_tiles.size
