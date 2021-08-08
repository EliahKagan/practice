# LeetCode #1631 - Path With Minimum Effort
# https://leetcode.com/problems/path-with-minimum-effort/
# By a modified Dijkstra's algorithm, using max instead of sum.

# @param {Integer[][]} heights
# @return {Integer}
def minimum_effort_path(heights)
  graph = build_graph(heights)
  graph.minimize_max_edge_weight(0, graph.order - 1)
end

def build_graph(heights)
  m = heights.size
  n = heights.first.size
  graph = Graph.new(m * n)

  0.upto(m - 1) do |i|
    0.upto(n - 1) do |j|
      if j + 1 != n
        graph.add_edge(n * i + j,
                       n * i + j + 1,
                       (heights[i][j] - heights[i][j + 1]).abs)
      end
      if i + 1 != m
        graph.add_edge(n * i + j,
                       n * (i + 1) + j,
                       (heights[i][j] - heights[i + 1][j]).abs)
      end
    end
  end

  graph
end

# A weighted undirected graph.
class Graph
  def initialize(order)
    @adj = Array.new(order) { [] }
  end

  def order
    @adj.size
  end

  def add_edge(u, v, weight)
    raise 'edge vertex out of range' unless exists?(u) && exists?(v)

    @adj[u] << [v, weight]
    @adj[v] << [u, weight]
    nil
  end

  def minimize_max_edge_weight(start, finish)
    raise 'vertex out of range' unless exists?(start) && exists?(finish)

    acc = 0
    vis = [false] * order

    heap = PrimHeap.new(order)
    heap.push_or_decrease(start, 0)

    until heap.empty?
      src, src_cost = heap.pop
      vis[src] = true
      acc = src_cost if acc < src_cost
      return acc if src == finish

      @adj[src].each do |dest, weight|
        heap.push_or_decrease(dest, [src_cost, weight].max) unless vis[dest]
      end
    end

    raise 'destination vertex not reachable'
  end

  private

  def exists?(vertex)
    vertex.between?(0, order - 1)
  end
end

# A binary minheap + map data structure for Prim's and Dijkstra's algorithms.
class PrimHeap
  def initialize(capacity)
    @heap = [] # index -> (key, value)
    @map = [nil] * capacity # key -> index
  end

  def empty?
    @heap.empty?
  end

  def push_or_decrease(key, value)
    raise 'key out of range' unless key.between?(0, capacity - 1)

    if (child = @map[key]).nil?
      sift_up(size, Entry.new(key, value))
    elsif value < (entry = @heap[child]).value
      entry.value = value
      sift_up(child, entry)
    end
  end

  def pop
    raise "can't pop from empty heap" if empty?

    entry = @heap.first
    @map[entry.key] = nil

    if size == 1
      @heap.clear
    else
      sift_down(0, @heap.pop)
    end

    [entry.key, entry.value]
  end

  Entry = Struct.new(:key, :value)
  private_constant :Entry

  private

  def size
    @heap.size
  end

  def capacity
    @map.size
  end

  def sift_up(child, child_entry)
    until child.zero?
      parent = (child - 1) / 2
      break unless child_entry.value < @heap[parent].value

      set(child, @heap[parent])
      child = parent
    end

    set(child, child_entry)
  end

  def sift_down(parent, parent_entry)
    loop do
      child = pick_child(parent)
      break unless child && @heap[child].value < parent_entry.value

      set(parent, @heap[child])
      parent = child
    end

    set(parent, parent_entry)
  end

  def pick_child(parent)
    left = parent * 2 + 1
    return nil if left >= size

    right = left + 1
    right != size && @heap[right].value < @heap[left].value ? right : left
  end

  def set(index, entry)
    @heap[index] = entry
    @map[entry.key] = index
    nil
  end
end
