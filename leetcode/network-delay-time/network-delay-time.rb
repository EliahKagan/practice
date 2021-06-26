# LeetCode #743 - Network Delay Time
# https://leetcode.com/problems/network-delay-time/
# By Dijkstra's algorithm.

# @param {Integer[][]} times
# @param {Integer} n
# @param {Integer} k
# @return {Integer}
def network_delay_time(times, n, k)
  costs = build_graph(n, times).dijkstra(k)
  costs.shift
  costs.any?(&:nil?) ? -1 : costs.max
end

def build_graph(vertex_count, edges)
  graph = Graph.new(vertex_count + 1) # +1 for 1-based indexing
  edges.each { |src, dest, weight| graph.add_edge(src, dest, weight) }
  graph
end

# A weighted directed graph.
class Graph
  def initialize(vertex_count)
    @adj = Array.new(vertex_count) { [] }
  end

  def add_edge(src, dest, weight)
    raise 'source vertex out of range' unless exists(src)
    raise 'destination vertex out of range' unless exists(dest)
    @adj[src] << [dest, weight]
    nil
  end

  def dijkstra(start)
    raise 'start vertex out of range' unless exists(start)

    costs = [nil] * vertex_count
    heap = PrimHeap.new
    heap.push_or_decrease(start, 0)

    until heap.empty?
      src, src_cost = heap.pop
      costs[src] = src_cost

      @adj[src].each do |dest, weight|
        heap.push_or_decrease(dest, src_cost + weight) unless costs[dest]
      end
    end

    costs
  end

  private

  def vertex_count
    @adj.size
  end

  def exists(vertex)
    vertex.between?(0, vertex_count - 1)
  end
end

# A binary minheap + map data structure for Prim's and Dijkstra's algorithms.
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
