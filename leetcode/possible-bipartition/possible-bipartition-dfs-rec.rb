# LeetCode #886 - Possible Bipartition
# https://leetcode.com/problems/possible-bipartition/
# By recursive DFS.

# @param {Integer} n
# @param {Integer[][]} dislikes
# @return {Boolean}
def possible_bipartition(n, dislikes)
  build_graph(n, dislikes).bipartite?
end

def build_graph(order, edges)
  graph = Graph.new(order)
  edges.each { |u, v| graph.add_edge(u, v) }
  graph
end

# An unweighted undirected graph.
class Graph
  def initialize(order)
    @adj = Array.new(order + 1) { [] }
    @adj[0] = nil
  end

  def add_edge(u, v)
    raise 'vertex out of range' unless exists?(u) && exists?(v)

    @adj[u] << v
    @adj[v] << u
    nil
  end

  def bipartite?
    vis = [nil] * (order + 1)

    dfs = lambda do |src, color|
      return vis[src] == color if vis[src]

      vis[src] = color
      dest_color = other_color(color)
      @adj[src].all? { |dest| dfs.call(dest, dest_color) }
    end

    (1..order).all? { |start| vis[start] || dfs.call(start, :red) }
  end

  private

  def order
    @adj.size - 1
  end

  def exists?(vertex)
    vertex.between?(1, order)
  end

  def other_color(color)
    case color
    when :red
      :blue
    when :blue
      :red
    else
      raise "unrecognized color: #{color}"
    end
  end
end
