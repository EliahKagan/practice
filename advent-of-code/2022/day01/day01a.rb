#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code, day 1, part A

$VERBOSE = true

def run
  puts ARGF.read
           .split(/\n{2,}/)
           .map(&:strip)
           .reject(&:empty?)
           .map { |group| group.split.map(&:to_i).sum }
           .max
end

run if $PROGRAM_NAME == __FILE__
