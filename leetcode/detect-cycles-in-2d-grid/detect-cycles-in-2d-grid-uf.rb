# LeetCode #1559 - Detect Cycles in 2D Grid
# https://leetcode.com/problems/detect-cycles-in-2d-grid/
# By union-find.

# @param {Character[][]} grid
# @return {Boolean}
def contains_cycle(grid)
  height = grid.size
  width = grid.first.size
  nodes = Array.new(height) { Array.new(width) { Node.new } }

  0.upto(height - 1) do |i|
    0.upto(width - 1) do |j|
      return true unless j + 1 == width ||
                         grid[i][j] != grid[i][j + 1] ||
                         nodes[i][j].union(nodes[i][j + 1])

      return true unless i + 1 == height ||
                         grid[i][j] != grid[i + 1][j] ||
                         nodes[i][j].union(nodes[i + 1][j])
    end
  end

  false
end

# A node for disjoint-set union operations.
class Node
  def initialize
    @parent = self
    @rank = 0
  end

  # Unites two nodes into the same set. Returns true iff they were separate.
  def union(other)
    # Find the ancestors and stop if they are already the same.
    node1 = find_set
    node2 = other.find_set
    return false if node1 == node2

    # Union by rank.
    if node1.rank < node2.rank
      node1.parent = node2
    else
      node1.rank += 1 if node1.rank == node2.rank
      node2.parent = node1
    end

    true
  end

  protected

  attr_accessor :parent, :rank

  def find_set
    @parent = @parent.find_set if self != @parent
    @parent
  end
end
