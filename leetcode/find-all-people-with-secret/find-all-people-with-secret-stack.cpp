// LeetCode #2092 - Find All People With Secret
// https://leetcode.com/problems/find-all-people-with-secret/
// By grouping by time, sorting, and stack-based search for each group.

class Solution {
public:
    [[nodiscard]]
    static vector<int> findAllPeople(int n,
                                     vector<vector<int>>& meetings,
                                     int firstPerson) noexcept;
};

namespace {
    using It = vector<vector<int>>::const_iterator;

    constexpr auto x_index = 0;
    constexpr auto y_index = 1;
    constexpr auto time_index = 2;

    void sort_by_time(vector<vector<int>>& meetings) noexcept
    {
        sort(begin(meetings), end(meetings), [](const auto& lhs,
                                                const auto& rhs) noexcept {
            return lhs[time_index] < rhs[time_index];
        });
    }

    void bfs(vector<char>& vis, const It left, const It right) noexcept
    {
        // Build the graph.
        auto adj = unordered_map<int, vector<int>>{};
        for_each(left, right, [&adj](const vector<int>& meeting) noexcept {
            const auto x = meeting[x_index];
            const auto y = meeting[y_index];
            adj[x].push_back(y);
            adj[y].push_back(x);
        });

        // Find roots for the BFS traversal.
        auto fringe = stack<int>{};
        for (const auto& [vertex, _] : adj)
            if (vis[vertex]) fringe.push(vertex);

        // Do the stack-based traversal, marking reachable vertices.
        while (!empty(fringe)) {
            const auto src = fringe.top();
            fringe.pop();

            for (const auto dest : adj[src]) {
                if (vis[dest]) continue;
                vis[dest] = true;
                fringe.push(dest);
            }
        }
    }

    void bfs_each_chunk(vector<char>& vis,
                        const vector<vector<int>>& meetings) noexcept
    {
        const auto stop = cend(meetings);
        auto left = cbegin(meetings);
        auto right = cbegin(meetings);

        while (left != stop) {
            const auto time = (*left)[time_index];
            while (++right != stop && (*right)[time_index] == time) { }
            bfs(vis, left, right);
            left = right;
        }
    }

    [[nodiscard]]
    vector<int> get_true_indices(const vector<char>& bits) noexcept
    {
        auto true_indices = vector<int>{};

        const auto stop = static_cast<int>(size(bits));
        for (auto index = 0; index != stop; ++index)
            if (bits[index]) true_indices.push_back(index);

        return true_indices;
    }
}

vector<int> Solution::findAllPeople(const int n,
                                    vector<vector<int>>& meetings,
                                    const int firstPerson) noexcept
{
    auto vis = vector<char>(n); // To avoid the vector<bool> specialization.
    vis[0] = vis[firstPerson] = true;
    sort_by_time(meetings);
    bfs_each_chunk(vis, meetings);
    return get_true_indices(vis);
}
