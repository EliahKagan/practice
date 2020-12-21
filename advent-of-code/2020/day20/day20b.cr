# Advent of Code 2020, day 20, part B

# The side length of each tile, including its border.
FULL_SIZE = 10

# The number of tiles that are needed as corners.
CORNER_COUNT = 4

# Printed to the left of secondary output lines (unrelated to board geometry).
MARGIN = "   "

class String
  def first
    self[0]
  end

  def last
    self[-1]
  end

  def deorient
    Math.min(self, reverse)
  end
end

class Grid
  def initialize(rows : Array(String))
    @rows = rows.dup
    raise "empty grid not supported" if @rows.empty?
    unless @rows.all? { |row| row.size == @rows.size }
      raise "grid is not square"
    end

    @top = rows.first
    @bottom = rows.last
    @left = rows.map(&.first).join
    @right = rows.map(&.last).join

    @deoriented_sides = {@top, @bottom, @left, @right}.map(&.deorient)
  end

  def initialize(rows : Array(Array(Char)))
    initialize(rows.map(&.join))
  end

  def ==(other : Grid)
    same?(other) || (size == other.size && @rows == other.rows)
  end

  def_hash @rows

  def size
    @rows.size
  end

  getter top : String
  getter bottom : String
  getter left : String
  getter right : String
  getter deoriented_sides : Tuple(String, String, String, String)

  def orient_top(side)
    image = do_orient_top(side)
    if image && image.top != side
      raise "bug: orient_top computed wrong result"
    end
    image
  end

  def orient_left(side)
    image = do_orient_left(side)
    if image && image.left != side
      raise "Bug: orient_left computed wrong result"
    end
    image
  end

  def symmetry_images
    {
      self,
      turn_counterclockwise,
      turn_clockwise,
      turn_about,
      flip_horizontal,
      flip_vertical,
      flip_major_diagonal,
      flip_minor_diagonal,
    }
  end

  protected getter rows : Array(String)

  private def do_orient_top(side)
    return self if side == top
    return flip_horizontal if side == bottom
    return flip_major_diagonal if side == left
    return turn_counterclockwise if side == right

    reversed = side.reverse
    return flip_vertical if reversed == top
    return turn_about if reversed == bottom
    return turn_clockwise if reversed == left
    return flip_minor_diagonal if reversed == right

    nil
  end

  private def do_orient_left(side)
    return flip_major_diagonal if side == top
    return turn_clockwise if side == bottom
    return self if side == left
    return flip_vertical if side == right

    reversed = side.reverse
    return turn_counterclockwise if reversed == top
    return flip_minor_diagonal if reversed == bottom
    return flip_horizontal if reversed == left
    return turn_about if reversed == right

    nil
  end

  private def turn_counterclockwise
    Grid.new(@rows.transpose.reverse!)
  end

  private def turn_clockwise
    Grid.new(@rows.reverse.transpose)
  end

  private def turn_about
    Grid.new(@rows.map(&.reverse).reverse!)
  end

  private def flip_horizontal
    Grid.new(@rows.reverse)
  end

  private def flip_vertical
    Grid.new(@rows.map(&.reverse))
  end

  private def flip_major_diagonal
    Grid.new(@rows.transpose)
  end

  private def flip_minor_diagonal
    Grid.new(@rows.reverse.transpose.reverse!)
  end
end

def make_tile(rows)
  unless rows.size == FULL_SIZE
    if rows.size == 1
      raise "got #{rows.size} row, need #{FULL_SIZE}"
    else
      raise "got #{rows.size} rows, need #{FULL_SIZE}"
    end
  end
  unless rows.all? { |row| row.size == FULL_SIZE }
    raise "not all rows have size #{FULL_SIZE}"
  end

  Grid.new(rows)
end

def read_tiles
  ARGF.each_line("\n\n").to_h do |text|
    stanza = text.strip.lines
    raise "empty stanza" if stanza.empty?
    raise "can't find tile title" unless stanza.first =~ /^Tile\s+(\d+):$/i
    _, id_digits = $~

    {make_tile(stanza[1..].map(&.rstrip)), id_digits.to_i}
  end
end

def group_tiles_by_side(tiles)
  tiles_by_side = Hash(String, Array(Grid)).new do |hash, key|
    hash[key] = [] of Grid
  end

  tiles.each do |tile|
    tile.deoriented_sides.each { |side| tiles_by_side[side] << tile }
  end

  tiles_by_side
end

ids_by_tile = read_tiles
tiles = ids_by_tile.keys
tiles_by_side = group_tiles_by_side(tiles)

corners = tiles.select do |tile|
  tile.deoriented_sides.count { |side| tiles_by_side[side].size == 1 } == 2
end

raise "too few obvious corners" if corners.size < CORNER_COUNT
raise "too many obvious corners" if corners.size > CORNER_COUNT

# FIXME: Implement the rest of part B (and probably remove this):
corner_ids = corners.map { |tile| ids_by_tile[tile] }
puts %Q[Obvious corners are #{corner_ids.join(", ")}]
