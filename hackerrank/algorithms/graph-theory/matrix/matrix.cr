# Matrix
# https://www.hackerrank.com/challenges/matrix/problem

# Union-find data structure with a notion of heat:
# (1) As specified by the user, some ELEMENTS may be hot (and others cold).
# (2) Call a SET hot iff one or more of its elements is hot.
# (3) Call the ACT of uniting two sets hot iff it joins two separate hot sets.
class HeatTrackingDisjointSets
  # Performs heat_bits.size makeset operations, where element i is hot if
  # heat_bits[i] is true (and cold otherwise).
  def initialize(heat_bits)
    @heats = heat_bits.dup
    @parents = (0...@heats.size).to_a
    @ranks = [0] * @heats.size
  end

  # Union by rank. Returns true iff this operation was hot (see above).
  def union(elem1, elem2)
    # Find the ancestors and stop if they are already the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return false if elem1 == elem2

    # The ACT of uniting two sets is hot when BOTH of them were hot.
    hot_bridge = @heats[elem1] && @heats[elem2]

    # Union by rank.
    if @ranks[elem1] < @ranks[elem2]
      join(parent: elem2, child: elem1)
    else
      @ranks[elem1] += 1 if @ranks[elem1] == @ranks[elem2]
      join(parent: elem1, child: elem2)
    end

    hot_bridge
  end

  # Finds a set's representative element. Performs full path compression.
  private def find_set(elem)
    if @parents[elem] == elem
      elem
    else
      @parents[elem] = find_set(@parents[elem])
    end
  end

  # Joins the child to the parent, setting the parent's heat.
  private def join(parent, child)
    @parents[child] = parent

    # The RESULT of a union is hot when EITHER set was hot.
    @heats[parent] ||= @heats[child]
  end

  @heats : Array(Bool)
  @parents : Array(Int32)
  @ranks : Array(Int32)
end

# A weighted undirected edge.
struct Edge
  getter u : Int32
  getter v : Int32
  getter weight : Int32

  def initialize(@u, @v, @weight)
  end
end

# Reads a line as a single integer.
def read_value
  gets.as(String).to_i
end

# Reads a line as a sequence of integers.
def read_record
  gets.as(String).split.map(&.to_i)
end

# Read the problem parameters.
city_count, machine_count = read_record

# Read the edges (roads). Each road's time to destroy is its edge weight.
roads = Array(Edge).new(city_count - 1) do
  u, v, weight = read_record
  Edge.new(u, v, weight)
end

# Read if each vertex (city) has is hot (has a machine) or cold (no machine).
heats = [false] * city_count
machine_count.times { heats[read_value] = true }
sets = HeatTrackingDisjointSets.new(heats)

# Taking edges by descending weight, sum weights that connect hot components.
puts roads.sort! { |lhs, rhs| rhs.weight <=> lhs.weight }
          .each
          .select { |edge| sets.union(edge.u, edge.v) }
          .sum(&.weight)
