# LeetCode 1697 - Checking Existence of Edge Length Limited Paths

class DisjointSets
  def initialize(element_count)
    @parents = (0...element_count).to_a
    @ranks = [0] * element_count
  end

  def union(elem1, elem2)
    # Find the ancestors and stop if they are already the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return if elem1 == elem2

    # Unite by rank.
    if @ranks[elem1] < @ranks[elem2]
      @parents[elem1] = elem2
    else
      @ranks[elem1] += 1 if @ranks[elem1] == @ranks[elem2]
      @parents[elem2] = elem1
    end

    nil
  end

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
end

def each_ordered_indexed_query(queries)
  queries.each_with_index
         .sort_by { |(_start, _finish, limit), _index| limit }
         .each { |query, index| yield(query, index) }
  nil
end

# @param {Integer} n
# @param {Integer[][]} edge_list
# @param {Integer[][]} queries
# @return {Boolean[]}
def distance_limited_paths_exist(order, edges, queries)
  edges.sort_by! { |u, v, weight| weight }
  sets = DisjointSets.new(order)
  results = Array.new(queries.size)

  each_ordered_indexed_query(queries) do |(start, finish, limit), index|
    until edges.empty?
      u, v, weight = edges.first
      break unless weight < limit

      sets.union(u, v)
      edges.shift
    end

    results[index] = sets.find_set(start) == sets.find_set(finish)
  end

  results
end
