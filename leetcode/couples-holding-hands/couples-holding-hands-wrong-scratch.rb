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

  place = lambda do |a, b|
    if permutation[a].nil?
      STDERR.puts "[#{a}] = #{b}"
      permutation[a] = b
    elsif permutation[b].nil?
      STDERR.puts "[#{b}] = #{a}"
      permutation[b] = a
    else
      STDERR.puts "can't place #{a}, #{b} in #{permutation}"
      raise 'bug or not a permutation'
    end
  end

  row.each_slice(2) { |p, q| place.call(p / 2, q / 2) if p.even? == q.even? }
  row.each_slice(2) { |p, q| place.call(p / 2, q / 2) if p.even? != q.even? }

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
