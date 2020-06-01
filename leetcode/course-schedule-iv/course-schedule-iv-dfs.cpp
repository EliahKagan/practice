class Solution {
public:
    // Given a dependency graph of order n described by an edge list
    // (prerequisites), answers queries of the form {start, end} to indicate
    // if start is a (possibly indirect) dependency of end.
    [[nodiscard]] static vector<bool>
    checkIfPrerequisite(int n,
                        const vector<vector<int>>& prerequisites,
                        const vector<vector<int>>& queries) noexcept;
};

namespace {
    [[nodiscard]] inline tuple<int, int>
    as_vertex_doublet(const int order, const vector<int>& doublet)
    {
        assert(size(doublet) == 2);

        const auto first = doublet.front();
        assert(0 <= first && first < order);

        const auto second = doublet.back();
        assert(0 <= second && second < order);

        return {first, second};
    }

    // Builds an adjacency list for a directed graph with the given order
    // (number of vertices) and edges.
    [[nodiscard]] vector<vector<int>>
    build_adjacency_list(const int order,
                         const vector<vector<int>>& edges) noexcept
    {
        auto adj = vector<vector<int>>(order);

        for_each(cbegin(edges), cend(edges),
                 [order, &adj](const vector<int>& edge) noexcept {
            const auto [src, dest] = as_vertex_doublet(order, edge);
            adj[src].push_back(dest);
        });

        return adj;
    }

    // Searches in a graph represented by an adjacency list to determien if
    // thre is a path from a start verte to an end vertex.
    [[nodiscard]] bool
    can_reach(const vector<vector<int>>& adj,
              const int start, const int end) noexcept
    {
        auto vis = vector<char>(size(adj)); // Because vector<bool> is weird.

        const auto dfs = [&adj, &vis, end](const auto& me,
                                           const int src) noexcept {
            if (vis[src]) return false;
            vis[src] = true;
            if (src == end) return true;

            const auto& row = adj[src];
            return any_of(cbegin(row), cend(row),
                          [&me](const int dest) noexcept {
                return me(me, dest);
            });
        };

        return dfs(dfs, start);
    }
}

vector<bool>
Solution::checkIfPrerequisite(const int n,
                              const vector<vector<int>>& prerequisites,
                              const vector<vector<int>>& queries) noexcept
{
    const auto adj = build_adjacency_list(n, prerequisites);
    auto out = vector<bool>{};
    out.reserve(size(queries));

    transform(cbegin(queries), cend(queries), back_inserter(out),
              [&adj, n](const vector<int>& endpoints) noexcept {
        const auto [start, end] = as_vertex_doublet(n, endpoints);
        return can_reach(adj, start, end);
    });

    return out;
}
