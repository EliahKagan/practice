# LeetCode #952 - Largest Component Size by Common Factor
# https://leetcode.com/problems/largest-component-size-by-common-factor/
# By union-find (disjoint-set union).

require 'prime'

# @param {Integer[]} nums
# @return {Integer}
def largest_component_size(nums)
  # Treat all input numbers as weight-1 elements.
  nodes = nums.map { |num| [num, Node.new(1)] }.to_h

  # Connect them to their prime factors, treated as weight-0 elements if new.
  nums.each do |num| # Loop just through nums while we modify nodes.
    Prime.prime_division(num).each do |prime, _power|
      nodes[num].union(nodes[prime] ||= Node.new(0))
    end
  end

  nodes.each_value.map(&:component_weight).max
end

# Node representing a weighted element in a disjoint-set union data structure.
class Node
  def initialize(weight)
    @parent = self
    @rank = 0
    @weight = weight
  end

  def component_weight
    findset.weight
  end

  def union(other)
    elem1 = findset
    elem2 = other.findset
    return if elem1 == elem2

    if elem1.rank < elem2.rank
      elem1.parent = elem2
      elem2.weight += elem1.weight
    else
      elem1.rank += 1 if elem1.rank == elem2.rank
      elem2.parent = elem1
      elem1.weight += elem2.weight
    end
  end

  protected

  def findset
    @parent = @parent.findset if self != @parent
    @parent
  end

  attr_writer :parent
  attr_accessor :rank, :weight
end
