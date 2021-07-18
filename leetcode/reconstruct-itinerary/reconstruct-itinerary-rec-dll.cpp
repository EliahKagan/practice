// LeetCode #332 - Reconstruct Itinerary
// https://leetcode.com/problems/reconstruct-itinerary/
// By Hierholzer's algorithm, recursively building a doubly linked list.

class Solution {
public:
    [[nodiscard]] static vector<string>
    findItinerary(const vector<vector<string>>& tickets) noexcept;
};

namespace {
    // An adjacency list representing a graph.
    using Graph = unordered_map<string, vector<string>>;

    [[nodiscard]] Graph
    build_adjacency_list(const vector<vector<string>>& edges) noexcept
    {
        auto adj = Graph{};

        for (const auto& edge : edges) {
            assert(size(edge) == 2);
            adj[edge[0]].push_back(edge[1]);
        }

        for (auto& [src, row] : adj) sort(begin(row), end(row), greater<>{});

        return adj;
    }

    [[nodiscard]] list<string>
    hierholzer(Graph& adj, const string start) noexcept
    {
        auto out = list<string>{""};

        const auto dfs = [&adj, &out](const auto& me,
                                      const auto src,
                                      const auto outpos) noexcept -> void {
            out.insert(next(outpos), src);

            for (auto& row = adj[src]; !empty(row); ) {
                const auto dest = row.back();
                row.pop_back();

                me(me, dest, next(outpos));
            }
        };

        dfs(dfs, start, cbegin(out));
        out.pop_front(); // Remove the leading "".
        return out;
    }
}

vector<string>
Solution::findItinerary(const vector<vector<string>>& tickets) noexcept
{
    auto adj = build_adjacency_list(tickets);
    const auto out = hierholzer(adj, "JFK");
    return vector(cbegin(out), cend(out));
}
