# LeetCode #417 - Pacific Atlantic Water Flow
# https://leetcode.com/problems/pacific-atlantic-water-flow/
# By BFS.

# @param {Integer[][]} heights
# @return {Integer[][]}
def pacific_atlantic(heights)
  board = Board.new(heights)
  (board.bfs(board.north_west) & board.bfs(board.south_east)).sort
end

# A grid representing the island receiving rainfall.
class Board
  def initialize(rows)
    @rows = rows.map(&:dup)
    raise 'empty board not supported' if height.zero?
    raise 'jagged board not supported' if @rows.any? { |row| row.size != width }
    raise 'empty rows not supported' if width.zero?
  end

  def north_west
    (0...width).map { |j| [0, j] } + (1...height).map { |i| [i, 0] }
  end

  def south_east
    (0...(height - 1)).map { |i| [i, width - 1] } +
        (0...width).map { |j| [height - 1, j] }
  end

  def bfs(roots)
    vis = Set.new(roots)

    until roots.empty?
      i, j = roots.shift
      elem = @rows[i][j]

      [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].each do |h, k|
        next if !exists?(h, k) || @rows[h][k] < elem || vis.include?([h, k])

        vis << [h, k]
        roots << [h, k]
      end
    end

    vis
  end

  private

  def height
    @rows.size
  end

  def width
    @rows.first.size
  end

  def exists?(i, j)
    i.between?(0, height - 1) && j.between?(0, width - 1)
  end
end
