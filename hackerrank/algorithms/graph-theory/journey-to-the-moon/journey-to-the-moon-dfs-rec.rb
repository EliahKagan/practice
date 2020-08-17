#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/journey-to-the-moon
# In Ruby. Using recursive depth-first search.

$VERBOSE = 1

# Adjacency-list representation of an unweighted undirected graph.
class Graph
  def initialize(order)
    @adj = Array.new(order) { [] }
  end

  def add_edge(vertex1, vertex2)
    raise IndexError, 'edge u is out of range' unless exists?(vertex1)
    raise IndexError, 'edge v us out of range' unless exists?(vertex2)

    @adj[vertex1] << vertex2
    @adj[vertex2] << vertex1
  end

  # Counts vertices in each component.
  def component_orders
    vis = [false] * @adj.size
    (0...@adj.size).lazy.map { |start| dfs(vis, start) }.reject(&:zero?)
  end

  private

  def dfs(vis, src)
    return 0 if vis[src]

    vis[src] = true
    1 + @adj[src].sum { |dest| dfs(vis, dest) }
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
