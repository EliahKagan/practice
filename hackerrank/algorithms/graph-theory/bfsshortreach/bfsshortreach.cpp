// https://www.hackerrank.com/challenges/bfsshortreach
// In C++14. (Using breadth-first search.)

#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <iterator>
#include <vector>
#include <queue>

namespace {
    // Terminates the program abnormally if the given condition fails.
    inline void ensure(const bool condition) noexcept
    {
        if (!condition) std::abort();
    }

    // Adjacency-list representation of a graph.
    using Graph = std::vector<std::vector<int>>;

    // Visitaton states. (Since std::vector<bool> is a bitset, and weird.)
    enum class Color : bool { white, black };

    // Reads a graph as an adjacency list.
    Graph read_graph()
    {
        auto vertex_count = -1, edge_count = -1;
        std::cin >> vertex_count >> edge_count;
        ensure(vertex_count >= 0);
        ensure(edge_count >= 0);

        auto adj = Graph(vertex_count + 1); // +1 for 1-based indexing

        for (; edge_count != 0; --edge_count) {
            auto u = 0, v = 0;
            std::cin >> u >> v;

            ensure(0 < u && u <= vertex_count);
            ensure(0 < v && v <= vertex_count);

            adj[u].push_back(v);
            adj[v].push_back(u);
        }

        return adj;
    }

    // Given as the minimum cost to reach an unreachable vertex. Conceptually,
    // this value represents positive infinity.
    constexpr auto not_reached = -1;

    // Computes path lengths, with edge weights of 1, from src to each vertex.
    std::vector<int> bfs(const Graph& adj, int src)
    {
        auto costs = std::vector<int>(adj.size(), not_reached);
        costs[src] = 0;
        auto queue = std::queue<int>{};
        queue.push(src);

        for (auto cost = 1; !queue.empty(); ++cost) {
            for (auto breadth = queue.size(); breadth != 0; --breadth) {
                src = queue.front();
                queue.pop();

                for (const auto dest : adj[src]) {
                    if (costs[dest] != not_reached) continue;
                    costs[dest] = cost;
                    queue.push(dest);
                }
            }
        }

        return costs;
    }

    // Increases costs for all reached vertices by the specified factor.
    void scale_costs(std::vector<int>& costs, const int factor) noexcept
    {
        std::transform(cbegin(costs), cend(costs), begin(costs),
                       [factor](const int cost) noexcept {
            return cost == not_reached ? not_reached : cost * factor;
        });
    }

    // Reports the cost of all minimum-cost paths from start, except to itself.
    void report(const std::vector<int>& costs, const int start)
    {
        auto sep = "";
        for (auto vertex = 1; vertex != costs.size(); ++vertex) {
            if (vertex == start) continue;

            std::cout << sep << costs[vertex];
            sep = " ";
        }

        std::cout << '\n';
    }
}

int main()
{
    static constexpr auto edge_weight = 6;

    std::ios_base::sync_with_stdio(false);

    auto q = 0;
    for (std::cin >> q; q > 0; --q) {
        const auto adj = read_graph();

        auto start = 0;
        std::cin >> start;
        ensure(0 < start && start < adj.size());

        auto costs = bfs(adj, start);
        scale_costs(costs, edge_weight);
        report(costs, start);
    }
}
