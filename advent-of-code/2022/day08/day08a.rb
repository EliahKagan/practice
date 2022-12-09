#!/usr/bin/env ruby
# frozen_string_literal: true

# A grid whose cells represent trees of various heights.
class Grid
  attr_accessor :height, :width

  def initialize(lines)
    @grid = lines.map(&:rstrip)
                 .map { |line| line.each_char.map { |ch| Integer(ch) }.freeze }
    @grid.pop while @grid.last.empty?
    @grid.freeze
    raise 'empty grid not allowed' if @grid.empty?

    @height = @grid.size
    @width = @grid.first.size
    raise 'jagged grid not allowed' if @grid.any? { |row| row.size != @width }
  end

  def [](i, j)
    raise "i=#{i} out of range" unless i.between?(0, height - 1)
    raise "j=#{j} out of range" unless j.between?(0, width - 1)

    @grid[i][j]
  end
end

def run
  grid = Grid.new(ARGF)

end

run if $PROGRAM_NAME == __FILE__
