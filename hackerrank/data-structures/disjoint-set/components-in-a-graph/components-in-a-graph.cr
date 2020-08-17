# https://www.hackerrank.com/challenges/components-in-graph

# Disjoint-set union (union-find) data structure. Offers O(1) size computation.
class DisjointSets
  @parents : Array(Int32)
  @sizes : Array(Int32)

  def initialize(count : Int32)
    @parents = (0...count).to_a
    @sizes = Array(Int32).new(count, 1)
  end

  def cardinalities
    (0...@parents.size)
      .each
      .select { |elem| elem == @parents[elem] }
      .map { |elem| @sizes[elem] }
  end

  def union(elem1 : Int32, elem2 : Int32)
    # Find the ancestors and stop if they are already the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return if elem1 == elem2

    # Unite by size.
    if @sizes[elem1] < @sizes[elem2]
      join(elem2, elem1)
    else
      join(elem1, elem2)
    end
  end

  private def join(parent, child)
    @parents[child] = parent
    @sizes[parent] += @sizes[child]
    nil
  end

  private def find_set(elem)
    raise IndexError.new("no such element") unless 0 <= elem < @parents.size

    # Find the ancestor.
    leader = elem
    while leader != @parents[leader]
      leader = @parents[leader]
    end

    # Compress the path.
    while elem != leader
      parent = @parents[elem]
      @parents[elem] = leader
      elem = parent
    end

    leader
  end
end

n = gets.as(String).to_i
sets = DisjointSets.new(n * 2 + 1) # +1 for 1-based indexing

n.times do
  i, j = gets.as(String).split.map(&.to_i)
  sets.union(i, j)
end

min, max = sets.cardinalities.select { |size| size > 1 }.minmax
puts "#{min} #{max}"
