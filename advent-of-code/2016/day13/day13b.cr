# Advent of Code 2016, day 13, part B

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

def bfs(start : {T, T}, maxdepth, &can_go) forall T
  return 0 if maxdepth < 0

  vis = Set{start}
  queue = Deque{start}

  maxdepth.times do
    break if queue.empty? # A simple optimization.

    queue.size.times do
      each_neighbor(queue.shift) do |dest|
        next unless yield(*dest) && !vis.includes?(dest)
        vis.add(dest)
        queue.push(dest)
      end
    end
  end

  vis.size
end

def bfs(start : {T, T}, maxdepth, can_go_bias) forall T
  bfs(start, maxdepth) do |x, y|
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

def parse_integer(label, text)
  text.to_i? || raise "can't parse as #{label} (integer): #{text.strip}"
end

start_default = "1,1"
maxdepth_default = "50"
bias_default = "1358"

start = parse_coords(start_default)
maxdepth = parse_integer("depth", maxdepth_default)
bias = parse_integer("bias", bias_default)

OptionParser.parse do |parser|
  parser.on "-h", "--help", "Show option help" do
    puts parser
    exit
  end
  parser.on("-s X,Y", "--start=X,Y",
            "Set start coordinates (default: #{start_default})") do |text|
    start = parse_coords(text)
  end
  parser.on("-D DEPTH", "--maxdepth=DEPTH",
            "Set maximum depth (default: #{maxdepth_default})") do |text|
    maxdepth = parse_integer("depth", text)
  end
  parser.on("-b BIAS", "--bias=BIAS",
            "Set bias (default: #{bias_default})") do |text|
    bias = parse_integer("bias", text)
  end
end

print "Locations from #{pretty_coords(start)}, maxdepth=#{maxdepth}" +
      " (BFS fill area): "
STDOUT.flush

puts bfs(start, maxdepth, bias)
