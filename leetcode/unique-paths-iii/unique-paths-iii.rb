# LeetCode #980 - Unique Paths III
# https://leetcode.com/problems/unique-paths-iii/
# Simple recursive backtracking solution (with visitation list).

# @param {Integer[][]} grid
# @return {Integer}
def unique_paths_iii(grid)
  height = grid.size
  width = grid.first.size
  area = height * width
  start_i = start_j = end_i = end_j = nil

  vis = Array.new(height) do |i|
    Array.new(width) do |j|
      case grid[i][j]
      when -1
        area -= 1
        true
      when 0
        false
      when 1
        start_i = i
        start_j = j
        false
      when 2
        end_i = i
        end_j = j
        false
      end
    end
  end

  raise "can't find path endpoints" unless start_i && start_j && end_i && end_j

  solve = lambda do |i, j|
    return 0 if i == -1 || i == height || j == -1 || j == width || vis[i][j]

    vis[i][j] = true
    area -= 1
    begin
      if i != end_i || j != end_j
        return solve.call(i, j - 1) +
               solve.call(i, j + 1) +
               solve.call(i - 1, j) +
               solve.call(i + 1, j)
      elsif area.zero?
        return 1
      else
        return 0
      end
    ensure
      area += 1
      vis[i][j] = false
    end
  end

  solve.call(start_i, start_j)
end
