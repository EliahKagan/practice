# LeetCode #1926 - Nearest Exit from Entrance in Maze
# https://leetcode.com/problems/nearest-exit-from-entrance-in-maze/

# @param {Character[][]} maze
# @param {Integer[]} entrance
# @return {Integer}
def nearest_exit(maze, entrance)
  imax = maze.size - 1
  jmax = maze.first.size - 1

  i, j = entrance
  maze[i][j] = '+'
  queue = [entrance]

  (1..).each do |depth|
    return -1 if queue.empty?

    queue.size.times do
      i, j = queue.shift

      [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].each do |h, k|
        next unless h.between?(0, imax) && k.between?(0, jmax)
        next if maze[h][k] != '.'

        maze[h][k] = '+'
        return depth if h.zero? || h == imax || k.zero? || k == jmax

        queue << [h, k]
      end
    end
  end
end
