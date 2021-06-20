# LeetCode #1368 - Minimum Cost to Make at Least One Valid Path in a Grid
# https://leetcode.com/problems/minimum-cost-to-make-at-least-one-valid-path-in-a-grid/
# Via Dijkstra's algorithm, using 0-1 BFS.

RIGHT = 1
LEFT = 2
LOWER = 3
UPPER = 4

# @param {Integer[][]} grid
# @return {Integer}
def min_cost(grid)
  GridGraphAdapter.new(grid).min_cost
end

# Treats a rectangular grid of arrows as a weighted directed graph, with edges
# pointing from every cell to its adjacent cells, where edges corresponding to
# the direction of grid arrows have weight 0 and all other edges have weight 1.
class GridGraphAdapter
  def initialize(grid)
    @grid = grid
    @max_i = grid.size - 1
    @max_j = grid.first.size - 1
  end

  # Cost of least-cost upper-left to lower-right path via 0-1 BFS.
  def min_cost
    vis = Set.new([[0, 0]])
    fast = [[0, 0]]
    slow = []
    depth = 0

    until fast.empty?
      until fast.empty?
        src = fast.shift
        slow << src
        src_i, src_j = src
        return depth if src_i == @max_i && src_j == @max_j

        dest = gratis_dest?(src_i, src_j)
        next if dest.nil? || vis.include?(dest)

        vis << dest
        fast << dest
      end

      until slow.empty?
        src_i, src_j = slow.shift

        each_paid_dest(src_i, src_j) do |dest|
          next if vis.include?(dest)

          vis << dest
          fast << dest
        end
      end

      depth += 1
    end

    raise "Couldn't find least-cost path (bug or malformed input)"
  end

  private

  def gratis_dest?(src_i, src_j)
    case @grid[src_i][src_j]
    when RIGHT
      return [src_i, src_j + 1] unless src_j == @max_j
    when LEFT
      return [src_i, src_j - 1] unless src_j.zero?
    when LOWER
      return [src_i + 1, src_j] unless src_i == @max_i
    when UPPER
      return [src_i - 1, src_j] unless src_i.zero?
    else
      raise "Cell entry can't be interpreted as an arrow"
    end
    nil
  end

  def each_paid_dest(src_i, src_j)
    arrow = @grid[src_i][src_j]

    yield [src_i, src_j + 1] unless arrow == RIGHT || src_j == @max_j
    yield [src_i, src_j - 1] unless arrow == LEFT || src_j.zero?
    yield [src_i + 1, src_j] unless arrow == LOWER || src_i == @max_i
    yield [src_i - 1, src_j] unless arrow == UPPER || src_i.zero?
  end
end
