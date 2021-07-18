// LeetCode #332 - Reconstruct Itinerary
// https://leetcode.com/problems/reconstruct-itinerary/
// By Hierholzer's algorithm, iteratively building a singly linked list.

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

    [[nodiscard]] forward_list<string>
    hierholzer(Graph& adj, const string start) noexcept
    {
        auto out = forward_list<string>{};
        auto stack = std::stack<forward_list<string>::const_iterator>{};

        const auto visit = [&stack, &out](const auto outpos,
                                          const auto vertex) noexcept {
            stack.push(out.insert_after(outpos, vertex));
        };

        for (visit(out.cbefore_begin(), start); !empty(stack); ) {
            if (auto& row = adj[*stack.top()]; empty(row)) {
                stack.pop();
            } else {
                visit(stack.top(), row.back());
                row.pop_back();
            };
        }

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
