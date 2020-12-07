# Advent of Code, day 7, part A

class Graph(T)
  def add_edge(src : T, dest : T)
    @adj[src] << dest
  end

  def compute_reach(start : T)
    vis = Set(T).new
    collect_reachable(vis, start)
    vis.size - 1
  end

  private def collect_reachable(vis, src)
    return if vis.includes?(src)
    vis << src
    @adj[src].each { |dest| collect_reachable(vis, dest) }
  end

  @adj = Hash(T, Set(T)).new { |h, k| h[k] = Set(T).new }
end

def each_inner_color(inner_info, &block)
  return if inner_info == "no other bags"

  inner_fields = inner_info.split(", ")
  if inner_fields.empty?
    raise %q{Malformed rule: empty list must be written as "no other bags"}
  end

  inner_colors = inner_fields.map do |field|
    unless field =~ /^(\d+) \b(.+)\b bags?$/
      raise "Malformed rule: wrong field format"
    end
    
    _, count, inner_color = $~
    raise "Bad rule: zero-count containment unsupported" if count.to_i.zero?

    inner_color
  end

  inner_colors.each { |inner_color| yield inner_color }
end

def build_bag_graph(io)
  graph = Graph(String).new

  io.each_line.map(&.strip).reject(&.empty?).each do |line|
    unless line =~ /^\b(.+)\b bags contain \b(.+)\b\.$/
      raise "Malformed rule: unrecognized format" 
    end
    _, outer_color, inner_info = $~

    each_inner_color(inner_info) do |inner_color|
      graph.add_edge(src: inner_color, dest: outer_color)
    end
  end

  graph
end

puts build_bag_graph(ARGF).compute_reach("shiny gold")
