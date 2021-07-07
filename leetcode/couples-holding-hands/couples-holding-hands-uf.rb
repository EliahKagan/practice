# LeetCode 765 - Couples Holding Hands
# https://leetcode.com/problems/couples-holding-hands/
# By union-find, joining on edges of the graph of seat-pair buckets.
# (Vertices are all degree 2, so each component is a cycle.)

# @param {Integer[]} row
# @return {Integer}
def min_swaps_couples(row)
  sets = DisjointSets.new(row.size / 2)
  row.each_slice(2).count { |a, b| sets.union(a / 2, b / 2) }
end

# A disjoint-set union data structure for the union-find algorithm.
class DisjointSets
  def initialize(element_count)
    @parents = (0...element_count).to_a
    @ranks = [0] * element_count
  end

  # Joins two elements' containing sets. Returns true iff they were separate.
  def union(elem1, elem2)
    # Find the ancestors and stop if they are already the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return false if elem1 == elem2

    # Unite by rank.
    if @ranks[elem1] < @ranks[elem2]
      @parents[elem1] = elem2
    else
      @ranks[elem1] += 1 if @ranks[elem1] == @ranks[elem2]
      @parents[elem2] = elem1
    end

    true
  end

  private

  def element_count
    @parents.size
  end

  def exists?(elem)
    elem.between?(0, element_count - 1)
  end

  def find_set(elem)
    raise 'element out of range' unless exists?(elem)
    unchecked_findset(elem)
  end

  def unchecked_findset(elem)
    if elem == @parents[elem]
      elem
    else
      @parents[elem] = unchecked_findset(@parents[elem])
    end
  end
end
