#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code, day 8, part B

$VERBOSE = true

require 'optparse'

# Array extensions for grids representing trees of various heights.
class Array
  def grid_op(operation, other)
    zip(other).map do |row1, row2|
      row1.zip(row2).map { |elem1, elem2| elem1.send(operation, elem2) }
    end
  end

  def east_scenic
    map do |row|
      # Let's see if the naive algorithm finishes quickly enough.
      row.each_with_index.map do |value, right|
        left = right
        while left.positive?
          left -= 1
          break if row[left] >= value
        end
        right - left
      end
    end
  end

  def west_scenic
    map(&:reverse).east_scenic.map(&:reverse)
  end

  def north_scenic
    transpose.reverse.east_scenic.reverse.transpose
  end

  def south_scenic
    reverse.transpose.east_scenic.transpose.reverse
  end

  def scenic_scoring
    scenic_grids = [east_scenic, west_scenic, north_scenic, south_scenic]
    scenic_grids.reduce { |acc, grid| acc.grid_op(:*, grid) }
  end
end

def parse_grid_raw(lines)
  lines.map(&:rstrip)
       .map { |line| line.each_char.map { |ch| Integer(ch) }.freeze }
end

def parse_grid(lines)
  grid = parse_grid_raw(lines)
  grid.pop while grid.last.empty?
  raise 'empty grid not allowed' if grid.empty?

  width = grid.first.size
  raise 'jagged grid not allowed' if grid.any? { |row| row.size != width }

  grid.freeze
end

def parse_options
  options = {verbose: false}

  OptionParser.new do |parser|
    parser.on('-v', '--verbose', 'Show the computed visibility grid') do
      options[:verbose] = true
    end
    parser.on('-h', '--help', 'Print this help message') do
      puts parser
      exit
    end
  end.parse!

  options
end

def run
  verbose = parse_options[:verbose]
  scenic_scoring = parse_grid(ARGF).scenic_scoring
  pp scenic_scoring if verbose
  puts scenic_scoring.flatten.max
end

run if $PROGRAM_NAME == __FILE__
