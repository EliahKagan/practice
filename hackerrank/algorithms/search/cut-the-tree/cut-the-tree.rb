#!/usr/bin/env ruby
# frozen_string_literal: true

# HackerRank - Cut the Tree
# https://www.hackerrank.com/challenges/cut-the-tree

$VERBOSE = 1

# A vertex-weighted (edge-unweighted) undirected graph.
class Graph
  def initialize(weights)
    @weights = [nil, *weights]
    @total_weight = weights.sum
    @adj = Array.new(@weights.size) { [] }
    @degrees = Array.new(@weights.size, 0)
    @adj[0] = @degrees[0] = nil
  end

  def add_edge(u, v)
    raise 'vertex out of range' unless exists?(u) && exists?(v)

    @adj[u] << v
    @adj[v] << u
    @degrees[u] += 1
    @degrees[v] += 1
    nil
  end

  # Assumes the graph is a tree (or forest) and computes the minimum absolute
  # difference between total weights of components separated by the removal of
  # a single edge.
  def min_cut_difference
    weights = @weights.dup
    degrees = @degrees.dup
    roots = find_roots
    min = Float::INFINITY

    until roots.empty?
      src = roots.shift
      next if degrees[src].zero?

      min = [min, (@total_weight - weights[src] * 2).abs].min
      dest = @adj[src].find { |vertex| degrees[vertex].nonzero? }
      weights[dest] += weights[src]

      degrees[src] -= 1
      degrees[dest] -= 1
      roots << dest if degrees[dest] == 1
    end

    min
  end

  private

  def order
    @weights.size - 1
  end

  def exists?(vertex)
    vertex.between?(1, order)
  end

  def find_roots
    roots = []
    @degrees.each_with_index { |deg, vertex| roots << vertex if deg == 1 }
    roots
  end
end

def read_record(length)
  values = gets.split.map(&:to_i)
  raise 'wrong record length' unless values.size == length
  values
end

def run
  order = gets.to_i
  weights = read_record(order)
  graph = Graph.new(weights)
  (order - 1).times { graph.add_edge(*read_record(2)) }
  puts graph.min_cut_difference
end

run if $PROGRAM_NAME == __FILE__
