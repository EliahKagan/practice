# Advent of Code 2020, day 20, part A

# The side length of each tile.
SIZE = 10

# The number of tiles that are needed as corners.
CORNER_COUNT = 4

# Printed to the left of secondary output lines (unrelated to board geometry).
MARGIN = "   "

struct Tile
  getter id : Int64

  def initialize(stanza)
    raise "empty stanza" if stanza.empty?
    raise "can't find tile title" unless stanza.first =~ /^Tile\s+(\d+):$/i
    _, id_digits = $~
    @id = id_digits.to_i64

    @rows = stanza[1..].map(&.rstrip)
    unless @rows.size == SIZE
      if @rows.size == 1
        raise "got #{@rows.size} row, need #{SIZE}"
      else
        raise "got #{@rows.size} rows, need #{SIZE}"
      end
    end
    unless @rows.all? { |row| row.size == SIZE }
      raise "not all rows have size #{SIZE}"
    end
  end

  def deoriented_sides
    {top, right, bottom, left}.map { |side| Math.min(side, side.reverse).join }
  end

  private def top
    @rows.first.chars
  end

  private def bottom
    @rows.last.chars
  end

  private def left
    @rows.map { |row| row[0] }
  end

  private def right
    @rows.map { |row| row[-1] }
  end

  @rows : Array(String)
end

def read_tiles
  ARGF.each_line("\n\n").map { |entry| Tile.new(entry.strip.lines) }.to_a
end

def group_ids_by_side(tiles)
  by_side = Hash(String, Array(Int64)).new do |hash, key|
    hash[key] = [] of Int64
  end

  tiles.each do |tile|
    tile.deoriented_sides.each { |side| by_side[side] << tile.id }
  end

  by_side
end

def print_side_ids(side, ids)
  puts %Q[#{MARGIN}#{side}: #{ids.join(", ")}]
end

tiles = read_tiles.sort_by!(&.id) # sorted for easier perusal
ids_by_side = group_ids_by_side(tiles)
puts "All:"
ids_by_side.each { |side, ids| print_side_ids(side, ids) }

tiles.each do |tile|
  puts "\n#{tile.id}:"
  tile.deoriented_sides.each { |side| print_side_ids(side, ids_by_side[side]) }
end

puts

count_obvious_edges = ->(tile : Tile) do
  tile.deoriented_sides.count { |side| ids_by_side[side].size == 1 }
end

obvious_corners = tiles.select { |tile| count_obvious_edges.call(tile) == 2 }

if obvious_corners.empty?
  puts "There are no obvious corners."
elsif obvious_corners.size == 1
  puts "There is only #{obvious_corners.size} obvious corner:"
elsif obvious_corners.size < CORNER_COUNT
  puts "There are only #{obvious_corners.size} obvious corners:"
elsif obvious_corners.size == CORNER_COUNT
  puts "Good news, there are exactly #{obvious_corners.size} obvious corners:"
else
  puts "At least #{obvious_corners.size} tiles would have to be corners!"
end

unless obvious_corners.empty?
  puts %Q[#{MARGIN}#{obvious_corners.map(&.id).join(", ")}]
end

if obvious_corners.size == CORNER_COUNT
  puts "\nThe product of their ID numbers is #{obvious_corners.product(&.id)}."
  exit 0
else
  exit 1
end
