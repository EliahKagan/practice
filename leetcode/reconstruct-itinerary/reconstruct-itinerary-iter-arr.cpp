// LeetCode #332 - Reconstruct Itinerary
// https://leetcode.com/problems/reconstruct-itinerary/
// By Hierholzer's algorithm, iteratively building an array in reverse.

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

    // Hierholzer's algorithm, emitting an Eulerian path in reverse.
    void dfs(Graph& adj, vector<string>& out, const string start) noexcept
    {
        auto stack = std::stack<string>{};

        for (stack.push(start); !empty(stack); ) {
            if (auto& row = adj[stack.top()]; empty(row)) {
                out.push_back(stack.top());
                stack.pop();
            } else {
                stack.push(row.back());
                row.pop_back();
            }
        }
    }
}

vector<string>
Solution::findItinerary(const vector<vector<string>>& tickets) noexcept
{
    auto adj = build_adjacency_list(tickets);
    auto out = vector<string>{};
    dfs(adj, out, "JFK");
    reverse(begin(out), end(out));
    return out;
}
