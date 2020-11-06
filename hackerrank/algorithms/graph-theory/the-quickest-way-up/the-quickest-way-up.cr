# Snakes and Ladders: The Quickest Way Up
# https://www.hackerrank.com/challenges/the-quickest-way-up

require "deque"

# A "Snakes and Ladders" board and die.
class Game
  # Creates a new board of the specified size and die reach.
  def initialize(size : Int32, @max_reach : Int32)
    @board = (0..size).to_a
  end

  # Adds a snake or ladder from src to dest. (1-based indexing.)
  def add_snake_or_ladder(src : Int32, dest : Int32)
    check_index(src)
    check_index(dest)

    @board[src] = dest
  end

  # Computes the minimum distance from start to finish via BFS.
  def compute_distance(start : Int32, finish : Int32)
    check_index(start)
    check_index(finish)

    vis = [false] * @board.size
    vis[0] = true
    queue = Deque(Int32).new
    queue.push(start)
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

  # Throws if the position is not of a valid board cell.
  private def check_index(position)
    unless 0 < position < @board.size
      raise IndexError.new("position is off the board")
    end
  end

  # Calls a block for each destination from a given source position.
  # This accounts for the traversal of snakes and ladders.
  private def each_dest(src, &block)
    (src + 1).upto(Math.min(src + @max_reach, @board.size - 1)) do |predest|
      yield @board[predest]
    end
  end

  @board : Array(Int32)
end

# Reads a line as a single integer value.
def read_value
  gets.as(String).to_i
end

# Reads a line as a sequence of integers.
def read_record
  gets.as(String).split.map(&.to_i)
end

# Adds snakes or ladders in the input format to a game.
def read_snakes_or_ladders(game)
  read_value.times do
    src, dest = read_record
    game.add_snake_or_ladder(src, dest)
  end
end

# Reads a board configuration and reports the BFS distance.
def run
  game = Game.new(size: 100, max_reach: 6)
  2.times { read_snakes_or_ladders(game) } # First ladders, then snakes.
  puts game.compute_distance(1, 100) || -1
end

read_value.times { run }
