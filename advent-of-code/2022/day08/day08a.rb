#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code, day 8, part A

$VERBOSE = true

require 'optparse'

# Integer extensions for using min as a binary operation.
class Integer
  def min(other)
    [self, other].min
  end
end

# Array extensions for grids representing trees of various heights.
class Array
  def east_tallest
    map do |row|
      maximum = -1

      row.map do |elem|
        old_maximum = maximum
        maximum = [maximum, elem].max
        old_maximum
      end
    end
  end

  def west_tallest
    map(&:reverse).east_tallest.map(&:reverse)
  end

  def north_tallest
    transpose.reverse.east_tallest.reverse.transpose
  end

  def south_tallest
    reverse.transpose.east_tallest.transpose.reverse
  end

  def grid_op(operation, other)
    zip(other).map do |row1, row2|
      row1.zip(row2).map { |elem1, elem2| elem1.send(operation, elem2) }
    end
  end

  def visibility
    tallest_grids = [east_tallest, west_tallest, north_tallest, south_tallest]

    visible_heights = tallest_grids.reduce do |grid, acc|
      acc.grid_op(:min, grid)
    end

    grid_op(:>, visible_heights)
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
  visibility = parse_grid(ARGF).visibility
  pp visibility if verbose
  puts visibility.flatten.count(&:itself)
end

run if $PROGRAM_NAME == __FILE__
