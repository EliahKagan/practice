#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code, day 9, part A

$VERBOSE = true

require 'set'

DIRECTIONS = {
  'L' => [0, -1].freeze,
  'R' => [0, +1].freeze,
  'U' => [-1, 0].freeze,
  'D' => [+1, 0].freeze
}.freeze

def run
  tail_history = [[0, 0].freeze].to_set
  head_row = head_col = tail_row = tail_col = 0

  ARGF.map(&:strip).reject(&:empty?).map(&:split).each do |direction, count|
    head_row_delta, head_col_delta = DIRECTIONS.fetch(direction)

    count.to_i.times do
      head_row += head_row_delta
      head_col += head_col_delta
      row_sep = head_row - tail_row
      col_sep = head_col - tail_col
      raise "Bug: excessive row separation of #{row_sep}" if row_sep.abs > 2
      raise "Bug: excessive column separation of #{col_sep}" if col_sep.abs > 2

      next if row_sep.abs < 2 && col_sep.abs < 2

      tail_row += row_sep / row_sep.abs unless row_sep.zero?
      tail_col += col_sep / col_sep.abs unless col_sep.zero?
      tail_history.add([tail_row, tail_col].freeze)
    end
  end

  puts tail_history.size
end

run if $PROGRAM_NAME == __FILE__
