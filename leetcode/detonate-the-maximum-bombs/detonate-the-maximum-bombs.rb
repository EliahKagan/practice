# LeetCode #2101 - Detonate the Maximum Bombs
# https://leetcode.com/problems/detonate-the-maximum-bombs/
#
# The technique used is:
#
# (1) Build an unweighted directed graph where there is an edge (u, v) if
#     detonating u directly causes v to be detonated.
#
# (2) Run Kosaraju's algorithm to find the strongly connected components.
#
# (3) Contract the strongly connected components to form a weighted metagraph,
#     where the weight of each vertex is the population of the strongly
#     connected component it represents.
#
# (4) This metagraph is a DAG. Linearize it and update each of its vertices
#     with sets of reachable vertices in topological order (similar to finding
#     shortest paths in a DAG, but with bitsets and bitwise OR), thereby
#     computing metagraph's transitive closure. Sum total reachable weights.

# @param {Integer[][]} bombs
# @return {Integer}
def maximum_detonation(bombs)
  graph = build_graph(bombs)
  Metagraph.new(graph, graph.kosaraju).dag_reachable_total_weights.max
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

# Extensions to Integer to support using it as a bitfield.
class Integer
  # The indices of bits that are 1 rather than 0. Invalid on negative values.
  def bit_support
    raise ArgumentError('set bits undefined for negatives') if self.negative?

    support = []

    value = self
    index = 0
    until value.zero?
      support << index if value & 1
      value >>= 1
      index += 1
    end

    support
  end
end

# An unweighted directed graph.
# Supports finding strongly connected components.
class Graph
  # Creates a graph with vertices 0, ..., vertex_count - 1, and no edges.
  def initialize(vertex_count)
    @out_adj = Array.new(vertex_count) { [] }
    @in_adj = Array.new(vertex_count) { [] }
  end

  # The number of vertices in the graph.
  def order
    @out_adj.size
  end

  # Adds the directed edge (src, dest) to the graph.
  def add_edge(src, dest)
    raise 'source endpoint out of range' unless exists?(src)
    raise 'destination endpoint out of range' unless exists?(dest)

    @out_adj[src] << dest
    @in_adj[dest] << src
    nil
  end

  # Runs a block for each edge in this graph.
  def each_edge
    @out_adj.each_with_index do |row, src|
      row.each { |dest| yield src, dest }
    end
    nil
  end

  # Gets an array of all edges in this graph.
  def all_edges
    edges = []

    @out_adj.each_with_index do |row, src|
      row.each { |dest| edges << [src, dest] }
    end

    edges
  end

  # Run Kosaraju's algorithm to find strongly connected components.
  def kosaraju
    vis = Set.new
    stack = []

    populate_stack = lambda do |src|
      return if vis.include?(src)

      vis << src
      @out_adj[src].each(&populate_stack)
      stack << src
      nil
    end

    (0...order).each(&populate_stack)

    groups = []

    populate_group = lambda do |group, dest|
      return unless vis.include?(dest)

      vis.delete(dest)
      @in_adj[dest].each { |src| populate_group.call(group, src) }
      nil
    end

    until stack.empty?
      group = []
      populate_group.call(group, stack.pop)
      groups << group
    end

    groups
  end

  private

  def exists?(vertex)
    vertex.between?(0, order - 1)
  end
end

# A vertex-weighted edge-unweighted directed graph.
# Represents a graph after contractions. Weights are populations.
class Metagraph
  # Creates a metagraph from a graph and groups of vertices in it.
  # The metagraph's vertices are 0, ..., groups.size - 1.
  def initialize(graph, groups)
    @adj = Array.new(groups.size) { [] }
    @weights = groups.map(&:size)

    populate_from(graph, groups)
  end

  def order
    @adj.size
  end

  # Finds total weights reachable from each vertex. Invalid on cyclic graphs.
  def dag_reachable_total_weights
    dag_reachable.map { |reach| reach.reduce(0) { |a, e| a + @weights[e] } }
  end

  private

  # Computes the transitive closure of this graph as an adjacency list. The
  # ith row contains j iff j is reachable from i. Assumes the graph is acyclic.
  def dag_reachable
    reaches = Array.new(order, nil)

    each_vertex_reverse_toposort do |src|
      reaches[src] = @adj[src]
        .map { |dest| reaches[dest] }
        .reduce(1 << src, :|)
    end

    reaches.map(&:bit_support)
  end

  # Yields vertices in reverse topological order via DFS.
  # The graph is assumed to be acyclic. Cycle-checking is not performed.
  def each_vertex_reverse_toposort
    vis = Set.new

    dfs = lambda do |src|
      return if vis.include?(src)

      vis << src
      @adj[src].each(&dfs)
      yield src
    end

    (0...order).each(&dfs)
    nil
  end

  # Adds meta-edges based on the original graph's edges.
  def populate_from(graph, groups)
    lookup = make_meta_lookup(graph, groups)
    seen = Set.new

    graph.each_edge do |src, dest|
      metasrc = lookup[src]
      metadest = lookup[dest]
      next if metasrc == metadest

      metaedge = [metasrc, metadest].freeze
      next if seen.include?(metaedge)

      seen << metaedge
      @adj[metasrc] << metadest
    end

    nil
  end

  # Creates an array that maps original vertices to metagraph vertices.
  def make_meta_lookup(graph, groups)
    lookup = Array.new(graph.order, nil)

    groups.each_with_index do |group, metavertex|
      group.each { |vertex| lookup[vertex] = metavertex }
    end

    lookup
  end
end
