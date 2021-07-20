# LeetCode #547 - Number of Provinces
# https://leetcode.com/problems/number-of-provinces/
# By BFS.

# @param {Integer[][]} is_connected
# @return {Integer}
def find_circle_num(is_connected)
  order = is_connected.size
  vis = [false] * order

  (0...order).count do |start|
    next false if vis[start]

    vis[start] = true
    queue = [start]

    until queue.empty?
      is_connected[queue.shift].each_with_index do |entry, dest|
        next if entry.zero? || vis[dest]

        vis[dest] = true
        queue << dest
      end
    end

    true
  end
end
