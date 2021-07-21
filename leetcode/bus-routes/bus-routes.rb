# LeetCode #815 - Bus Routes
# https://leetcode.com/problems/bus-routes/
# By BFS on the undirected bipartite graph of buses and bus stops.

# @param {Integer[][]} routes
# @param {Integer} source
# @param {Integer} target
# @return {Integer}
def num_buses_to_destination(routes, source, target)
  graph = build_graph(routes)

  bus_bias = graph.order - routes.size
  STDERR.puts "bus_bias=#{bus_bias}, source=#{source}, target=#{target}"
  raise 'source stop is out of range' unless source.between?(0, bus_bias - 1)
  raise 'target stop is out of range' unless target.between?(0, bus_bias - 1)

  bi_distance = graph.bfs(source, target)
  return -1 unless bi_distance

  raise 'bug: even-length route expected, got odd' if bi_distance.odd?
  bi_distance / 2
end

# Builds the undirected bipartite graph of buses and bus stops.
def build_graph(routes)
  bus_bias = routes.lazy.flat_map(&:itself).max + 1
  graph = Graph.new(bus_bias + routes.size)

  routes.each_with_index do |stops, bus|
    bus_vertex = bus_bias + bus
    stops.each { |stop| graph.add_edge(bus_vertex, stop) }
  end

  graph
end

# An unweighted undirected graph supporting breadth-first search.
class Graph
  def initialize(order)
    @adj = Array.new(order) { [] }
  end

  def order
    @adj.size
  end

  def add_edge(u, v)
    raise 'vertex u is out of range' unless exists?(u)
    raise 'vertex v is out of range' unless exists?(v)

    @adj[u] << v
    @adj[v] << u
  end

  # Searches breadth-first from start to finish, returning the minimum
  # distance, or nil if finish is not reachable from start.
  def bfs(start, finish)
    raise 'start vertex out of range' unless exists?(start)
    raise 'finish vertex out of range' unless exists?(finish)

    do_bfs(start, finish)
  end

  private

  def exists?(vertex)
    vertex.between?(0, order - 1)
  end

  def do_bfs(start, finish)
    vis = [false] * order
    vis[start] = true
    queue = [start]

    (0..).each do |breadth|
      return nil if queue.empty?

      queue.size.times do
        src = queue.shift
        return breadth if src == finish

        @adj[src].each do |dest|
          next if vis[dest]

          vis[dest] = true
          queue << dest
        end
      end
    end
  end
end
