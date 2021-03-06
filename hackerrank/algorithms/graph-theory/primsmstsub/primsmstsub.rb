#!/usr/bin/env ruby
# frozen_string_literal: true

# "Prim's (MST) : Special Subtree" on HackerRank
# https://www.hackerrank.com/challenges/primsmstsub
# Using a binary minheap + map data structure.

$VERBOSE = 1

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

# A weighted undirected graph.
class Graph
  def initialize(vertex_count)
    @adj = Array.new(vertex_count) { [] }
  end

  def vertex_count
    @adj.size
  end

  def add_edge(u, v, weight)
    raise 'endpoint vertex out of range' unless exists?(u) && exists?(v)

    @adj[u] << make_out_edge(v, weight)
    @adj[v] << make_out_edge(u, weight)
    nil
  end

  # Sums the weights of edges in the component that contains the start vertex,
  # using Prim's algorithm.
  def prim_mst(start)
    raise 'start vertex out of range' unless exists?(start)

    total_cost = 0
    vis = [false] * vertex_count
    heap = PrimHeap.new
    heap.push_or_decrease(start, 0)

    until heap.empty?
      src, src_cost = heap.pop
      vis[src] = true
      total_cost += src_cost

      @adj[src].each do |out_edge|
        dest, weight = *out_edge
        heap.push_or_decrease(dest, weight) unless vis[dest]
      end
    end

    total_cost
  end

  private

  def exists?(vertex)
    vertex.between?(0, vertex_count - 1)
  end

  def make_out_edge(dest, weight)
    OutEdge.new(dest, weight).freeze
  end

  OutEdge = Struct.new(:dest, :weight)
  private_constant :OutEdge
end

def read_record
  gets.split.map(&:to_i)
end

def build_graph
  vertex_count, edge_count = read_record
  graph = Graph.new(vertex_count + 1) # +1 for 1-based indexing
  edge_count.times { graph.add_edge(*read_record) }
  graph
end

if $PROGRAM_NAME == __FILE__
  graph = build_graph
  start = gets.to_i
  puts graph.prim_mst(start)
end
