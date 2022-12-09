#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 9, part B
# (Can also be used to solve part A, by passing "-k 2".)

$VERBOSE = true

require 'optparse'
require 'set'

DEFAULT_KNOT_COUNT = 10

DIRECTIONS = {
  'L' => [0, -1].freeze,
  'R' => [0, +1].freeze,
  'U' => [-1, 0].freeze,
  'D' => [+1, 0].freeze
}.freeze

def parse_options
  options = {knot_count: DEFAULT_KNOT_COUNT}

  OptionParser.new do |parser|
    parser.on('-k', '--knots COUNT',
              "Knot count (default: #{DEFAULT_KNOT_COUNT})") do |arg|
      options[:knot_count] = Integer(arg)
    end
    parser.on('-h', '--help', 'Print this help message') do
      puts parser
      exit
    end
  end.parse!

  options
end

def run
  knot_count = parse_options[:knot_count]
  knot_rows = [0] * knot_count
  knot_cols = [0] * knot_count
  tail_history = [[0, 0].freeze].to_set

  ARGF.map(&:strip).reject(&:empty?).map(&:split).each do |direction, reps|
    head_row_delta, head_col_delta = DIRECTIONS.fetch(direction)

    reps.to_i.times do
      knot_rows[0] += head_row_delta
      knot_cols[0] += head_col_delta

      (0...knot_count).each_cons(2) do |pre, cur|
        row_sep = knot_rows[pre] - knot_rows[cur]
        col_sep = knot_cols[pre] - knot_cols[cur]
        raise "Bug: at cur=#{cur}, row_sep=#{row_sep} > 2" if row_sep.abs > 2
        raise "Bug: at cur=#{cur}, col_sep=#{col_sep} > 2" if col_sep.abs > 2

        next if row_sep.abs < 2 && col_sep.abs < 2

        knot_rows[cur] += row_sep / row_sep.abs unless row_sep.zero?
        knot_cols[cur] += col_sep / col_sep.abs unless col_sep.zero?
      end

      tail_history.add([knot_rows.last, knot_cols.last].freeze)
    end
  end

  puts tail_history.size
end

run if $PROGRAM_NAME == __FILE__
