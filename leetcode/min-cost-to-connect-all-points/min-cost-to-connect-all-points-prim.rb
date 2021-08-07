# LeetCode #1584 - Min Cost to Connect All Points
# https://leetcode.com/problems/min-cost-to-connect-all-points/
# By Prim's algorithm.

# @param {Integer[][]} points
# @return {Integer}
def min_cost_connect_points(points)
  build_graph(points).prim_mst_cost(0)
end

def build_graph(points)
  graph = Graph.new(points.size)
  each_edge(points) { |u, v, weight| graph.add_edge(u, v, weight) }
  graph
end

def each_edge(points)
  0.upto(points.size - 2) do |u|
    ux, uy = points[u]

    (u + 1).upto(points.size - 1) do |v|
      vx, vy = points[v]
      yield u, v, (ux - vx).abs + (uy - vy).abs
    end
  end

  nil
end

# A weighted undirected graph implementing Prim's algorithm.
class Graph
  def initialize(order)
    @adj = Array.new(order) { [] }
  end

  def add_edge(u, v, weight)
    raise 'endpoint vertex out of range' unless exists?(u) && exists?(v)

    @adj[u] << [v, weight]
    @adj[v] << [u, weight]
    nil
  end

  def prim_mst_cost(start)
    raise 'start vertex out of range' unless exists?(start)

    vis = [false] * order
    acc = 0

    heap = PrimHeap.new(order)
    heap.push_or_decrease(start, 0)

    until heap.empty?
      src, src_cost = heap.pop
      vis[src] = true
      acc += src_cost

      @adj[src].each do |dest, weight|
        heap.push_or_decrease(dest, weight) unless vis[dest]
      end
    end

    acc
  end

  private

  def order
    @adj.size
  end

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
