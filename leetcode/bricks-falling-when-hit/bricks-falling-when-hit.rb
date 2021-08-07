# LeetCoe #803 - Bricks Falling When Hit
# https://leetcode.com/problems/bricks-falling-when-hit/

# @param {Integer[][]} grid
# @param {Integer[][]} hits
# @return {Integer[]}
def hit_bricks(grid, hits) # Mutates grid.
  deferred = defer(grid, hits)
  wall = build_wall(grid)
  old_count = wall.hanging_population
  ret = []

  deferred.each do |coords|
    unless coords
      ret << 0
      next
    end

    wall.add(*coords)
    count = wall.hanging_population

    if count == old_count
      ret << 0
    else
      ret << count - old_count - 1
      old_count = count
    end
  end

  ret.reverse!
end

def defer(grid, hits)
  deferred = []

  hits.reverse_each do |i, j|
    if grid[i][j].zero?
      deferred << nil
    else
      grid[i][j] = 0
      deferred << [i, j]
    end
  end

  deferred
end

def build_wall(grid)
  wall = Wall.new(grid.size, grid.first.size)

  grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      wall.add(i, j) unless cell.zero?
    end
  end

  wall
end

# A hanging wall under construction.
class Wall
  def initialize(height, width)
    @rows = Array.new(height) { [nil] * width }
    @root = Node.new
  end

  def hanging_population
    @root.population - 1
  end

  def add(i, j)
    raise "brick already added at (#{i}, #{j})" if @rows[i][j]

    @rows[i][j] = node = Node.new
    @root.union(node) if i.zero?

    node.union(@rows[i][j - 1]) if j.nonzero? && @rows[i][j - 1]
    node.union(@rows[i][j + 1]) if j + 1 != width && @rows[i][j + 1]
    node.union(@rows[i - 1][j]) if i.nonzero? && @rows[i - 1][j]
    node.union(@rows[i + 1][j]) if i + 1 != height && @rows[i + 1][j]

    nil
  end

  private

  def height
    @rows.size
  end

  def width
    @rows.first.size
  end
end

# A node for disjoint-set union operations supporting population queries.
class Node
  def initialize
    @parent = self
    @size = 1
  end

  def population
    find_set.size
  end

  def union(other)
    # Find the ancestors and stop if they are already the same.
    node1 = find_set
    node2 = other.find_set
    return if node1 == node2

    # Unite by size.
    if node1.size < node2.size
      node2.join(node1)
    else
      node1.join(node2)
    end
  end

  protected

  attr_accessor :parent
  attr_reader :size

  def find_set
    @parent = @parent.find_set if self != @parent
    @parent
  end

  def join(child)
    @size += child.size
    child.parent = self
    nil
  end
end
