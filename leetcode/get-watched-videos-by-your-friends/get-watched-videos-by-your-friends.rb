# LeetCode 1311 - Get Watched Videos by Your Friends
# https://leetcode.com/problems/get-watched-videos-by-your-friends/
# By BFS.

# @param {String[][]} watched_videos
# @param {Integer[][]} friends
# @param {Integer} id
# @param {Integer} level
# @return {String[]}
def watched_videos_by_friends(watched_videos, friends, id, level)
  vids = bfs_level(friends, id, level).flat_map { |i| watched_videos[i] }
  consolidate_sort(vids)
end

def bfs_level(adj, start, level)
  vis = [false] * adj.size
  vis[start] = true
  queue = [start]

  level.times do
    queue.size.times do
      adj[queue.shift].each do |dest|
        next if vis[dest]

        vis[dest] = true
        queue << dest
      end
    end
  end

  queue
end

def consolidate_sort(videos)
  freqs = Hash.new(0)
  videos.each { |vid| freqs[vid] += 1 }
  freqs.sort_by { |vid, freq| [freq, vid] }.map { |vid, _| vid }
end
