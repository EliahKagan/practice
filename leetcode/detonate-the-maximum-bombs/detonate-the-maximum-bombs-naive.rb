# LeetCode #2101 - Detonate the Maximum Bombs
# https://leetcode.com/problems/detonate-the-maximum-bombs/
# Naive solution, counting reachable vertices from each vertex, via DFS.

# @param {Integer[][]} bombs
# @return {Integer}
def maximum_detonation(bombs)
  graph = build_graph(bombs)
  (0...graph.order).map { |start| graph.count_reachable(start) }.max
end

def build_graph(bombs)
  graph = Graph.new(bombs.size)

  bombs.each_with_index do |(src_x, src_y, src_r), src|
    r_squared = src_r**2

    bombs.each_with_index do |(dest_x, dest_y, _), dest|
      next if (src_x - dest_x)**2 + (src_y - dest_y)**2 > r_squared
      graph.add_edge(src, dest)
    end
  end

  graph
end

# An unweighted directed graph.
class Graph
  # Creates a graph with vertices 0, ..., vertex_count - 1, and no edges.
  def initialize(vertex_count)
    @adj = Array.new(vertex_count) { [] }
  end

  # The number of vertices in the graph.
  def order
    @adj.size
  end

  # Adds the directed edge (src, dest) to the graph.
  def add_edge(src, dest)
    raise 'source endpoint out of range' unless exists?(src)
    raise 'destination endpoint out of range' unless exists?(dest)

    @adj[src] << dest
    nil
  end

  # Counts how many vertices are reachable from a start vertex (including
  # the start vertex itself).
  def count_reachable(start)
    raise 'start vertex out of range' unless exists?(start)

    vis = Set.new

    dfs = lambda do |src|
      return if vis.include?(src)

      vis << src
      @adj[src].each(&dfs)
      nil
    end

    dfs.call(start)
    vis.size
  end

  private

  def exists?(vertex)
    vertex.between?(0, order - 1)
  end
end
