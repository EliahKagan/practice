# LeetCode #329 - Longest Increasing Path in a Matrix
# https://leetcode.com/problems/longest-increasing-path-in-a-matrix/
# By memoized iterative implicit-graph postorder DFS, similar to DFS toposort.

# @param {Integer[][]} matrix
# @return {Integer}
def longest_increasing_path(matrix)
  height = matrix.size
  width = matrix.first.size
  dp = {} # maximum forward path lengths

  dfs = lambda do |start_i, start_j|
    ret = dp[[start_i, start_j]]
    return ret unless ret.nil?

    stack = [Frame.new(start_i, start_j)]

    until stack.empty?
      frame = stack.last
      i = frame.i
      j = frame.j

      case frame.state
      when :left
        frame.state = :right

        if j.zero? || matrix[i][j] >= matrix[i][j - 1]
          ret = 0
        elsif (ret = dp[[i, j - 1]]).nil?
          stack << Frame.new(i, j - 1)
        end

      when :right
        frame.acc = ret if frame.acc < ret
        frame.state = :up

        if j + 1 == width || matrix[i][j] >= matrix[i][j + 1]
          ret = 0
        elsif (ret = dp[[i, j + 1]]).nil?
          stack << Frame.new(i, j + 1)
        end

      when :up
        frame.acc = ret if frame.acc < ret
        frame.state = :down

        if i.zero? || matrix[i][j] >= matrix[i - 1][j]
          ret = 0
        elsif (ret = dp[[i - 1, j]]).nil?
          stack << Frame.new(i - 1, j)
        end

      when :down
        frame.acc = ret if frame.acc < ret
        frame.state = :retreat

        if i + 1 == height || matrix[i][j] >= matrix[i + 1][j]
          ret = 0
        elsif (ret = dp[[i + 1, j]]).nil?
          stack << Frame.new(i + 1, j)
        end

      when :retreat
        frame.acc = ret if frame.acc < ret
        dp[[i, j]] = ret = frame.acc + 1
        stack.pop

      else
        raise "unrecognized state: #{frame.state}"
      end
    end

    ret
  end

  (0...height).map { |i| (0...width).map { |j| dfs.call(i, j) }.max }.max
end

# A stack frame for iteratively implemented recursive implicit-graph DFS.
class Frame
  attr_reader :i, :j
  attr_accessor :acc, :state

  def initialize(i, j)
    @i = i
    @j = j
    @acc = 0
    @state = :left
  end
end
