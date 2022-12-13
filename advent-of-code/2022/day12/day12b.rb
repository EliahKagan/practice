#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 12, part B

$VERBOSE = true

# Board representing hilly landscape and providing BFS route-finding.
class Board
  def initialize(lines)
    populate(lines)
    check_dimensions
    raise 'no endpoint cell' unless @endpoint_i && @endpoint_j

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
    queue = [[@endpoint_i, @endpoint_j]]

    (1..).each do |depth|
      raise 'route not found' if queue.empty?

      queue.size.times do
        src_i, src_j = queue.shift

        each_neighbor(src_i, src_j) do |dest_i, dest_j|
          next if vis[dest_i][dest_j]

          vis[dest_i][dest_j] = true

          return depth if @rows[dest_i][dest_j].zero?

          queue << [dest_i, dest_j]
        end
      end
    end
  end

  private

  def populate(lines)
    @endpoint_i, @endpoint_j = nil

    @rows = lines.map.with_index do |line, i|
      line.each_char.map.with_index do |char, j|
        case char
        when /[a-z]/
          char.ord - 'a'.ord
        when /S/
          0 # Treated the same as 'a'.
        when /E/
          record_endpoint(i, j)
          'z'.ord - 'a'.ord
        else
          raise "unrecognized cell content character: '#{char}'"
        end
      end
    end
  end

  def record_endpoint(i, j)
    raise 'multiple endpoint cells' if @endpoint_i || @endpoint_j

    @endpoint_i = i
    @endpoint_j = j
    nil
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
      next unless @rows[src_i][src_j] <= @rows[dest_i][dest_j] + 1

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
