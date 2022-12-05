#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 4, part B

$VERBOSE = true

def parse_range(hyphenated)
  first, last = hyphenated.split('-').map(&:to_i)
  first..last
end

def parse_line(line)
  line.split(',').map { |side| parse_range(side) }
end

def disjoint?(range1, range2)
  range1.last < range2.first || range2.last < range1.first
end

def run
  count = ARGF.map(&:strip)
              .reject(&:empty?)
              .map { |line| parse_line(line) }
              .count { |ranges| !disjoint?(*ranges) }

  puts count
end

run if $PROGRAM_NAME == __FILE__
