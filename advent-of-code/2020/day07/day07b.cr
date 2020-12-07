# Advent of Code 2020, day 7, part B

# A single-value type representing positive infinity.
struct Infinity
end

# A weighted directed graph with no parallel edges.
class Graph(T)
  def add_edge(src : T, dest : T, weight : Int64)
    if weight <= 0i64
      raise ArgumentError.new("Weight #{weight} is not strictly positive.")
    end

    row = @adj[src]

    if row.has_key?(dest)
      raise KeyError.new("Edge #{src} -> #{dest} already exists.")
    end

    row[dest] = weight
  end

  def sum_paths(start : T) : (Int64 | Infinity)
    memo = Hash(T, Int64?).new
    do_sum_paths(memo, start) || Infinity.new
  end

  private def do_sum_paths(memo : Hash(T, Int64?), src : T) : Int64?
    return memo[src] if memo.has_key?(src)
    
    memo[src] = nil # To detect cycles and return nil if one is encountered.
    src_cost = 1i64

    @adj[src].each do |dest, weight|
      dest_cost = do_sum_paths(memo, dest)
      return nil if dest_cost.nil?
      src_cost += dest_cost * weight
    end

    memo[src] = src_cost
  end

  @adj = Hash(T, Hash(T, Int64)).new { |h, k| h[k] = Hash(T, Int64).new }
end

def each_inner_color_with_count(inner_info, &block)
  return if inner_info == "no other bags"

  inner_fields = inner_info.split(", ")
  if inner_fields.empty?
    raise %q{Malformed rule: empty list must be written as "no other bags"}
  end

  inner_color_counts = inner_fields.map do |field|
    unless field =~ /^(\d+) \b(.+)\b bags?$/
      raise "Malformed rule: wrong field format"
    end

    _, digits, color = $~
    count = digits.to_i64
    raise "Bad rule: zero-count containment unsupported" if count.zero?

    {color, count}
  end

  inner_color_counts.each { |color, count| yield(color, count) }
end

def build_bag_graph(io)
  graph = Graph(String).new

  io.each_line.map(&.strip).reject(&.empty?).each do |line|
    unless line =~ /^\b(.+)\b bags contain \b(.+)\b\.$/
      raise "Malformed rule: unrecognized format"
    end
    _, outer_color, inner_info = $~

    each_inner_color_with_count(inner_info) do |inner_color, inner_count|
      graph.add_edge(src: outer_color, dest: inner_color, weight: inner_count)
    end
  end

  graph
end

case bag_count = build_bag_graph(ARGF).sum_paths("shiny gold")
when Int64
  puts bag_count - 1i64
  exit 0
when Infinity
  puts "Infinity"
  exit 1
end
