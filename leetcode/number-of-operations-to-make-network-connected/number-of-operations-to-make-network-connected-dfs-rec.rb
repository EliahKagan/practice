# LeetCode #1319 - Number of Operations to Make Network Connected
# https://leetcode.com/problems/number-of-operations-to-make-network-connected/
# By algebra, after counting components with recursive DFS.

# @param {Integer} n
# @param {Integer[][]} connections
# @return {Integer}
def make_connected(n, connections)
  return 0 if n.zero?

  graph = build_graph(n, connections)
  component_count = graph.count_components

  unavailable = graph.vertex_count - component_count
  available = graph.edge_count - unavailable
  changes_needed = component_count - 1
  available < changes_needed ? -1 : changes_needed
end

def build_graph(vertex_count, edges)
  graph = Graph.new(vertex_count)
  edges.each { |u, v| graph.add_edge(u, v) }
  graph
end

# An unweighted undirected graph.
class Graph
  attr_reader :edge_count

  def initialize(vertex_count)
    @adj = Array.new(vertex_count) { [] }
    @edge_count = 0
  end

  def vertex_count
    @adj.size
  end

  def add_edge(u, v)
    raise 'vertex u out of range' unless exists(u)
    raise 'vertex v out of range' unless exists(v)

    @adj[u] << v
    @adj[v] << u
    @edge_count += 1
    nil
  end

  def count_components
    vis = [false] * vertex_count

    fill = lambda do |src|
      return if vis[src]

      vis[src] = true
      @adj[src].each(&fill)
    end

    count = 0

    0.upto(vertex_count - 1) do |start|
      next if vis[start]

      count += 1
      fill.call(start)
    end

    count
  end

  private

  def exists(vertex)
    vertex.between?(0, vertex_count - 1)
  end
end
