#!/usr/bin/env ruby
# frozen_string_literal: true

# Snakes and Ladders: The Quickest Way Up
# https://www.hackerrank.com/challenges/the-quickest-way-up

$VERBOSE = 1

# A "Snakes and Ladders" board and die.
class Game
  # Creates a new board of the specified size and die reach.
  def initialize(size:, max_reach:)
    @board = (0..size).to_a
    @max_reach = max_reach
  end

  # Adds a snake or ladder from src to dest. (1-based indexing.)
  def add_snake_or_ladder(src, dest)
    check_index(src)
    check_index(dest)

    @board[src] = dest
  end

  # Computes the minimum distance from start to finish via BFS.
  def compute_distance(start, finish)
    check_index(start)
    check_index(finish)

    vis = [false] * @board.size
    vis[0] = true
    queue = [start]
    distance = 0

    until queue.empty?
      distance += 1

      queue.size.times do
        src = queue.shift
        each_dest(src) do |dest|
          next if vis[dest]
          vis[dest] = true
          return distance if dest == finish
          queue.push(dest)
        end
      end
    end

    nil
  end

  private

  # Throws if the position is not of a valid board cell.
  def check_index(position)
    return if position.between?(1, @board.size - 1)

    raise IndexError, 'position is off the board'
  end

  # Calls a block for each destination from a given source position.
  # This accounts for the traversal of snakes and ladders.
  def each_dest(src)
    (src + 1).upto([src + @max_reach, @board.size - 1].min) do |predest|
      yield @board[predest]
    end
  end
end

# Adds snakes or ladders in the input format to a game.
def read_snakes_or_ladders(game)
  gets.to_i.times do
    src, dest = gets.split.map(&:to_i)
    game.add_snake_or_ladder(src, dest)
  end
end

# Reads a board configuration and reports the BFS distance.
def run
  game = Game.new(size: 100, max_reach: 6)
  2.times { read_snakes_or_ladders(game) } # First ladders, then snakes.
  puts game.compute_distance(1, 100) || -1
end

if __FILE__ == $PROGRAM_NAME
  gets.to_i.times { run }
end
