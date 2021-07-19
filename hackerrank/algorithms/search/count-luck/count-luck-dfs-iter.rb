#!/usr/bin/env ruby
# frozen_string_literal: true

# HackerRank - Count Luck
# https://www.hackerrank.com/challenges/count-luck
# By iterative DFS.

# A game board representing the forest to be escaped.
class Board
  def initialize(rows)
    @rows = rows.map(&:dup)
    raise 'empty grid not supported' if height.zero?
    raise 'jagged grid not supported' if @rows.any? { |row| row.size != width }
  end

  # Counts the number of junctions on the correct path. Fills in the path.
  def fill_count_branches
    dfs(*start)
  end

  private

  def height
    @rows.size
  end

  def width
    @rows.first.size
  end

  def exists?(i, j)
    i.between?(0, height - 1) && j.between?(0, width - 1)
  end

  def neighbors(i, j)
    [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].filter do |h, k|
      exists?(h, k) && @rows[h][k] != 'X'
    end
  end

  def start
    @rows.each_with_index do |row, i|
      row.each_char.with_index do |cell, j|
        return [i, j] if cell == 'M'
      end
    end

    raise 'start location not found'
  end

  def dfs(i, j)
    stack = [[i, j, 0]]

    until stack.empty?
      i, j, count = stack.pop
      next if @rows[i][j] == 'X'

      return count if @rows[i][j] == '*'

      @rows[i][j] = 'X'
      nei = neighbors(i, j)
      count += 1 if nei.size > 1
      nei.each { |h, k| stack << [h, k, count] }
    end

    nil
  end
end

def read_value
  gets.to_i
end

def read_record(length)
  values = gets.split.map(&:to_i)
  raise 'wrong record length' if values.size != length
  values
end

def read_board
  height, width = read_record(2)

  rows = Array.new(height) do
    row = gets.strip
    raise 'wrong row width' if row.size != width
    row
  end

  Board.new(rows)
end

def run
  board = read_board
  guess = read_value
  count = board.fill_count_branches
  raise 'no solution' unless count

  puts guess == count ? 'Impressed' : 'Oops!'
end

read_value.times { run } if $PROGRAM_NAME == __FILE__
