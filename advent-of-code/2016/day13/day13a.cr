# Advent of Code 2016, day 13, part A

require "deque"
require "option_parser"

def each_neighbor(src : {T, T}, &block) forall T
  x, y = src
  yield({x - 1, y})
  yield({x + 1, y})
  yield({x, y - 1})
  yield({x, y + 1})
  nil
end

def bfs(start : {T, T}, finish : {T, T}, &can_go) forall T
  vis = Set{start}
  queue = Deque{start}
  
  (1..).each do |length|
    queue.size.times do
      each_neighbor(queue.shift) do |dest|
        next unless yield(*dest) && !vis.includes?(dest)
        return length if dest == finish
        vis.add(dest)
        queue.push(dest)
      end
    end
  end
end

def bfs(start : {T, T}, finish : {T, T}, can_go_bias) forall T
  bfs(start, finish) do |x, y|
    next false if x < 0 || y < 0
    sum = x * x + 3 * x + 2 * x * y + y + y * y + can_go_bias
    sum.popcount.even?
  end
end

def pretty_coords(coords)
  x, y = coords
  "(#{x}, #{y})"
end

def parse_coords(text)
  text = text.strip
  raise "can't parse as coordinates: #{text}" unless text =~ /^(\d+),(\d+)$/
  _, x, y = $~
  {x, y}.map(&.to_i)
end

def parse_bias(text)
  text.to_i? || raise "can't parse as bias (integer): #{text.strip}"
end

start_default = "1,1"
finish_default = "31,39"
bias_default = "1358"

start = parse_coords(start_default)
finish = parse_coords(finish_default)
bias = parse_bias(bias_default)

OptionParser.parse do |parser|
  parser.on "-h", "--help", "Show option help" do
    puts parser
    exit
  end
  parser.on("-s X,Y", "--start=X,Y",
            "Set start coordinates (default: #{start_default})") do |text|
    start = parse_coords(text)
  end
  parser.on("-f X,Y", "--finish=X,Y",
            "Set finish coordinates (default: #{finish_default})") do |text|
    finish = parse_coords(text)
  end
  parser.on("-b BIAS", "--bias=BIAS",
            "Set bias (default: #{bias_default})") do |text|
    bias = parse_bias(text)
  end
end

print "Shortest (BFS) distance from #{pretty_coords(start)} to" +
      " #{pretty_coords(finish)} (bias=#{bias}) is: "
STDOUT.flush

puts bfs(start, finish, bias)
