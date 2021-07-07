# LeetCode 765 - Couples Holding Hands
# https://leetcode.com/problems/couples-holding-hands/
# By partitioning a permutation of buckets into cycles (does not work).

# @param {Integer[]} row
# @return {Integer}
def min_swaps_couples(row)
  permutation = build_permutation(row)
  permutation.size - count_cycles(permutation)
end

def build_permutation(row)
  permutation = []

  row.each_slice(2) do |a, b|
    a /= 2
    b /= 2

    if permutation[a].nil?
      permutation[a] = b
    elsif permutation[b].nil?
      permutation[b] = a
    else
      raise 'bug or not a permutation'
    end
  end

  raise 'unexpected permutation size' if permutation.size * 2 != row.size
  permutation
end

def count_cycles(permutation)
  vis = [false] * permutation.size

  (0...permutation.size).count do |i|
    next false if vis[i]

    until vis[i]
      vis[i] = true
      i = permutation[i]
    end

    true
  end
end
