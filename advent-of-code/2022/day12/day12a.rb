#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 12, part A

$VERBOSE = true

# Board representing hilly landscape and providing BFS route-finding.
class Board
  def initialize(lines)
    populate(lines)
    check_start_end
    check_dimensions

    @rows.each(&:freeze)
    @rows.freeze
  end

  def height
    @rows.size
  end

  def width
    @rows.first.size
  end

  def bfs
    vis = Array.new(height) { [false] * width }
    queue = [[@start_i, @start_j]]

    (1..).each do |depth|
      raise 'route not found' if queue.empty?

      queue.size.times do
        src_i, src_j = queue.shift

        each_neighbor(src_i, src_j) do |dest_i, dest_j|
          return depth if dest_i == @end_i && dest_j == @end_j
          next if vis[dest_i][dest_j]

          vis[dest_i][dest_j] = true
          queue << [dest_i, dest_j]
        end
      end
    end
  end

  private

  def populate(lines)
    @start_i = @start_j = @end_i = @end_j = nil

    @rows = lines.map.with_index do |line, i|
      line.each_char.map.with_index do |char, j|
        case char
        when /[a-z]/
          char.ord - 'a'.ord
        when /S/
          record_start(i, j)
          0
        when /E/
          record_end(i, j)
          'z'.ord - 'a'.ord
        else
          raise "unrecognized cell content character: '#{char}'"
        end
      end
    end
  end

  def record_start(i, j)
    raise 'multiple start cells' if @start_i || @start_j

    @start_i = i
    @start_j = j
    nil
  end

  def record_end(i, j)
    raise 'multiple end cells' if @end_i || @end_j

    @end_i = i
    @end_j = j
    nil
  end

  def check_start_end
    raise 'no start cell' unless @start_i && @start_j
    raise 'no end cell' unless @end_i && @end_j

    raise 'Bug: same start and end' if @start_i == @end_i && @start_j == @end_j
  end

  def check_dimensions
    raise 'empty board' if @rows.empty?
    raise 'jagged board' if @rows.any? { |row| row.size != width }
    raise 'zero-width board' if width.zero?
  end

  def each_neighbor(src_i, src_j)
    candidates = [[src_i, src_j - 1], [src_i, src_j + 1],
                  [src_i - 1, src_j], [src_i + 1, src_j]]

    candidates.each do |dest_i, dest_j|
      next unless dest_i.between?(0, height - 1)
      next unless dest_j.between?(0, width - 1)
      next unless @rows[dest_i][dest_j] <= @rows[src_i][src_j] + 1

      yield dest_i, dest_j
    end

    nil
  end
end

def read_lines
  lines = ARGF.map(&:rstrip)
  lines.pop while !lines.empty? && lines.last.empty?
  lines
end

def run
  puts Board.new(read_lines).bfs
end

run if $PROGRAM_NAME == __FILE__
