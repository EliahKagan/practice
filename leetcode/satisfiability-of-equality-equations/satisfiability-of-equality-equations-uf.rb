# LeetCode #990 - Satisfiability of Equality Equations
# https://leetcode.com/problems/satisfiability-of-equality-equations/
# By union-find.

# @param {String[]} equations
# @return {Boolean}
def equations_possible(equations)
  sets = DisjointSets.new(COUNT)

  equations.each do |e|
    sets.union(e[0].ord - BIAS, e[3].ord - BIAS) if e[1] == '='
  end

  equations.all? do |e|
    e[1] == '=' ||
        sets.find_set(e[0].ord - BIAS) != sets.find_set(e[3].ord - BIAS)
  end
end

COUNT = 26
BIAS = 'a'.ord
raise 'unexpected character set' unless 'z'.ord - BIAS + 1 == COUNT

# A disjoint-set union data structure, for union-find.
class DisjointSets
  def initialize(element_count)
    @elems = [-1] * element_count
  end

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

  def union(elem1, elem2)
    # Find the ancestors and stop if they are already the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return if elem1 == elem2

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
    nil
  end

  private

  def exists(elem)
    elem.between?(0, @elems.size - 1)
  end
end
