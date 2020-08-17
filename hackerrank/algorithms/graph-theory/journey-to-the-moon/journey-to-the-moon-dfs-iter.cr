# https://www.hackerrank.com/challenges/journey-to-the-moon
# In Crystal. Using iterative depth-first search.

require "bit_array"

# Adjacency-list representation of an unweighted undirected graph.
class Graph
  @adj : Array(Array(Int32))

  def initialize(order : Int32)
    @adj = (0...order).map { [] of Int32 }
  end

  def add_edge(u, v)
    raise IndexError.new("edge u is out of range") unless exists?(u)
    raise IndexError.new("edge v us out of range") unless exists?(v)
    @adj[u] << v
    @adj[v] << u
  end

  # Counts vertices in each component.
  def component_orders
    vis = BitArray.new(@adj.size)
    (0...@adj.size)
      .each
      .reject { |start| vis[start] }
      .map { |start| dfs(vis, start) }
  end

  private def dfs(vis, start)
    raise "Bug: start vertex already visited" if vis[start]
    vis[start] = true
    stack = [start]
    count = 1

    until stack.empty?
      @adj[stack.pop].each do |dest|
        next if vis[dest]
        vis[dest] = true
        stack.push(dest)
        count += 1
      end
    end

    count
  end

  private def exists?(vertex)
    0 <= vertex < @adj.size
  end
end

def read_record
  gets.as(String).split.map(&.to_i)
end

def read_graph
  vertex_count, edge_count = read_record
  graph = Graph.new(vertex_count)

  edge_count.times do
    u, v = read_record
    graph.add_edge(u, v)
  end

  graph
end

def count_pairs(cardinalities)
  singles = pairs = 0i64

  cardinalities.each do |cardinality|
    pairs += singles * cardinality
    singles += cardinality
  end

  pairs
end

puts count_pairs(read_graph.component_orders)
