#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/merging-communities

$VERBOSE = 1

# Disjoint-set union (union-find) data structure Offers O(1) size computation.
class DisjointSets
  def initialize(count)
    @parents = (0...count).to_a
    @sizes = Array.new(count, 1)
  end

  def size(elem)
    @sizes[find_set(elem)]
  end

  def union(elem1, elem2)
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

  private

  def join(parent, child)
    @parents[child] = parent
    @sizes[parent] += @sizes[child]
  end

  def find_set(elem)
    raise IndexError, 'no such element' unless exists?(elem)

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
    elem.between?(0, @parents.size - 1)
  end
end

if __FILE__ == $PROGRAM_NAME
  vertex_count, query_count = gets.split.map(&:to_i)
  sets = DisjointSets.new(vertex_count + 1) # +1 for 1-based indexing

  query_count.times do
    tokens = gets.split
    case tokens[0]
    when 'M'
      sets.union(tokens[1].to_i, tokens[2].to_i)
    when 'Q'
      puts sets.size(tokens[1].to_i)
    else
      raise "Unrecognized query type: #{tokens[0]}"
    end
  end
end
