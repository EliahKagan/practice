# LeetCode #1368 - Minimum Cost to Make at Least One Valid Path in a Grid
# https://leetcode.com/problems/minimum-cost-to-make-at-least-one-valid-path-in-a-grid/
# Via Dijkstra's algorithm, using a naive ("flat") minheap.

RIGHT = 1
LEFT = 2
LOWER = 3
UPPER = 4

# @param {Integer[][]} grid
# @return {Integer}
def min_cost(grid)
  GridGraphAdapter.new(grid).min_cost
end

# A naive (unsorted) priority queue for Prim's and Dijkstra's algorithms.
class NaiveHeap
  def initialize
    @heap = {}
  end

  def empty?
    @heap.empty?
  end

  def size
    @heap.size
  end

  def push_or_decrease(key, value)
    old_value = @heap[key]
    @heap[key] = value if old_value.nil? || value < old_value
    nil
  end

  def pop
    raise "can't pop from empty heap" if empty?

    entry = @heap.min_by { |_, v| v }
    @heap.delete(entry.first)
    entry
  end
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

  # Cost of least-cost upper-left to lower-right path via Dijkstra's algorithm.
  def min_cost
    costs = Array.new(@max_i + 1) { [nil] * (@max_j + 1) }
    heap = NaiveHeap.new
    heap.push_or_decrease([0, 0], 0)

    until heap.empty?
      src, src_cost = heap.pop
      src_i, src_j = src
      costs[src_i][src_j] = src_cost
      return src_cost if src_i == @max_i && src_j == @max_j

      each_dest_with_weight(src_i, src_j) do |dest_i, dest_j, weight|
        next if costs[dest_i][dest_j]
        heap.push_or_decrease([dest_i, dest_j], src_cost + weight)
      end
    end

    raise "Couldn't find least-cost path (bug or malformed input)"
  end

  private

  def each_dest_with_weight(src_i, src_j)
    arrow = @grid[src_i][src_j]

    yield src_i, src_j + 1, (arrow == RIGHT ? 0 : 1) unless src_j == @max_j
    yield src_i, src_j - 1, (arrow == LEFT ? 0 : 1) unless src_j.zero?
    yield src_i + 1, src_j, (arrow == LOWER ? 0 : 1) unless src_i == @max_i
    yield src_i - 1, src_j, (arrow == UPPER ? 0 : 1) unless src_i.zero?
  end
end
