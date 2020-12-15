# Advent of Code 2020, day 15, part A

require "option_parser"

class History(T)
  def push(value : T)
    old_time = @times[value]?
    @time += 1
    @times[value] = @time
    old_time
  end

  getter time = 0

  @times = {} of T => Int32
end

def simulate(seeds : Array(T), count) forall T
  raise ArgumentError.new("seed sequence must not be empty") if seeds.empty?
  raise ArgumentError.new("must simulate at least one turn") if count <= 0
  return seeds[count - 1] if count <= seeds.size

  history = History(T).new
  old_time = nil
  seeds.each { |seed| old_time = history.push(seed) }
  value = seeds.last

  (count - seeds.size).times do
    value = (old_time ? history.time - old_time : 0)
    old_time = history.push(value)
  end

  value
end

count = 2020

OptionParser.parse do |parser|
  parser.on "-c COUNT", "--count=COUNT",
            "The number of turns to simulate" do |count_|
    count = count_.to_i
  end
  parser.on "-h", "--help", "Show option help" do
    puts parser
    exit
  end
end

ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
  puts simulate(line.split(',').map(&.to_i), count)
end
