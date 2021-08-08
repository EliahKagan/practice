# LeetCode #1631 - Path With Minimum Effort
# https://leetcode.com/problems/path-with-minimum-effort/
# By Kruskal's algorithm, returning the weight of the final edge.

# @param {Integer[][]} heights
# @return {Integer}
def minimum_effort_path(heights)
  m = heights.size
  n = heights.first.size
  return 0 if m == 1 && n == 1

  edges = []
  0.upto(m - 1) do |i|
    0.upto(n - 1) do |j|
      if j + 1 != n
        edges << [[i, j], [i, j + 1], (heights[i][j] - heights[i][j + 1]).abs]
      end
      if i + 1 != m
        edges << [[i, j], [i + 1, j], (heights[i][j] - heights[i + 1][j]).abs]
      end
    end
  end
  edges.sort_by! { |_u, _v, weight| weight }

  nodes = Array.new(m) { Array.new(n) { Node.new } }
  start = nodes.first.first
  finish = nodes.last.last

  edges.each do |(ui, uj), (vi, vj), weight|
    nodes[ui][uj].union(nodes[vi][vj])
    return weight if start.find_set == finish.find_set
  end

  raise 'bug: graph appears disconnected'
end

# A node for disjoint-set union operations.
class Node
  def initialize
    @parent = self
    @rank = 0
  end

  def find_set
    @parent = @parent.find_set if self != @parent
    @parent
  end

  def union(other)
    # Find the ancestors and stop if they are already the same.
    node1 = find_set
    node2 = other.find_set
    return if node1 == node2

    # Union by rank.
    if node1.rank < node2.rank
      node1.parent = node2
    else
      node1.rank += 1 if node1.rank == node2.rank
      node2.parent = node1
    end

    nil
  end

  protected

  attr_accessor :parent, :rank
end
