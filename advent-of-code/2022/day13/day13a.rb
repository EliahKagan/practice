#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 13, part A

$VERBOSE = true

require_relative 'nest'

def run
  sum = ARGF.map(&:strip)
            .reject(&:empty?)
            .map { |expression| Nest.parse(expression) }
            .each_slice(2) # Chunk into pairs.
            .with_index(1) # Give each pair an index, starting at 1.
            .select { |(lhs, rhs), _| Nest.compare(lhs, rhs) <= 0 }
            .sum { |(_, _), index| index }

  puts sum
end

run if $PROGRAM_NAME == __FILE__
