# Advent of Code 2020, day 24, part A

struct Tile
  def self.origin
    Tile.new(0, 0)
  end

  def initialize(@row : Int32, @col : Int32)
  end

  getter row, col

  def_equals_and_hash @row, @col

  def +(direction : String)
    case direction
    when "e"
      Tile.new(@row, @col + 1)
    when "w"
      Tile.new(@row, @col - 1)
    when "se"
      Tile.new(@row + 1, (@row.even? ? @col + 1 : @col))
    when "sw"
      Tile.new(@row + 1, (@row.even? ? @col : @col - 1))
    when "ne"
      Tile.new(@row - 1, (@row.even? ? @col + 1 : @col))
    when "nw"
      Tile.new(@row - 1, (@row.even? ? @col : @col - 1))
    else
      raise ArgumentError.new(%Q[unrecognized direction "#{direction}"])
    end
  end
end

black_tiles = Set(Tile).new

ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
  tile = line.split(/(?<=[ew])(?!$)/).sum(Tile.origin)

  if black_tiles.includes?(tile)
    black_tiles.delete(tile)
  else
    black_tiles.add(tile)
  end
end

puts black_tiles.size
