#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code, day 13, part B

$VERBOSE = true

require_relative 'nest'

DIVIDERS = [
  [[2]].freeze,
  [[6]].freeze
].freeze

def run
  packets = ARGF.lazy
                .map(&:strip)
                .reject(&:empty?)
                .map { |expression| Nest.parse(expression) }
                .chain(DIVIDERS)
                .sort { |lhs, rhs| Nest.compare(lhs, rhs) }

  puts DIVIDERS.map { |divider| packets.index(divider) + 1 }.reduce(:*)
end

run if $PROGRAM_NAME == __FILE__
