# LeetCode #547 - Number of Provinces
# https://leetcode.com/problems/number-of-provinces/
# By union-find.

# @param {Integer[][]} is_connected
# @return {Integer}
def find_circle_num(is_connected)
  order = is_connected.size
  sets = DisjointSets.new(order)
  count = order

  0.upto(order - 2) do |u|
    (u + 1).upto(order - 1) do |v|
      count -= 1 if is_connected[u][v].nonzero? && sets.union(u, v)
    end
  end

  count
end

# A disjoint-set-union data structure for the union-find algorithm.
class DisjointSets
  def initialize(element_count)
    @parents = (0...element_count).to_a
    @ranks = [0] * element_count
  end

  # Joins the elements' sets. Returns true iff they started separate.
  def union(elem1, elem2)
    # Find the ancestors. Stop if they are already the same.
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

  def find_set(elem)
    # Find the ancestor.
    leader = elem
    leader = @parents[leader] while leader != @parents[leader]

    # Compress the path.
    while elem != leader
      parent = @parents[elem]
      @parents[elem] = leader
      elem = parent
    end

    leader
  end

  def exists?(elem)
    elem.between?(0, element_count - 1)
  end

  def element_count
    @parents.size
  end
end
