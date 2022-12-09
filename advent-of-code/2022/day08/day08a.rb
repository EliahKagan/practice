#!/usr/bin/env ruby
# frozen_string_literal: true

$VERBOSE = true

# Advent of Code, day 8, part A

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
      max = -1
      row.map { |cur| max = [max, cur].max }
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
    tallests = [east_tallest, west_tallest, north_tallest, south_tallest]
    visible_heights = tallests.reduce { |grid, acc| acc.grid_op(:min, grid) }
    grid_op(:>=, visible_heights)
  end
end

def parse_grid(lines)
  grid = lines.map(&:rstrip)
              .map { |line| line.each_char.map { |ch| Integer(ch) }.freeze }

  grid.pop while grid.last.empty?
  raise 'empty grid not allowed' if grid.empty?

  width = grid.first.size
  raise 'jagged grid not allowed' if grid.any? { |row| row.size != width }

  grid.freeze
end

def run
  grid = parse_grid(ARGF)
end

run if $PROGRAM_NAME == __FILE__
