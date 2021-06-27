# LeetCode #684 - Redundant Connection
# https://leetcode.com/problems/redundant-connection/
# By union-find.

# @param {Integer[][]} edges
# @return {Integer[]}
def find_redundant_connection(edges)
  sets = DisjointSets.new(edges.size + 1) # +1 for 1-based indexing
  edges.find { |u, v| !sets.union(u, v) }
end

# A disjoint-set union data structure, for union-find.
class DisjointSets
  def initialize(element_count)
    @elems = [-1] * element_count
  end

  # Returns true if the sets started out separate, false if they were the same.
  def union(elem1, elem2)
    # Find the ancestors and stop if they are already the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return false if elem1 == elem2

    # Unite by rank.
    if @elems[elem1] > @elems[elem2]
      # elem2 has superior (more negative) rank. Use it as the parent.
      @elems[elem1] = elem2
    else
      # If they have the same rank, promote elem1.
      @elems[elem1] -= 1 if @elems[elem1] == @elems[elem2]

      # elem1 has superore (more negative) rank. Use it as the parent.
      @elems[elem2] = elem1
    end

    true
  end

  private

  def find_set(elem)
    raise 'element of of range' unless exists(elem)

    # Find the ancestor.
    leader = elem
    leader = @elems[leader] until @elems[leader].negative?

    # Compress the path.
    while elem != leader
      parent = @elems[elem]
      @elems[elem] = leader
      elem = parent
    end

    leader
  end

  def exists(elem)
    elem.between?(0, @elems.size - 1)
  end
end
