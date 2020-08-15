#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/merging-communities

$VERBOSE = 1

# An element of a set, for union-find.
class Element
  def initialize
    @parent = self
    @size = 1
  end

  def cardinality
    root.size
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

  attr_accessor :size
  protected :size

  protected

  def root
    @parent = @parent.root if @parent != self
    @parent
  end

  def adopt_child(child)
    @size += child.size
    child.parent = self
    nil
  end
end

if __FILE__ == $PROGRAM_NAME
  element_count, query_count = gets.split.map(&:to_i)
  elements = Array.new(element_count + 1) { Element.new } # 1-based indexing

  query_count.times do
    tokens = gets.split
    case tokens[0]
    when 'M'
      elements[tokens[1].to_i].union(elements[tokens[2].to_i])
    when 'Q'
      puts elements[tokens[1].to_i].cardinality
    else
      raise %(Unrecognized operation "#{tokens[0]}")
    end
  end
end
