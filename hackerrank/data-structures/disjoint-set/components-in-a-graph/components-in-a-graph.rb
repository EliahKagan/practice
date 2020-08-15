#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/components-in-graph

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

if __FILE__ == $PROGRAM_NAME
  n = gets.to_i
  elements = Array.new(n * 2 + 1) { Element.new } # 1-based indexing

  n.times do
    i, j = gets.split.map(&:to_i)
    elements[i].union(elements[j])
  end

  min, max = elements.map(&:size).select { |size| size > 1 }.minmax
  puts "#{min} #{max}"
end
