# LeetCode #841 - Keys and Rooms
# https://leetcode.com/problems/keys-and-rooms/
# By BFS.

# @param {Integer[][]} rooms
# @return {Boolean}
def can_visit_all_rooms(rooms)
  vis = [false] * rooms.size
  vis[0] = true
  queue = [0]

  until queue.empty?
    rooms[queue.shift].each do |dest|
      next if vis[dest]

      vis[dest] = true
      queue << dest
    end
  end

  vis.all?
end
