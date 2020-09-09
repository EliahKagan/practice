#!/usr/bin/env ruby
# frozen_string_literal: true

# HackerRank - Median Updates
# https://www.hackerrank.com/challenges/median
# In Crystal. The problem is intended to be solved with self-balancing trees,
# but this solution uses binary heaps equipped with an O(log(n)) delete
# operation.

$VERBOSE = 1

require 'set'

# A priority queue with an O(log(n)) remove operation, implemented as a binary
# heap augmented with a table mapping each key to all of its occurrences in the
# heap.
class BinaryHeap
  def self.make_min_heap
    BinaryHeap.new { |ls, rs| ls <=> rs }
  end

  def self.make_max_heap
    BinaryHeap.new { |ls, rs| rs <=> ls }
  end

  def empty?
    @heap.empty?
  end

  def size
    @heap.size
  end

  def clear
    @map.clear
    @heap.clear
  end

  def push(value)
    child = sift_up(value)
    (@map[value] ||= Set.new).add(child)
    @heap[child] = value
    nil
  end

  def pop
    value = first

    if size == 1
      clear
    else
      indices = @map[value]

      if indices.size == 1
        @map.delete(value)
      else
        indices.delete(0)
      end

      cut_root
    end

    value
  end

  def first
    @heap.first
  end

  def delete?(value)
    indices = @map[value]
    return false if indices.nil?

    if size == 1
      clear
    else
      child = indices.first # Get any index to this value in the heap.

      if indices.size == 1
        @map.delete(value)
      else
        child = highest_equal_ancestor(child)
        indices.delete(child)
      end

      yank_up(child)
      cut_root
    end

    true
  end

  protected

  def initialize(&comparer)
    @map = {}  # value => indices
    @heap = [] # index => value
    @comparer = comparer
  end

  private

  def cut_root
    value = @heap.pop
    indices = @map[value]
    indices.delete(size)

    index = sift_down(value)
    indices.add(index)
    @heap[index] = value

    nil
  end

  def highest_equal_ancestor(child)
    value = @heap[child]

    until child.zero?
      parent = (child - 1) / 2
      break if @heap[parent] != value

      child = parent
    end

    child
  end

  def yank_up(child)
    until child.zero?
      parent = (child - 1) / 2
      parent_value = @heap[parent]

      @map[parent_value].delete(parent).add(child)
      @heap[child] = parent_value

      child = parent
    end
    nil
  end

  def sift_up(child_value)
    child = size

    until child.zero?
      parent = (child - 1) / 2
      parent_value = @heap[parent]
      break if order_ok?(parent_value, child_value)

      @map[parent_value].delete(parent).add(child)
      @heap[child] = parent_value

      child = parent
    end

    child
  end

  def sift_down(parent_value)
    parent = 0

    loop do
      child = pick_child(parent)
      break if child.nil?

      child_value = @heap[child]
      break if order_ok?(parent_value, child_value)

      @map[child_value].delete(child).add(parent)
      @heap[parent] = child_value

      parent = child
    end

    parent
  end

  def pick_child(parent)
    left = parent * 2 + 1
    return nil if left >= size

    right = left + 1
    right == size || order_ok?(@heap[left], @heap[right]) ? left : right
  end

  def order_ok?(parent_value, child_value)
    @comparer.call(parent_value, child_value) <= 0
  end
end

# A multiset with O(log(n)) insertion and deletion and O(1) median finding.
class MedianBag
  def initialize
    @low = BinaryHeap.make_max_heap
    @high = BinaryHeap.make_min_heap
  end

  def empty?
    @low.empty? && @high.empty?
  end

  def add(value)
    if !@low.empty? && value < @low.first
      @low.push(value)
    else
      @high.push(value)
    end

    rebalance
  end

  def delete?(value)
    if @low.delete?(value) || @high.delete?(value)
      rebalance
      true
    else
      false
    end
  end

  def median
    case balance_factor
    when -1
      @low.first
    when +1
      @high.first
    when 0
      (@low.first + @high.first) / 2.0
    else
      raise "Bug: balancing invariant violated"
    end
  end

  private

  def rebalance
    case balance_factor
    when -2
      @high.push(@low.pop)
    when +2
      @low.push(@high.pop)
    end # In other cases, it can't be made more balanced.

    nil
  end

  def balance_factor
    @high.size - @low.size
  end
end

def print_without_trailing_fractional_zeros(value)
  if value.is_a?(Float) && (rounded_value = value.to_i) == value
    puts rounded_value
  else
    puts value
  end
end

if __FILE__ == $PROGRAM_NAME
  bag = MedianBag.new

  gets.to_i.times do
    tokens = gets.split
    opcode = tokens[0]
    argument = tokens[1].to_i

    case opcode
    when 'a'
      bag.add(argument)
    when 'r'
      if !bag.delete?(argument) || bag.empty?
        puts 'Wrong!'
        next
      end
    else
      raise 'Unrecognized opcode.'
    end

    print_without_trailing_fractional_zeros(bag.median)
  end
end
