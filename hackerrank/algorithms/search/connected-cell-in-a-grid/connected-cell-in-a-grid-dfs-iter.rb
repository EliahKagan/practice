#!/usr/bin/env ruby
# frozen_string_literal: true

# HackerRank - Connected Cells in a Grid
# https://www.hackerrank.com/challenges/connected-cell-in-a-grid
# By iterative DFS.

# A board that supports destructively computing maximum component area.
class Grid
  def initialize(rows)
    @rows = rows.map(&:dup)
    raise 'empty grid not supported' if height.zero? || width.zero?
    raise 'jagged grid not supported' if @rows.any? { |row| row.size != width }
  end

  # Fills (removes) all components. Returns the area of the biggest component.
  def fill_compute_max_area
    (0...height).map { |i| (0...width).map { |j| dfs(i, j) }.max }.max
  end

  private

  def height
    @rows.size
  end

  def width
    @rows.first.size
  end

  def dfs(i, j)
    return 0 if @rows[i][j].zero?

    @rows[i][j] = 0
    stack = [[i, j]]
    area = 1

    until stack.empty?
      i, j = stack.pop

      (i - 1).upto(i + 1) do |h|
        next unless h.between?(0, height - 1)

        (j - 1).upto(j + 1) do |k|
          next unless k.between?(0, width - 1) && @rows[h][k].nonzero?

          @rows[h][k] = 0
          stack << [h, k]
          area += 1
        end
      end
    end

    area
  end
end

def read_value
  gets.to_i
end

def read_record(length)
  values = gets.split.map(&:to_i)
  raise 'wrong record length' unless values.size == length
  values
end

def run
  height = read_value
  width = read_value
  rows = Array.new(height) { read_record(width) }
  puts Grid.new(rows).fill_compute_max_area
end

run if $PROGRAM_NAME == __FILE__
