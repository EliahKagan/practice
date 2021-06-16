# LeetCode #1579 - Remove Max Number of Edges to Keep Graph Fully Traversable
# https://leetcode.com/problems/remove-max-number-of-edges-to-keep-graph-fully-traversable/
# Modified Kruskal's algorithm. Takes shared edges first, then copies the DSU.

# Computes the most edges that can be removed, keeping full connectivity for
# Alice and Bob. Returns -1 if the graph was not fully connected.
# @param {Integer} n
# @param {Integer[][]} edges
# @return {Integer}
def max_num_edges_to_remove(n, edges)
  count = min_spanning_edges(n, group_edges(edges))
  count ? edges.size - count : -1
end

# Computes the minimum number of edges needed to achieve full connectivity for
# both Alice and Bob.
def min_spanning_edges(vertex_count, groups)
  # Pick up edges both Alice and Bob can use, giving them to both.
  alice_sets = DisjointSets.new(vertex_count)
  alice_bob_count = connect(alice_sets, groups[:alice_bob])
  bob_sets = alice_sets.dup

  # Pick up edges only Alice can use. Bail if Alice is still stranded.
  alice_count = connect(alice_sets, groups[:alice])
  return nil if alice_bob_count + alice_count + 1 < vertex_count

  # Pick up edges only Bob can use. Bail if Bob is still stranded.
  bob_count = connect(bob_sets, groups[:bob])
  return nil if alice_bob_count + bob_count + 1 < vertex_count

  alice_bob_count + alice_count + bob_count
end

# Adds connections due to edges.
# Returns the number of edges that improved connectivity.
def connect(sets, edges)
  return 0 unless edges

  count = 0

  edges.each do |(u, v)|
    break if sets.set_count < 2
    count += 1 if sets.union(u, v)
  end

  count
end

# Groups type-annotated edges by symbolic type, as unannotated edges.
def group_edges(edges)
  edges.group_by { |(type, _u, _v)| get_group_symbol(type) }
       .each { |_, group| group.map! { |(_, u, v)| [u, v] } }
end

def get_group_symbol(type)
  case type
  when 1
    :alice
  when 2
    :bob
  when 3
    :alice_bob
  else
    raise "unrecognized edge type: #{type}"
  end
end

# Disjoint-set-union data structure for union-find algorithm.
# Elements are 1-based.
class DisjointSets
  # The number of (separate) sets.
  attr_reader :set_count

  # Creates element_count singletons.
  def initialize(element_count)
    @elems = [-1] * (element_count + 1)
    @set_count = element_count
  end

  # Allow DisjointSets to work intuitively with dup and clone.
  def initialize_copy(sets)
    super
    @elems = sets.elems.dup
    @set_count = sets.set_count
  end

  # Union by rank with path compression.
  # Returns true iff the sets started separate (and were joined).
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

      # elem1 has superior (more negative) rank. Use it as the parent.
      @elems[elem2] = elem1
    end

    @set_count -= 1
    true
  end

  protected

  attr_reader :elems

  private

  def exists(elem)
    elem.between?(1, @elems.size - 1)
  end

  def find_set(elem)
    raise "element #{elem} out of range" unless exists(elem)
    do_find_set(elem)
  end

  def do_find_set(elem)
    return elem if @elems[elem].negative?

    ancestor = do_find_set(@elems[elem])
    @elems[elem] = ancestor
    ancestor
  end
end
