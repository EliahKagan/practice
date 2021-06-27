# LeetCode #841 - Keys and Rooms
# https://leetcode.com/problems/keys-and-rooms/
# By recursive DFS.

# @param {Integer[][]} rooms
# @return {Boolean}
def can_visit_all_rooms(rooms)
  vis = [false] * rooms.size

  dfs = lambda do |src|
    return if vis[src]

    vis[src] = true
    rooms[src].each(&dfs)
  end

  dfs.call(0)
  vis.all?
end
