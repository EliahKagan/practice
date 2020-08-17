#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/kundu-and-tree

# Disjoint-set union (union-find) data structure. Offers O(1) size computation.
class DisjointSets
  def initialize(count)
    @parents = (0...count).to_a
    @sizes = Array.new(count, 1)
  end

  def cardinalities
    (0...@parents.size)
      .lazy
      .select { |elem| elem == @parents[elem] }
      .map { |elem| @sizes[elem] }
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
    nil
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

PERIOD = 1_000_000_007

def count_triples(sizes)
  singles = pairs = triples = 0

  sizes.each do |size|
    triples = (triples + pairs * size) % PERIOD
    pairs = (pairs + singles * size) % PERIOD
    singles = (singles + size) % PERIOD
  end

  triples
end

n = gets.to_i
sets = DisjointSets.new(n + 1) # +1 for 1-based indexing

(n - 1).times do
  u, v, color = gets.split
  if color == 'b'
    sets.union(u.to_i, v.to_i)
  elsif color != 'r'
    raise %(Color "#{color}" is neither red ("r") nor black ("b").)
  end
end

puts count_triples(sets.cardinalities.drop(1))
