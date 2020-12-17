# Advent of Code 2020, day 17, part A

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
    .flat_map { |(row, i)| active_indices(row).map { |j| {i, j, 0} } }
    .to_set
end

def each_adjacent(point, &block)
  i, j, k = point

  (i - 1).upto(i + 1) do |ii|
    (j - 1).upto(j + 1) do |jj|
      (k - 1).upto(k + 1) do |kk|
        yield({ii, jj, kk}) if {ii, jj, kk} != {i, j, k}
      end
    end
  end
end

def count_adjacency(active)
  counts = Hash({Int32, Int32, Int32}, Int32).new(0)

  active.each do |src|
    each_adjacent(src) { |dest| counts[dest] += 1 }
  end

  counts
end

def update(active)
  count_adjacency(active).each do |point, count|
    if active.includes?(point)
      active.delete(point) unless count == 2 || count == 3
    else
      active.add(point) if count == 3
    end
    nil
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
