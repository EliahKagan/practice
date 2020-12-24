# Advent of Code 2020, day 20, part B (unfinished)

module Indexable
  def rectangle?
    all? { |row| row.size == first.size }
  end

  def square?
    all? { |row| row.size == size }
  end

  def count_in_rows(value)
    sum(&.count(value))
  end
end

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

class Pattern
  def initialize(*rows : String)
    initialize(' ', *rows)
  end

  def initialize(@bg : Char, *rows : String)
    raise "non-rectangular pattern" unless rows.rectangle?
    @rows = rows.to_a
  end

  getter bg

  def [](row_index)
    @rows[row_index]
  end

  def height
    @rows.size
  end

  def width
    @rows.first.size
  end

  def count(ch : Char)
    @rows.count_in_rows(ch)
  end

  @rows : Array(String)
end

class Grid
  def self.from_tiles(tiles : Array(Array(Grid)))
    raise "no tiles to create grid from" if tiles.empty?
    raise "non-square tile arrangement" unless tiles.square?

    Grid.new(tiles.flat_map(&.map(&.rows).transpose.map(&.join)))
  end

  def initialize(rows : Array(String))
    @rows = rows.dup
    raise "empty grid not supported" if @rows.empty?
    raise "grid is not square" unless @rows.square?

    @left = rows.map(&.first).join
    @right = rows.map(&.last).join
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

  def top
    @rows.first
  end

  def bottom
    @rows.last
  end

  getter left : String

  getter right : String

  def sides
    {top, bottom, left, right}
  end

  def deoriented_sides
    sides.map(&.deorient)
  end

  def orient_top(side)
    image = do_orient_top(side)
    raise "can't orient to top neighbor" unless image
    raise "Bug: orient_top computed wrong result" if image.top != side
    image
  end

  def orient_left(side)
    image = do_orient_left(side)
    raise "can't orient to left neighbor" unless image
    raise "Bug: orient_left computed wrong result" if image.left != side
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

  def interior
    Grid.new(@rows[1...-1].map! { |row| row[1...-1] })
  end

  def count_matches(pattern : Pattern)
    count = 0
    each_match(pattern) { count += 1 }
    count
  end

  def count_matches_without_reuse(pattern : Pattern)
    count = 0
    each_match_without_reuse(pattern) { count += 1 }
    count
  end

  def each_match(pattern : Pattern, &block)
    0.upto(size - pattern.height) do |i|
      0.upto(size - pattern.width) do |j|
        yield(i, j) if matches_at?(pattern, i, j)
      end
    end
  end

  def each_match_without_reuse(pattern : Pattern, &block)
    used = Set(Tuple(Int32, Int32)).new

    0.upto(size - pattern.height) do |i|
      0.upto(size - pattern.width) do |j|
        yield(i, j) if matches_without_reuse_at?(pattern, i, j, used)
      end
    end
  end

  def count(ch : Char)
    @rows.count_in_rows(ch)
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

  private def matches_at?(pattern, i, j)
    0.upto(pattern.height - 1) do |di|
      0.upto(pattern.width - 1) do |dj|
        ch = pattern[di][dj]
        return false if ch != pattern.bg && @rows[i + di][j + dj] != ch
      end
    end

    true
  end

  private def matches_without_reuse_at?(pattern, i, j, used)
    coords = [] of {Int32, Int32}

    0.upto(pattern.height - 1) do |di|
      0.upto(pattern.width - 1) do |dj|
        ch = pattern[di][dj]
        next if ch == pattern.bg

        i2 = i + di
        j2 = j + dj
        return false if @rows[i2][j2] != ch || used.includes?({i2, j2})

        coords << {i2, j2}
      end
    end

    used.concat(coords)
    true
  end
end

class TilesBySide
  def initialize(tiles : Enumerable(Grid))
    count = 0

    tiles.each do |tile|
      tile.deoriented_sides.each { |side| @groups[side] << tile }
      count += 1
    end

    @tile_count = count
  end

  getter tile_count : Int32

  def [](side : String)
    @groups[side.deorient]
  end

  def edge_side?(side : String)
    self[side].size == 1
  end

  def corner_tile?(tile : Grid)
    tile.sides.count { |side| edge_side?(side) } == 2
  end

  @groups = Hash(String, Array(Grid)).new do |hash, key|
    hash[key] = [] of Grid
  end
end

# The side length of each tile, including its border.
FULL_TILE_SIZE = 10

# The pattern to search for in boards arranged-tile interiors.
SEA_MONSTER = Pattern.new(
  "                  # ",
  "#    ##    ##    ###",
  " #  #  #  #  #  #   ",
)

def make_tile(rows)
  unless rows.size == FULL_TILE_SIZE
    if rows.size == 1
      raise "got #{rows.size} row, need #{FULL_TILE_SIZE}"
    else
      raise "got #{rows.size} rows, need #{FULL_TILE_SIZE}"
    end
  end

  unless rows.all? { |row| row.size == FULL_TILE_SIZE }
    raise "not all rows have size #{FULL_TILE_SIZE}"
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

def check_corners(corners)
  raise "too few obvious corners" if corners.size < 4
  raise "too many obvious corners" if corners.size > 4
end

def orient_top_left_corner(tiles_by_side, corner)
  edges = corner.deoriented_sides.select do |side|
    tiles_by_side.edge_side?(side)
  end

  raise "can't orient non-corner as corner" unless edges.size == 2
  top, left = edges

  images = corner.symmetry_images.select do |tile|
    tile.top.deorient == top && tile.left.deorient == left
  end

  raise "can't orient corner" if images.empty?
  images.first
end

def arrange_top_row(tiles_by_side, mark_used, corner)
  preimage = corner
  mark_used.call(preimage)
  image = orient_top_left_corner(tiles_by_side, preimage)
  pre_top_row = [preimage]
  top_row = [image]

  until tiles_by_side.edge_side?(image.right)
    both = tiles_by_side[image.right]
    raise "Bug: vertical side can't join two tiles" if both.size != 2
    raise "Bug: inconsistent right side" unless both.includes?(preimage)

    preimage = both.reject(preimage).first
    mark_used.call(preimage)
    pre_top_row << preimage

    image = preimage.orient_left(image.right)
    raise "top edge mismatch" unless tiles_by_side.edge_side?(image.top)
    top_row << image
  end

  {pre_top_row, top_row}
end

def arrange_next_row(tiles_by_side, mark_used, upper_pre_row, upper_row)
  pre_row = [] of Grid
  row = [] of Grid

  upper_pre_row.zip(upper_row) do |upper_preimage, upper_image|
    both = tiles_by_side[upper_image.bottom]
    raise "Bug: horizontal side can't join two tiles" if both.size != 2
    raise "Bug: inconsistent bottom side" unless both.includes?(upper_preimage)

    preimage = both.reject(upper_preimage).first
    mark_used.call(preimage)
    pre_row << preimage

    image = preimage.orient_top(upper_image.bottom)
    if row.empty?
      raise "left edge mismatch" unless tiles_by_side.edge_side?(image.left)
    else
      raise "interior left side mismatch" unless image.left == row.last.right
    end
    row << image
  end

  raise "right edge mismatch" unless tiles_by_side.edge_side?(row.last.right)

  {pre_row, row}
end

def arrange_all_rows(tiles_by_side, corner)
  used = Set(Grid).new

  mark_used = ->(tile : Grid) do
    raise "next tile already used" if used.includes?(tile)
    used << tile
    nil
  end

  pre_row, row = arrange_top_row(tiles_by_side, mark_used, corner)
  pre_tiling = [pre_row]
  tiling = [row]

  until tiles_by_side.edge_side?(row.first.bottom)
    pre_row, row = arrange_next_row(tiles_by_side, mark_used, pre_row, row)
    pre_tiling << pre_row
    tiling << row
  end

  unless tiling.last.all? { |tile| tiles_by_side.edge_side?(tile.bottom) }
    raise "bottom edge mismatch"
  end

  if used.size != tiles_by_side.tile_count
    raise "used count #{used.size} != tile count #{tiles_by_side.tile_count}"
  end

  tiling
end

ids_by_tile = read_tiles
tiles = ids_by_tile.keys
tiles_by_side = TilesBySide.new(tiles)

corners = tiles.select { |tile| tiles_by_side.corner_tile?(tile) }
check_corners(corners)
corner_ids = corners.map { |tile| ids_by_tile[tile] }
puts %Q[Obvious corners are: #{corner_ids.join(", ")}]
puts

tiling = arrange_all_rows(tiles_by_side, corners.first)
raise "full tiling is not square" unless tiling.square?
puts "Constructed full tiling of #{tiling.size} by #{tiling.size} tiles."
puts

board = Grid.from_tiles(tiling.map(&.map(&.interior)))

counts = board.symmetry_images.map do |image|
  {allowing_reuse: image.count_matches(SEA_MONSTER),
   without_reuse: image.count_matches_without_reuse(SEA_MONSTER)}
end

counts.each_with_index do |pair, index|
  printf "%d: %3d allowing reuse, %3d without reuse\n",
         index, pair[:allowing_reuse], pair[:without_reuse]
end
puts

support = counts.reject do |pair|
  pair[:allowing_reuse].zero? && pair[:without_reuse].zero?
end
raise "sea monsters appear in multiple symmetry images" if support.size != 1

sea_monster_count = support.first[:allowing_reuse]
unless sea_monster_count == support.first[:without_reuse]
  raise "sea-monster counts differ with and without overlap"
end

uncalm_area = board.count('#')
area_per_sea_monster = SEA_MONSTER.count('#')
total_sea_monster_area = area_per_sea_monster * sea_monster_count
rough_area = uncalm_area - total_sea_monster_area

puts "The area per sea monster is #{area_per_sea_monster}."
puts "The number of sea monsters is #{sea_monster_count}."
puts "As they don't overlap, their total area is #{total_sea_monster_area}."
puts "The number of cells that are rough or a sea monster is #{uncalm_area}."
puts "No cell is both, so the number of rough cells is #{rough_area}."
puts
puts rough_area # Show it again on its own line, as it is the puzzle solution.
