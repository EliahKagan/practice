// LeetCode 1311 - Get Watched Videos by Your Friends
// https://leetcode.com/problems/get-watched-videos-by-your-friends/
// By BFS.

class Solution {
public:
    [[nodiscard]] static vector<string>
    watchedVideosByFriends(const vector<vector<string>>& watchedVideos,
                           const vector<vector<int>>& friends,
                           int id,
                           int level) noexcept;
};

namespace {
    [[nodiscard]] vector<int> bfs_level(const vector<vector<int>>& adj,
                                        const int start,
                                        int level) noexcept
    {
        auto vis = vector<char>(size(adj));
        vis[start] = true;

        auto cur = vector{start};
        auto nxt = vector<int>{};

        while (level-- > 0) {
            for (const auto src : cur) {
                for (const auto dest : adj[src]) {
                    if (vis[dest]) continue;

                    vis[dest] = true;
                    nxt.push_back(dest);
                }
            }

            cur.clear();
            swap(cur, nxt);
        }

        return cur;
    }

    [[nodiscard]] vector<string>
    concat_indexed_bins(const vector<vector<string>>& bins,
                        const vector<int>& indices) noexcept
    {
        auto out = vector<string>{};

        for (const auto i : indices)
            copy(cbegin(bins[i]), cend(bins[i]), back_inserter(out));

        return out;
    }

    [[nodiscard]] vector<string>
    consolidate_sort(const vector<string>& videos) noexcept
    {
        auto out = vector<string>{};
        auto freqs = unordered_map<string, int>{};

        for (const auto& vid : videos)
            if (freqs[vid]++ == 0) out.push_back(vid);

        sort(begin(out), end(out), [&freqs](const string& lhs,
                                            const string& rhs) noexcept {
            const auto lhs_freq = freqs[lhs];
            const auto rhs_freq = freqs[rhs];
            return lhs_freq == rhs_freq ? lhs < rhs : lhs_freq < rhs_freq;
        });

        return out;
    }
}

vector<string>
Solution::watchedVideosByFriends(const vector<vector<string>>& watchedVideos,
                                 const vector<vector<int>>& friends,
                                 const int id,
                                 const int level) noexcept
{
    const auto level_ids = bfs_level(friends, id, level);
    return consolidate_sort(concat_indexed_bins(watchedVideos, level_ids));
}
