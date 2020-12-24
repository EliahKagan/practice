# Advent of Code 2020, day 24, part A - alternate implementation

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
end

black_tiles = Set(Tile).new

ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
  tile = line.split(/(?<=[ew])(?!$)/).map(&.to_direction).sum(Tile.origin)

  if black_tiles.includes?(tile)
    black_tiles.delete(tile)
  else
    black_tiles.add(tile)
  end
end

puts black_tiles.size
