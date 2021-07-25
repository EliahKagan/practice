# LeetCode #1129 - Shortest Path with Alternating Colors
# https://leetcode.com/problems/shortest-path-with-alternating-colors/
# By BFS on a doubled bipartite graph.

NO_PATH = -1

# @param {Integer} n
# @param {Integer[][]} red_edges
# @param {Integer[][]} blue_edges
# @return {Integer[]}
def shortest_alternating_paths(n, red_edges, blue_edges)
  build_graph(n, red_edges, blue_edges)
    .bfs(0, n)
    .each_slice(n)
    .to_a
    .transpose
    .map { |distances| distances.compact.min || NO_PATH }
end

def build_graph(n, red_edges, blue_edges)
  graph = Graph.new(n * 2)

  red_edges.each do |src, dest|
    raise 'red-edge source out of range' unless src.between?(0, n - 1)
    raise 'red-edge destination out of range' unless dest.between?(0, n - 1)

    graph.add_edge(src, n + dest)
  end

  blue_edges.each do |src, dest|
    raise 'blue-edge source out of range' unless src.between?(0, n - 1)
    raise 'blue-edge destination out of range' unless dest.between?(0, n - 1)

    graph.add_edge(n + src, dest)
  end

  graph
end

# An unweighted directed graph supporting multi-source BFS to all vertices.
class Graph
  def initialize(order)
    @adj = Array.new(order) { [] }
  end

  def add_edge(src, dest)
    raise 'endpoint out of range' unless exists?(src) && exists?(dest)

    @adj[src] << dest
    nil
  end

  def bfs(*sources)
    raise 'source out of range' unless sources.all? { |src| exists?(src) }

    costs = [nil] * order
    sources.each { |src| costs[src] = 0 }

    (1..).each do |depth|
      return costs if sources.empty?

      sources.size.times do
        @adj[sources.shift].each do |dest|
          next if costs[dest]

          costs[dest] = depth
          sources << dest
        end
      end
    end
  end

  private

  def order
    @adj.size
  end

  def exists?(vertex)
    vertex.between?(0, order - 1)
  end
end
