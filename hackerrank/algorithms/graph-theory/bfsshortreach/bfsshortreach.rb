#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/bfsshortreach

$VERBOSE = 1

# An unweighted undirected graph.
class Graph
  def initialize(order)
    @adj = Array.new(order) { [] }
  end

  def add_edge(u, v)
    check_vertex(u)
    check_vertex(v)

    @adj[u] << v
    @adj[v] << u
  end

  def bfs(start)
    check_vertex(start)

    costs = Array.new(order, nil)
    costs[0] = depth = 0
    queue = [start]

    until queue.empty?
      depth += 1

      queue.size.times do
        @adj[queue.shift].each do |dest|
          next if costs[dest]

          costs[dest] = depth
          queue.push(dest)
        end
      end
    end

    costs
  end

  def order
    @adj.size
  end

  private

  def check_vertex(vertex)
    unless vertex.between?(0, order - 1)
      raise ArgumentError, 'vertex out of range'
    end
  end
end

EDGE_WEIGHT = 6
NO_PATH = -1

def read_record
  gets.split.map(&:to_i)
end

def read_graph
  order, size = read_record
  graph = Graph.new(order + 1) # +1 for 1-based indexing

  size.times do
    u, v = read_record
    graph.add_edge(u, v)
  end

  graph
end

def print_scaled_costs(costs, start)
  output = (costs[1...start] + costs[(start + 1)..])
    .map { |cost| cost ? cost * EDGE_WEIGHT : NO_PATH }
    .join(' ')

  puts output
end

gets.to_i.times do
  graph = read_graph
  start = gets.to_i
  print_scaled_costs(graph.bfs(start), start)
end
