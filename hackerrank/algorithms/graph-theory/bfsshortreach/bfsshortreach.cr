# https://www.hackerrank.com/challenges/bfsshortreach

require "deque"

# An unweighted undirected graph.
class Graph
  def initialize(order)
    @adj = Array(Array(Int32)).new(order) { [] of Int32 }
  end

  def add_edge(u, v)
    check_vertex(u)
    check_vertex(v)

    @adj[u] << v
    @adj[v] << u
  end

  def bfs(start : Int32)
    check_vertex(start)

    costs = Array(Int32?).new(order, nil)
    costs[0] = depth = 0
    queue = Deque{start}

    until queue.empty?
      depth += 1

      queue.size.times do
        @adj[queue.shift].each do |dest|
          next if costs[dest]
          costs[dest] = depth
          queue.push(dest)
        end
      end
    end

    costs
  end

  def order
    @adj.size
  end

  private def check_vertex(vertex)
    raise ArgumentError.new("vertex out of range") unless 0 <= vertex < order
  end
end

EDGE_WEIGHT = 6
NO_PATH = -1

def read_value
  gets.as(String).to_i
end

def read_record
  gets.as(String).split.map(&.to_i)
end

def read_graph
  order, size = read_record
  graph = Graph.new(order + 1) # +1 for 1-based indexing

  size.times do
    u, v = read_record
    graph.add_edge(u, v)
  end

  graph
end

def print_scaled_costs(costs, start)
  output = (costs[1...start] + costs[(start + 1)..])
    .map { |cost| cost ? cost * EDGE_WEIGHT : NO_PATH }
    .join(' ')

  puts output
end

read_value.times do
  graph = read_graph
  start = read_value
  print_scaled_costs(graph.bfs(start), start)
end
