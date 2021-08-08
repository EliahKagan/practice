# LeetCode #1631 - Path With Minimum Effort
# https://leetcode.com/problems/path-with-minimum-effort/
# By bisecting over capped-edge-weight DFS (iterative).

require 'set'

# @param {Integer[][]} heights
# @return {Integer}
def minimum_effort_path(heights)
  graph = build_graph(heights)
  graph.minimize_max_edge_weight(0, graph.order - 1)
end

def build_graph(heights)
  m = heights.size
  n = heights.first.size
  graph = Graph.new(m * n)

  0.upto(m - 1) do |i|
    0.upto(n - 1) do |j|
      if j + 1 != n
        graph.add_edge(n * i + j,
                       n * i + j + 1,
                       (heights[i][j] - heights[i][j + 1]).abs)
      end
      if i + 1 != m
        graph.add_edge(n * i + j,
                       n * (i + 1) + j,
                       (heights[i][j] - heights[i + 1][j]).abs)
      end
    end
  end

  graph
end

# A weighted undirected graph.
class Graph
  def initialize(order)
    @adj = Array.new(order) { [] }
    @weights = Set.new
  end

  def order
    @adj.size
  end

  def add_edge(u, v, weight)
    raise 'edge vertex out of range' unless exists?(u) && exists?(v)

    @adj[u] << [v, weight]
    @adj[v] << [u, weight]
    @weights << weight
    nil
  end

  def minimize_max_edge_weight(start, finish)
    raise 'vertex out of range' unless exists?(start) && exists?(finish)

    return 0 if start == finish

    ret = @weights.sort.bsearch { |weight| dfs(start, finish, weight) }
    raise 'destination vertex not reachable' unless ret

    ret
  end

  private

  def exists?(vertex)
    vertex.between?(0, order - 1)
  end

  def dfs(start, finish, max_weight)
    raise "dfs helper expects start and finish to differ" if start == finish

    vis = [false] * order
    vis[start] = true
    stack = [start]

    until stack.empty?
      @adj[stack.pop].each do |dest, weight|
        next if vis[dest] || weight > max_weight

        return true if dest == finish

        vis[dest] = true
        stack << dest
      end
    end

    false
  end
end
