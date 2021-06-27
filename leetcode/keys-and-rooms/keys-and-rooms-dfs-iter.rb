# LeetCode #841 - Keys and Rooms
# https://leetcode.com/problems/keys-and-rooms/
# By iterative DFS.

# @param {Integer[][]} rooms
# @return {Boolean}
def can_visit_all_rooms(rooms)
  vis = [false] * rooms.size
  vis[0] = true
  stack = [0]

  until stack.empty?
    rooms[stack.pop].each do |dest|
      next if vis[dest]

      vis[dest] = true
      stack << dest
    end
  end

  vis.all?
end
