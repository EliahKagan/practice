// https://www.hackerrank.com/challenges/rust-murderer
//
// In C++14. Using BFS and an adjacency list in which each row is an
// unordered_set of *non*-neighbors.

#include <cassert>
#include <cstdlib>
#include <iostream>
#include <iterator>
#include <numeric>
#include <queue>
#include <unordered_set>
#include <vector>

namespace {
    // Terminates the program abnormally if the given condition fails.
    inline void ensure(const bool condition) noexcept
    {
        if (!condition) std::abort();
    }

    // Adjacency-list representation of a graph.
    using Graph = std::vector<std::unordered_set<int>>;

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

            adj[u].insert(v);
            adj[v].insert(u);
        }

        return adj;
    }

    // A vertex in a graph, and the minimum cost to get there.
    struct VertexCostPair {
        int vertex;
        int cost;
    };

    // Given as the minimum cost to reach an unreachable vertex. Conceptually,
    // this value represents positive infinity. Helper for bfs_complement().
    constexpr auto not_reached = -1;

    // Computes minimum cost paths from the specified start vertex to all
    // other vertices, in the "complement" graph that has the same vertices
    // as those in the specified graph, and all the edges the specified graph
    // does *not* have. Takes every edge weight to be 1.
    std::vector<int> bfs_complement(const Graph& adj, const int start)
    {
        // adj has an unused first row, due to 1-based indexing.
        assert(0 < start && start < adj.size());

        auto dests = std::vector<int>(adj.size() - 1);
        std::iota(begin(dests), end(dests), 1);
        auto costs = std::vector<int>(adj.size(), not_reached);
        auto queue = std::queue<VertexCostPair>{};

        const auto visit = [&](const std::vector<int>::iterator destp,
                               const int cost) noexcept {
            costs[*destp] = cost;
            queue.push({*destp, cost});

            // Iterators remain valid: https://stackoverflow.com/q/62340
            *destp = dests.back();
            dests.pop_back();
        };



    }

    /*
    std::vector<int> bfs_complement(const Graph& adj, const int start)
    {
        assert(!adj.empty()); // adj[0] exists and is unused (1-based indexing)
        const auto vertex_count = static_cast<int>(adj.size() - 1);

        auto remaining = vertex_count;
        auto costs = std::vector<int>(adj.size(), not_reached);
        auto queue = std::queue<VertexCostPair>{};

        // Returns true iff BFS is finished.
        const auto visit = [&](const int vertex, const int cost) {
            costs[vertex] = cost;
            if (--remaining == 0) return true;
            queue.push({vertex, cost});
            return false;
        };

        if (visit(start, 0)) return costs;

        while (!queue.empty()) {
            const auto src = queue.front().vertex;
            const auto cost = queue.front().cost;
            queue.pop();

            auto first = cbegin(adj[src]);
            const auto last = cend(adj[src]);

            for (auto dest = 1; dest <= vertex_count; ++dest) {
                if (first != last && *first == dest) {
                    while (++first != last && *first == dest) { }
                }
                else if (costs[dest] == not_reached && visit(dest, cost + 1))
                    return costs;
            }
        }

        std::cerr << "warning: some vertices were not reached\n";
        return costs;
    }
    */

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
    std::ios_base::sync_with_stdio(false);

    auto t = 0;
    for (std::cin >> t; t > 0; --t) {
        const auto adj = read_graph();

        auto start = 0;
        std::cin >> start;
        ensure(0 < start && start < adj.size());

        const auto costs = bfs_complement(adj, start);
        report(costs, start);
    }
}
