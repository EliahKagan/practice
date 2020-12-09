# Advent of Code 2020, day 9, part B (also solves part A)

require "option_parser"

class Bag(T)
  def add(key : T)
    @counts[key] = (@counts[key]? || 0) + 1
    nil
  end

  def delete(key : T)
    count = @counts[key] - 1
    if count.zero?
      @counts.delete(key)
    else
      @counts[key] = count
    end
    nil
  end

  def includes?(key)
    @counts.has_key?(key)
  end

  @counts = Hash(T, Int32).new
end

module Iterator(T)
  def to_bag
    bag = Bag(T).new
    self.each { |item| bag.add(item) }
    bag
  end
end

def die(message)
  STDERR.puts message
  exit
end

def sliding_window_no_twosum_target_index(values, window_size, debug)
  bag = values.each.first(window_size).to_bag

  window_size.upto(values.size - 1) do |right|
    left = right - window_size

    return right if left.upto(right - 1).none? do |mid|
      complement = values[right] - values[mid]
      ok = complement != values[mid] && bag.includes?(complement)
      if ok && debug
        STDERR.puts "#{values[right]} = #{values[mid]} + #{complement}."
      end
      ok
    end

    bag.add(values[right])
    bag.delete(values[left])
  end

  nil
end

def contiguous_sum_window(values, target) # Assumes all values are nonnegative.
  return nil if values.size < 2

  sum = values.first
  left = 0

  1.upto(values.size - 1) do |right|
    sum += values[right]

    while sum >= target
      return {left, right} if sum == target
      break if left == right - 1
      sum -= values[left]
      left += 1
    end
  end

  nil
end

DEFAULT_PREAMBLE_LENGTH = 25

debug = false
preamble_length = nil
values = [] of Int64

OptionParser.parse do |parser|
  parser.on "--debug", "Print all sums, for debugging" do
    debug = true
  end
  parser.on "-h", "--help", "Show option help" do
    puts parser
    exit 0
  end
end

ARGF.each_line.reject(&.matches?(/^\s*$/)).each_with_index do |line, index|
  if !line.starts_with?('!')
    values << line.to_i64
  elsif index > 0
    raise %q{Only blank/whitespace lines may appear before "!" commands.}
  elsif line =~ /^!preamble(?:-length)?\s+(\d+)\s*$/
    _, digits = $~
    raise "Preamble length specified multiple times." if preamble_length
    preamble_length = digits.to_i
  else
    raise %Q{Unrecognized command "#{line.split.first}".}
  end
end

preamble_length ||= DEFAULT_PREAMBLE_LENGTH
raise "Fewer values than preamble length." if values.size < preamble_length

# Part A
stop = sliding_window_no_twosum_target_index(values, preamble_length, debug)
die "No invalid numbers found (so no part A solution)." unless stop
target = values[stop]
puts target

# Part B
range = contiguous_sum_window(values, target)
die "No contiguous sum found (so no part B solution)." unless range
left, right = range
addends = values[left..right]
STDERR.puts %Q<#{addends.join(" + ")} == #{target}> if debug
puts addends.minmax.sum
