#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/journey-to-the-moon
# In Ruby. Using union-find.

# Disjoint-set (union-find) data structure. Efficiently computes cardinalities.
class DisjointSets
  def initialize(count)
    @elems = [-1] * count
  end

  def cardinalities
    @elems.lazy.select(&:negative?).map(&:-@)
  end

  def union(elem1, elem2)
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

  private

  def join(parent, child)
    @elems[parent] += @elems[child] # Augment the size of the parent.
    @elems[child] = parent          # Point the child to the parent.
    nil
  end

  def find_set(elem)
    raise IndexError, 'no such element' unless exists?(elem)

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

def count_pairs(cardinalities)
  singles = pairs = 0

  cardinalities.each do |cardinality|
    pairs += singles * cardinality
    singles += cardinality
  end

  pairs
end

if __FILE__ == $PROGRAM_NAME
  vertex_count, edge_count = read_record
  sets = DisjointSets.new(vertex_count)
  edge_count.times { sets.union(*read_record) }
  puts count_pairs(sets.cardinalities)
end
