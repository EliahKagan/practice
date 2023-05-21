# LeetCode #1998 - GCD Sort of an Array
# https://leetcode.com/problems/gcd-sort-of-an-array/
# By recursive DFS (depth-first search).

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

    dfs = lambda do |label, src|
      labels[src] = label
      @adj[src].each { |dest| dfs.call(label, dest) unless labels.key?(dest) }
    end

    @adj.each_key { |start| dfs.call(start, start) unless labels.key?(start) }
    labels
  end
end
