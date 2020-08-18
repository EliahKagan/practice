# https://www.hackerrank.com/challenges/journey-to-the-moon
# In Crystal. Using union-find.

# Disjoint-set (union-find) data structure. Efficiently computes cardinalities.
class DisjointSets
  @elems : Array(Int32)

  def initialize(count : Int32)
    @elems = [-1] * count
  end

  def cardinalities
    @elems.each.select { |elem| elem < 0 }.map(&.-)
  end

  def union(elem1 : Int32, elem2 : Int32)
    # Find the ancestors and stop if they are the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return if elem1 == elem2

    # Unite by size.
    if @elems[elem2] < @elems[elem1]
      # elem2 has bigger (negatively stored) size.
      join(elem2, elem1)
    else
      # elem1 has bigger or the same (negatively stored) size.
      join(elem1, elem2)
    end
  end

  private def join(parent, child)
    @elems[parent] += @elems[child] # Augment the size of the parent.
    @elems[child] = parent          # Point the child to the parent.
    nil
  end

  private def find_set(elem)
    raise IndexError.new("no such element") unless 0 <= elem < @elems.size
    
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

def count_pairs(cardinalities)
  singles = pairs = 0i64

  cardinalities.each do |cardinality|
    pairs += singles * cardinality
    singles += cardinality
  end

  pairs
end

vertex_count, edge_count = read_record
sets = DisjointSets.new(vertex_count)

edge_count.times do
  u, v = read_record
  sets.union(u, v)
end

puts count_pairs(sets.cardinalities)
