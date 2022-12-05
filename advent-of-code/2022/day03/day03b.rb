#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 3, part B

$VERBOSE = true

require 'set'

LOWER_A_PRIORITY = 1
UPPER_A_PRIORITY = 27
GROUP_SIZE = 3

# Extensions for String, to form sets of characters.
class String
  def to_set
    each_char.to_set
  end
end

def item_priority(item)
  case item
  when /[a-z]/
    LOWER_A_PRIORITY + item.ord - 'a'.ord
  when /[A-Z]/
    UPPER_A_PRIORITY + item.ord - 'A'.ord
  else
    raise ArgumentError, %(item "#{item}" is not a single-letter string)
  end
end

def group_priority(group)
  intersect = group.map(&:to_set).reduce(:&)
  raise "#{intersect} is not size-1" unless intersect.size == 1

  item_priority(intersect.first)
end

def run
  total = ARGF.map(&:strip)
              .reject(&:empty?)
              .each_slice(GROUP_SIZE)
              .sum { |group| group_priority(group) }

  puts total
end

run if $PROGRAM_NAME == __FILE__
