#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 4, part A

$VERBOSE = true

def parse_range(hyphenated)
  first, last = hyphenated.split('-').map(&:to_i)
  first..last
end

def parse_line(line)
  line.split(',').map { |side| parse_range(side) }
end

def fully_redundant?(range1, range2)
  range1.cover?(range2) || range2.cover?(range1)
end

def run
  count = ARGF.map(&:strip)
              .reject(&:empty?)
              .map { |line| parse_line(line) }
              .count { |ranges| fully_redundant?(*ranges) }

  puts count
end

run if $PROGRAM_NAME == __FILE__
