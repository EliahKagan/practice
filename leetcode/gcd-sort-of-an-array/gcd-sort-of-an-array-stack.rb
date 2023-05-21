# LeetCode #1998 - GCD Sort of an Array
# https://leetcode.com/problems/gcd-sort-of-an-array/
# By stack-based search.

require 'prime'

# @param {Integer[]} nums
# @return {Boolean}
def gcd_sort(nums)
  labels = build_graph(nums).label_components
  nums.zip(nums.sort).all? { |before, after| labels[before] == labels[after] }
end

# Represent transitive swappability as connectivity.
def build_graph(nums)
  graph = Graph.new

  nums.uniq.each do |num|
    Prime.prime_division(num).each do |prime, _power|
      graph.add_edge(num, prime)
    end
  end

  graph
end

# Unweighted undirected graph that supports labeling components.
class Graph
  def initialize
    @adj = Hash.new { |hash, key| hash[key] = [] }
  end

  def add_edge(vertex1, vertex2)
    @adj[vertex1] << vertex2
    @adj[vertex2] << vertex1
    nil
  end

  def label_components
    labels = {}
    @adj.each_key { |start| bfs(labels, start) unless labels.key?(start) }
    labels
  end

  private

  def bfs(labels, start)
    labels[start] = start
    fringe = [start]

    until fringe.empty?
      @adj[fringe.pop].each do |dest|
        next if labels.key?(dest)

        labels[dest] = start
        fringe << dest
      end
    end
  end
end
