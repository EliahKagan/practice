#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2020, day 13, part B
#
# Outputs code in the Wolfram Language that, when evaluated, gives the answer.
# (To evaluate, see https://www.wolframcloud.com.)

$VERBOSE = 1

remainders, divisors =
  ARGF.each_line
      .drop(1)
      .first
      .strip
      .split(',')
      .each_with_index
      .reject { |token, _index| token == 'x' }
      .map { |token, index| [-index, token.to_i] }
      .transpose
      .map { |xs| "{#{xs.join(',')}}" }

puts "ChineseRemainder[#{remainders},#{divisors}]"
