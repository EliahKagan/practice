#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 6, part A

$VERBOSE = true

START_MARK_PATTERN = /(.)(?!\1)(.)(?!\1|\2)(.)(?!\1|\2|\3)./
START_MARK_LENGTH = 4

def run
  ARGF.each_line do |line|
    start = START_MARK_PATTERN =~ line.strip
    puts start + START_MARK_LENGTH
  end
end

run if $PROGRAM_NAME == __FILE__
