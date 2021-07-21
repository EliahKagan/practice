# LeetCode 1311 - Get Watched Videos by Your Friends
# https://leetcode.com/problems/get-watched-videos-by-your-friends/
# By BFS.

# @param {String[][]} watched_videos
# @param {Integer[][]} friends
# @param {Integer} id
# @param {Integer} level
# @return {String[]}
def watched_videos_by_friends(watched_videos, friends, id, level)
  vis = [false] * friends.size
  vis[id] = true
  queue = [id]

  level.times do
    queue.size.times do
      friends[queue.shift].each do |dest|
        next if vis[dest]

        vis[dest] = true
        queue << dest
      end
    end
  end

  freqs = Hash.new(0)
  queue.each { |i| watched_videos[i].each { |vid| freqs[vid] += 1 } }
  freqs.sort_by { |vid, freq| [freq, vid] }.map { |vid, _| vid }
end
