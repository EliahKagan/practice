#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/journey-to-the-moon
# In Ruby. Using iteratively implemented recursive depth-first search.

$VERBOSE = 1

# Adjacency-list representation of an unweighted undirected graph.
class Graph
  def initialize(order)
    @adj = Array.new(order) { [] }
  end

  def add_edge(vertex1, vertex2)
    raise IndexError, 'edge vertex1 is out of range' unless exists?(vertex1)
    raise IndexError, 'edge vertex2 us out of range' unless exists?(vertex2)

    @adj[vertex1] << vertex2
    @adj[vertex2] << vertex1
  end

  # Counts vertices in each component.
  def component_orders
    vis = [false] * @adj.size

    (0...@adj.size)
      .lazy
      .reject { |start| vis[start] }
      .map { |start| dfs(vis, start) }
  end

  # Stack frame for iteratively implementing recursive depth-first search.
  class Frame
    def initialize(row)
      @row = row
      @index = 0
    end

    def next
      return nil if @index == @row.size

      ret = @row[@index]
      @index += 1
      ret
    end
  end
  private_constant :Frame

  private

  def dfs(vis, start)
    raise 'Bug: start vertex already visited' if vis[start]

    vis[start] = true
    stack = [Frame.new(@adj[start])]
    count = 1

    until stack.empty?
      dest = stack[-1].next
      if dest.nil?
        stack.pop
      elsif !vis[dest]
        vis[dest] = true
        count += 1
        stack.push(Frame.new(@adj[dest]))
      end
    end

    count
  end

  def exists?(vertex)
    vertex.between?(0, @adj.size - 1)
  end
end

def read_record
  gets.split.map(&:to_i)
end

def read_graph
  vertex_count, edge_count = read_record
  graph = Graph.new(vertex_count)
  edge_count.times { graph.add_edge(*read_record) }
  graph
end

def count_pairs(cardinalities)
  singles = pairs = 0

  cardinalities.each do |cardinality|
    pairs += singles * cardinality
    singles += cardinality
  end

  pairs
end

puts count_pairs(read_graph.component_orders)
