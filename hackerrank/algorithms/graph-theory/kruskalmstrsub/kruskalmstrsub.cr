# https://www.hackerrank.com/challenges/kruskalmstrsub - Kruskal's algorithm

# Disjoint-set data structure implementing the union-find algorithm.
class DisjointSets
  @elems : Array(Int32)

  # Performs *count* make-set operations, creating elements [0, count).
  def initialize(count : Int32)
    @elems = [-1] * count
  end

  # Union-by-rank with full path compression. Returns true iff *elem1* and
  # *elem2* started out in different sets (which thus had to be merged).
  def union(elem1 : Int32, elem2 : Int32)
    # Find the ancestors and stop if they are already the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return false if elem1 == elem2

    # Unite by rank.
    if @elems[elem1] > @elems[elem2]
      # elem2 has superior (more negative) rank, so it will be the parent.
      @elems[elem1] = elem2
    else
      # If they have the same rank, promote elem1.
      @elems[elem1] -= 1 if @elems[elem1] == @elems[elem2]

      # elem1 has superior (more negative) rank, so it will be the parent.
      @elems[elem2] = elem1
    end

    true
  end

  private def find_set(elem)
    unless 0 <= elem < @elems.size
      raise IndexError.new("specified element does not exist")
    end

    # Find the ancestor.
    leader = elem
    while @elems[leader] >= 0
      leader = @elems[leader]
    end

    # Compress the path.
    while elem != leader
      parent = @elems[elem]
      @elems[elem] = leader
      elem = parent
    end

    leader
  end
end

def read_record
  gets.as(String).split.map(&.to_i)
end

vertex_count, edge_count = read_record
sets = DisjointSets.new(vertex_count + 1) # +1 for 1-based indexing

(1..edge_count)
  .map { read_record }
  .sort_by! { |(u, v, weight)| weight }
  .select { |(u, v, weight)| sets.union(u, v) }
  .sum { |(u, v, weight)| weight }
  .tap { |total| puts total }
