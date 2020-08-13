#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/kruskalmstrsub - Kruskal's algorithm

$VERBOSE = 1

# Disjoint-set data structure implementing the union-find algorithm.
class DisjointSets
  # Performs *count* make-set operations, creating elements [0, count).
  def initialize(count)
    @elems = [-1] * count
  end

  # Union-by-rank with full path compression. Returns true iff *elem1* and
  # *elem2* started out in different sets (which thus had to be merged).
  def union(elem1, elem2)
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

  private

  def find_set(elem)
    raise IndexError, 'specified element does not exist' unless exists?(elem)

    # Find the ancestor.
    leader = elem
    leader = @elems[leader] while @elems[leader] >= 0

    # Compress the path.
    while elem != leader
      parent = @elems[elem]
      @elems[elem] = leader
      elem = parent
    end

    leader
  end

  def exists?(elem)
    elem.between?(0, @elems.size - 1)
  end
end

def read_record
  gets.split.map(&:to_i)
end

if __FILE__ == $PROGRAM_NAME
  vertex_count, edge_count = read_record
  sets = DisjointSets.new(vertex_count + 1) # +1 for 1-based indexing

  (1..edge_count)
    .map { read_record }
    .sort_by! { |_u, _v, weight| weight }
    .select { |u, v, _weight| sets.union(u, v) }
    .sum { |_u, _v, weight| weight }
    .tap { |total| puts total }
end
