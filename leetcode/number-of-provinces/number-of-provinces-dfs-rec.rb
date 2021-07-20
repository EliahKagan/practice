# LeetCode #547 - Number of Provinces
# https://leetcode.com/problems/number-of-provinces/
# By recursive DFS.

# @param {Integer[][]} is_connected
# @return {Integer}
def find_circle_num(is_connected)
  order = is_connected.size
  vis = [false] * order

  dfs = lambda do |src|
    return false if vis[src]

    vis[src] = true

    is_connected[src].each_with_index do |entry, dest|
      dfs.call(dest) unless entry.zero?
    end

    true
  end

  (0...order).count(&dfs)
end
