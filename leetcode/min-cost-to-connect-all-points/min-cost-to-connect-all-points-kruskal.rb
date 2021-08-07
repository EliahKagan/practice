# LeetCode #1584 - Min Cost to Connect All Points
# https://leetcode.com/problems/min-cost-to-connect-all-points/
# By Kruskal's algorithm.

# @param {Integer[][]} points
# @return {Integer}
def min_cost_connect_points(points)
  sets = DisjointSets.new(points.size)
  acc = 0

  make_edges(points).sort_by! { |_u, _v, weight| weight }.each do |u, v, weight|
    acc += weight if sets.union(u, v)
  end

  acc
end

def make_edges(points)
  edges = []

  0.upto(points.size - 2) do |u|
    ux, uy = points[u]

    (u + 1).upto(points.size - 1) do |v|
      vx, vy = points[v]
      edges << [u, v, (ux - vx).abs + (uy - vy).abs]
    end
  end

  edges
end

# Disjoint-set data structure for union-find algorithm.
class DisjointSets
  def initialize(element_count)
    @elems = [-1] * element_count
  end

  # Unite two elements' sets. Returns true iff they were not already the same.
  def union(elem1, elem2)
    # Find the ancestors and stop if they are already the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return false if elem1 == elem2

    # Union by rank.
    if @elems[elem1] > @elems[elem2]
      # elem2 has superior (more negative) rank. It will be the parent.
      @elems[elem1] = elem2
    else
      # If they have the same rank, promote elem1.
      @elems[elem1] -= 1 if @elems[elem1] == @elems[elem2]

      # elem1 has superior (more negative) rank. It will be the parent.
      @elems[elem2] = elem1
    end

    true
  end

  private

  def find_set(elem)
    parent = @elems[elem]
    return elem if parent.negative?

    @elems[elem] = find_set(parent)
  end
end
