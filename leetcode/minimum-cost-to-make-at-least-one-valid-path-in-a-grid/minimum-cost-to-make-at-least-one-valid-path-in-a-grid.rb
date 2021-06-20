# LeetCode #1368 - Minimum Cost to Make at Least One Valid Path in a Grid
# https://leetcode.com/problems/minimum-cost-to-make-at-least-one-valid-path-in-a-grid/
# Via Dijkstra's algorithm.

RIGHT = 1
LEFT = 2
LOWER = 3
UPPER = 4

# @param {Integer[][]} grid
# @return {Integer}
def min_cost(grid)
  GridGraphAdapter.new(grid).min_cost
end

# A heap + map data structure for Prim's and Dijkstra's algorithms.
class PrimHeap
  def initialize
    @heap = [] # index -> (key, value)
    @map = {} # key -> index
  end

  def empty?
    @heap.empty?
  end

  def size
    @heap.size
  end

  def push_or_decrease(key, value)
    child = @map[key]

    if child.nil?
      sift_up(size, make_entry(key, value))
    elsif value < @heap[child].value
      sift_up(child, make_entry(@heap[child].key, value))
    end
  end

  def pop
    raise "can't pop from empty heap" if empty?

    key, value = *@heap.first
    @map.delete(key)

    if @map.empty?
      @heap.clear
    else
      parent_entry = @heap.pop
      sift_down(0, parent_entry)
    end

    [key, value]
  end

  private

  def sift_up(child, child_entry)
    while child.positive?
      parent = (child - 1) / 2
      break if @heap[parent].value <= child_entry.value

      set(child, @heap[parent])
      child = parent
    end

    set(child, child_entry)
  end

  def sift_down(parent, parent_entry)
    loop do
      child = pick_child(parent)
      break if child.nil? || parent_entry.value <= @heap[child].value

      set(parent, @heap[child])
      parent = child
    end

    set(parent, parent_entry)
  end

  def pick_child(parent)
    left = parent * 2 + 1
    return nil if left >= size

    right = left + 1
    right == size || @heap[left].value <= @heap[right].value ? left : right
  end

  def set(index, entry)
    @heap[index] = entry
    @map[entry.key] = index
    nil
  end

  def make_entry(key, value)
    Entry.new(key, value).freeze
  end

  Entry = Struct.new(:key, :value)
  private_constant :Entry
end

class GridGraphAdapter
  def initialize(grid)
    @grid = grid
    @max_i = grid.size - 1
    @max_j = grid.first.size - 1
  end

  # Cost of least-cost upper-left to lower-right path via Dijkstra's algorithm.
  def min_cost
    costs = Array.new(@max_i + 1) { [nil] * (@max_j + 1) }
    heap = PrimHeap.new
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

    yield [src_i, src_j + 1, (arrow == RIGHT ? 0 : 1)] unless src_j == @max_j
    yield [src_i, src_j - 1, (arrow == LEFT ? 0 : 1)] unless src_j.zero?
    yield [src_i + 1, src_j, (arrow == LOWER ? 0 : 1)] unless src_i == @max_i
    yield [src_i - 1, src_j, (arrow == UPPER ? 0 : 1)] unless src_i.zero?
  end
end
