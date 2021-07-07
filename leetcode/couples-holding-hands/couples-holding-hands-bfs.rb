# LeetCode 765 - Couples Holding Hands
# https://leetcode.com/problems/couples-holding-hands/
# By BFS, on the graph of seat-pair buckets.
# (Vertices are all degree 2, so each component is a cycle.)

# @param {Integer[]} row
# @return {Integer}
def min_swaps_couples(row)
  graph = build_graph(row)
  graph.vertex_count - graph.count_components
end

def build_graph(row)
  graph = Graph.new(row.size / 2)
  row.each_slice(2) { |a, b| graph.add_edge(a / 2, b / 2) }
  graph
end

# An unweighted undirected graph. (Permits loops and parallel edges.)
class Graph
  def initialize(vertex_count)
    @adj = Array.new(vertex_count) { [] }
  end

  def vertex_count
    @adj.size
  end

  def add_edge(u, v)
    raise 'vertex count of range' unless exists?(u) && exists?(v)
    @adj[u] << v
    @adj[v] << u
    nil
  end

  def count_components
    vis = [false] * vertex_count
    queue = []

    bfs = lambda do |start|
      return false if vis[start]

      vis[start] = true
      queue << start

      until queue.empty?
        @adj[queue.shift].each do |dest|
          next if vis[dest]

          vis[dest] = true
          queue << dest
        end
      end

      true
    end

    (0...vertex_count).count(&bfs)
  end

  private

  def exists?(vertex)
    vertex.between?(0, vertex_count - 1)
  end
end
