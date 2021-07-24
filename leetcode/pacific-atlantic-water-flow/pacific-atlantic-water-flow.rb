# LeetCode #417 - Pacific Atlantic Water Flow
# https://leetcode.com/problems/pacific-atlantic-water-flow/
# By recursive top-down DP (memoization).

EXPLORING = -1
NONE = 0
PACIFIC = 1
ATLANTIC = 2
BOTH = PACIFIC | ATLANTIC

# @param {Integer[][]} matrix
# @return {Integer[][]}
def pacific_atlantic(matrix)
  height, width = dimensions(matrix)
  dp = Array.new(height) { [nil] * width }

  dfs = lambda do |i, j|
    if (res = dp[i][j])
      return [res, NONE].max if res
    end

    dp[i][j] = EXPLORING

    res = NONE
    res |= PACIFIC if i == 0 || j == 0
    res |= ATLANTIC if i + 1 == height || j + 1 == width

    val = matrix[i][j]

    res |= dfs.call(i, j - 1) if j != 0 && matrix[i][j - 1] <= val
    res |= dfs.call(i, j + 1) if j + 1 != width && matrix[i][j + 1] <= val
    res |= dfs.call(i - 1, j) if i != 0 && matrix[i - 1][j] <= val
    res |= dfs.call(i + 1, j) if i + 1 != height && matrix[i + 1][j] <= val

    dp[i][j] = res
  end

  ret = []
  0.upto(height - 1) do |i|
    0.upto(width - 1) do |j|
      ret << [i, j] if dfs.call(i, j) == BOTH
    end
  end

  ret
end

def dimensions(matrix)
  height = matrix.size
  raise 'empty board not supported' if height.zero?

  width = matrix.first.size
  raise 'jagged board not supported' if matrix.any? { |row| row.size != width }
  raise 'empty rows not supported' if width.zero?

  [height, width]
end
