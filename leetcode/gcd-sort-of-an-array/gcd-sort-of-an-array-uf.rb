# LeetCode #1998 - GCD Sort of an Array
# https://leetcode.com/problems/gcd-sort-of-an-array/
# By union-find (disjoint-set union).

require 'prime'

# @param {Integer[]} nums
# @return {Boolean}
def gcd_sort(nums)
  nodes = Hash.new { |hash, key| hash[key] = Node.new }

  # Represent transitive swappability as connectivity.
  nums.each do |num|
    Prime.prime_division(num).each do |prime, _power|
      nodes[num].union(nodes[prime])
    end
  end

  # Check if it would be permissible to sort the values.
  nums.zip(nums.sort).all? do |before, after|
    nodes[before].findset == nodes[after].findset
  end
end

# Node representing an element in a disjoint-set union data structure.
class Node
  def initialize
    @parent = self
    @rank = 0
  end

  def findset
    @parent = @parent.findset if self != @parent
    @parent
  end

  def union(other)
    elem1 = findset
    elem2 = other.findset
    return if elem1 == elem2

    if elem1.rank < elem2.rank
      elem1.parent = elem2
    else
      elem1.rank += 1 if elem1.rank == elem2.rank
      elem2.parent = elem1
    end
  end

  protected

  attr_writer :parent
  attr_accessor :rank
end
