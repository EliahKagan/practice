#!/usr/bin/env ruby
# frozen_string_literal: true

$VERBOSE = true

require 'set'

LOWER_A_PRIORITY = 1
UPPER_A_PRIORITY = 27

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

def intersection_priority(items)
  raise %(item "#{item}" does not have even length) if items.size.odd?

  mid = items.size / 2
  intersect = items[...mid].to_set & items[mid..].to_set
  raise "#{intersect} is not size-1" unless intersect.size == 1

  item_priority(intersect.first)
end

def run
  puts ARGF.each_line
           .map(&:strip)
           .reject(&:empty?)
           .map { |items| intersection_priority(items) }
           .sum
end

run if $PROGRAM_NAME == __FILE__
