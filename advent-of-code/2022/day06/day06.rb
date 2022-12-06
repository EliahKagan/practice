#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 6, both parts
#
# This is an alternative solution to parts A and B, not using a regex.

$VERBOSE = true

LENGTHS = [4, 14].freeze

def find_mark(line, length)
  line.chars
      .lazy
      .each_cons(length)
      .with_index(length)
      .select { |window, _| window.uniq.length == length }
      .map { |_, index| index }
      .first
end

def run
  ARGF.map(&:strip).each do |line|
    puts LENGTHS.map { |length| find_mark(line, length) }.join("\t")
  end
end

run if $PROGRAM_NAME == __FILE__
