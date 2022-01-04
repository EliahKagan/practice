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
#     with weight sums of all reachable vertices, in topological order.
#     This is analogous to finding longest paths in a DAG, except the vertices
#     rather than the edges are weighted.

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

  # Builds a metagraph of vertices representing strongly connected components.
  def build_scc_metagraph
    markings, scc_count = kosaraju

    metaedges = Set.new
    @out_adj[src].each do |dest|
      metasrc = markings[src]
      metadest = markings[dest]
      metaedges << [metasrc, metadest].freeze if metasrc != metadest
    end

    metagraph = Graph.new(scc_count)
    metaedges.each { |src, dest| metagraph.add_edge(src, dest) }
    metagraph
  end

  private

  # Run Kosaraju's algorithm to find strongly connected components.
  # Returns component labelings, number of components.
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

    markings = Array.new(order, nil)

    mark_component = lambda do |dest, mark|
      return if markings[dest]

      markings[dest] = label
      @in_adj[dest].each { |src| mark_component.call(src, mark) }
      nil
    end

    mark = 0
    until stack.empty?
      populate_component.call(stack.pop, mark)
      mark += 1
    end

    [markings, mark]
  end
end
