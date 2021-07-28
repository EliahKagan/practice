#!/usr/bin/env ruby
# frozen_string_literal: true

# HackerRank: Insertion Sort Advanced Analysis
# https://www.hackerrank.com/challenges/insertion-sort/
# By instrumenting recursive top-down mergesort.

# Instrumented mutating mergesort extensions for arrays.
class Array
  # Mergesorts this array. Returns the number of swaps insertion sort would do.
  def mergesort
    do_mergesort(0, size, [])
  end

  private

  def do_mergesort(low, high, aux)
    return 0 if high - low < 2

    mid = (low + high) / 2
    acc = do_mergesort(low, mid, aux) + do_mergesort(mid, high, aux)
    acc + merge(low, mid, high, aux)
  end

  def merge(low, mid, high, aux)
    raise 'auxiliary array expected to be empty' unless aux.empty?

    acc = 0
    left = low
    right = mid

    while left < mid && right < high
      if self[right] < self[left]
        aux << self[right]
        right += 1
        acc += mid - left # Number of elems insertion sort would swap across.
      else
        aux << self[left]
        left += 1
      end
    end

    while left < mid
      aux << self[left]
      left += 1
    end

    raise 'bug: auxiliary storage wrongly populated' if aux.size != right - low
    self[low...right] = aux
    aux.clear

    acc
  end
end

def read_value
  gets.to_i
end

def read_record
  length = read_value
  record = gets.split.map(&:to_i)
  raise 'wrong record length' if record.size != length
  record
end

read_value.times { puts read_record.mergesort } if $PROGRAM_NAME == __FILE__
