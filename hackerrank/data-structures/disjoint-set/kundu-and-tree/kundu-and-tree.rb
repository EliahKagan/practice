#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/kundu-and-tree

$VERBOSE = 1

# An element of a set, for union-find.
class Element
  attr_reader :size

  def initialize
    @parent = self
    @size = 1
  end

  def union(other)
    # Find the ancestors and stop if they are the same.
    root1 = root
    root2 = other.root
    return if root1 == root2

    # Unite the sets by size.
    if root1.size < root2.size
      root2.adopt_child(root1)
    else
      root1.adopt_child(root2)
    end
  end

  attr_accessor :parent
  protected :parent
  protected :parent=

  attr_writer :size
  protected :size=

  protected

  def root
    @parent = @parent.root if @parent != self
    @parent
  end

  def adopt_child(child)
    @size += child.size
    child.size = 0
    child.parent = self
    nil
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
elems = Array.new(n + 1) { Element.new } # +1 for 1-based indexing

(n - 1).times do
  u, v, color = gets.split
  if color == 'b'
    elems[u.to_i].union(elems[v.to_i])
  elsif color != 'r'
    raise %(Color "#{color}" is neither red ("r") nor black ("b").)
  end
end

puts count_triples(elems.lazy.drop(1).map(&:size).reject(&:zero?))
