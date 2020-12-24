# Advent of Code 2020, day 17, part B
# 4-dimensional game in the style of Conway's Game of Life.
# See also day 17 part A (3-dimensional) and day 24 part B (hexagonal).

require "option_parser"

def active_indices(row)
  row.each_char.with_index.select do |(ch, _j)|
    case ch
    when '.'
      false
    when '#'
      true
    else
      raise "Unrecognized cell state: '#{ch}'"
    end
  end.map { |(_ch, j)| j }
end

def read_initial_active_cells
  ARGF.each_line
    .map(&.rstrip)
    .with_index
    .flat_map { |(row, i)| active_indices(row).map { |j| {0, i, j, 0} } }
    .to_set
end

def each_adjacent(point, &block)
  h, i, j, k = point

  (h - 1).upto(h + 1) do |hh|
    (i - 1).upto(i + 1) do |ii|
      (j - 1).upto(j + 1) do |jj|
        (k - 1).upto(k + 1) do |kk|
          yield({hh, ii, jj, kk}) if {hh, ii, jj, kk} != {h, i, j, k}
        end
      end
    end
  end
end

# Makes a hash that maps each cell that is active or that is adjacent to an
# active cell to the count of how many cells it is adjacent to. The result
# has a default value of 0, since all other cells are known to be empty.
# But active cells are stored explicitly even if they have no neighbors,
# since that's one of the situations where they must be updated.
def count_adjacency(active)
  counts = Hash({Int32, Int32, Int32, Int32}, Int32).new(0)
  active.each { |src| counts[src] = 0 }
  active.each { |src| each_adjacent(src) { |dest| counts[dest] += 1 } }
  counts
end

def update(active)
  count_adjacency(active).each do |point, count|
    if active.includes?(point)
      active.delete(point) unless count == 2 || count == 3
    else
      active.add(point) if count == 3
    end
  end
end

turns = 6

OptionParser.parse do |parser|
  parser.on "-t COUNT", "--turns=COUNT",
            "The number of turns to take" do |turns_|
    turns = turns_.to_i
  end
  parser.on "-h", "--help", "Show options help" do
    puts parser
    exit
  end
end

active = read_initial_active_cells
turns.times { update(active) }
puts active.size
