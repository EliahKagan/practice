#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/find-the-running-median
# With a maxheap of lower values and a minheap of higher values.

$VERBOSE = 1

# Array extension for swapping elements.
class Array
  def swap(index1, index2)
    self[index1], self[index2] = self[index2], self[index1]
  end
end

# Signals an invalid operation on a PriorityQueue.
class PriorityQueueError < IndexError
end

# A priority queue implemented as a binary heap. With <=>, this is a minheap.
class PriorityQueue
  def self.make_minheap
    PriorityQueue.new { |ls, rs| ls <=> rs }
  end

  def self.make_maxheap
    PriorityQueue.new { |ls, rs| rs <=> ls }
  end

  def initialize(&block)
    @comparer = block
    @elems = []
  end

  def empty?
    @elems.empty?
  end

  def size
    @elems.size
  end

  def push(key)
    @elems << key
    sift_up(size - 1)
  end

  def top
    ret = @elems[0]
    return ret if ret

    raise PriorityQueueError, "can't read top of empty priority queue"
  end

  def pop
    ret = top
    if @elems.one?
      @elems.clear
    else
      @elems[0] = @elems.pop
      sift_down(0)
    end
    ret
  end

  private

  def sift_up(child)
    until child.zero?
      parent = (child - 1) / 2
      break if order_ok?(parent, child)

      @elems.swap(parent, child)
      child = parent
    end
  end

  def sift_down(parent)
    loop do
      child = pick_child(parent)
      break if child.nil? || order_ok?(parent, child)

      @elems.swap(parent, child)
      parent = child
    end
  end

  def pick_child(parent)
    left = parent * 2 + 1
    return nil if left >= size

    right = left + 1
    right == size || order_ok?(left, right) ? left : right
  end

  def order_ok?(parent, child)
    @comparer.call(@elems[parent], @elems[child]) <= 0
  end
end

# A growing bag of numbers that efficiently computes medians.
class MedianBag
  def initialize
    @lows = PriorityQueue.make_maxheap
    @highs = PriorityQueue.make_minheap
  end

  def push(value)
    if @highs.empty? || value < @highs.top
      @lows.push(value)
    else
      @highs.push(value)
    end
    rebalance
  end

  def median
    case balance_factor
    when -1
      @lows.top.to_f
    when 0
      (@lows.top + @highs.top) / 2.0
    when +1
      @highs.top.to_f
    else
      raise 'Bug: balancing invariant violated'
    end
  end

  private

  def rebalance
    case balance_factor
    when -2
      @highs.push(@lows.pop)
    when +2
      @lows.push(@highs.pop)
    end
  end

  def balance_factor
    @highs.size - @lows.size
  end
end

if __FILE__ == $PROGRAM_NAME
  bag = MedianBag.new

  gets.to_i.times do
    bag.push(gets.to_i)
    printf "%.1f\n", bag.median # rubocop:disable Style/FormatStringToken
  end
end
