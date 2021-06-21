# LeetCode #980 - Unique Paths III
# https://leetcode.com/problems/unique-paths-iii/
# Simple recursive backtracking solution (with visitation list).

# @param {Integer[][]} grid
# @return {Integer}
def unique_paths_iii(grid)
  Board.new(grid).solve
end

# A backtracking solver to count longest paths in a small obstructed grid.
class Board
  def initialize(grid)
    @height = grid.size
    @width = grid.first.size
    @area = @height * @width
    @start_i = @start_j = @end_i = @end_j = nil

    @vis = grid.each_with_index.map do |row, i|
      row.each_with_index.map do |cell, j|
        case cell
        when -1
          @area -= 1
          true
        when 0
          false
        when 1
          @start_i = i
          @start_j = j
          false
        when 2
          @end_i = i
          @end_j = j
          false
        else
          raise "bad cell value: #{cell}"
        end
      end
    end

    return if @start_i && @start_j && @end_i && @end_j
    raise "can't find path endpoints"
  end

  def solve
    go(@start_i, @start_j)
  end

  private

  def go(i, j)
    return 0 if i == -1 || i == @height || j == -1 || j == @width || @vis[i][j]

    @vis[i][j] = true
    @area -= 1
    begin
      if i != @end_i || j != @end_j
        return go(i, j - 1) + go(i, j + 1) + go(i - 1, j) + go(i + 1, j)
      elsif @area.zero?
        return 1
      else
        return 0
      end
    ensure
      @area += 1
      @vis[i][j] = false
    end
  end
end
