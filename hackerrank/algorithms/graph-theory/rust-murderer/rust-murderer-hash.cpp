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
    // this value represents positive infinity.
    constexpr auto not_reached = -1;

    // Gets all the destination vertices. Helper for bfs_complement().
    std::vector<int> get_all_dets(const int vertex_count, const int start)
    {
        auto dests = std::vector<int>(vertex_count - 1);
        std::iota(begin(dests), begin(dests) + (start - 1), 1);
        std::iota(begin(dests) + start, end(dests), start + 1);

        // FIXME: Remove after debugging.
        std::cerr << "DEBUG:";
        for (const auto dest : dests) std::cerr << ' ' << dest;
        std::cerr << '\n';

        return dests;
    }

    // Gets the initial costs, not_reached everywhere but the start vertex.
    // Helper for bfs_complement().
    std::vector<int> get_unpopulated_costs(const int vertex_count,
                                           const int start)
    {
        auto costs = std::vector<int>(vertex_count + 1, not_reached);
        costs[start] = 0;
        return costs;
    }

    // Gets the initial queue, with only an entry for the start vertex.
    // Helper for bfs_complement().
    std::queue<VertexCostPair> get_start_queue(const int start)
    {
        auto queue = std::queue<VertexCostPair>{};
        queue.push({start, 0});
        return queue;
    }

    // Computes minimum cost paths from the specified start vertex to all
    // other vertices, in the "complement" graph that has the same vertices
    // as those in the specified graph, and all the edges the specified graph
    // does *not* have. Takes every edge weight to be 1.
    std::vector<int> bfs_complement(const Graph& adj, const int start)
    {
        // adj has an unused first row, due to 1-based indexing.
        assert(0 < start && start < adj.size());

        auto dests = get_all_dets(adj.size() - 1, start);
        auto costs = get_unpopulated_costs(adj.size() - 1, start);
        if (dests.empty()) return costs;

        for (auto queue = get_start_queue(start); !queue.empty(); ) {
            const auto& row = adj[queue.front().vertex];
            const auto cost = queue.front().cost + 1; // edge weight of 1
            queue.pop();

            for (auto destp = begin(dests); destp != end(dests); ) {
                if (row.count(*destp)) {
                    // Can't go directly to *destp: it's a non-neighbor.
                    ++destp;
                    continue;
                } else {
                    costs[*destp] = cost;
                    queue.push({*destp, cost});

                    *destp = dests.back();
                    dests.pop_back();
                    if (dests.empty()) return costs;
                    // *destp remains valid: https://stackoverflow.com/q/62340
                }
            }
        }

        std::cerr << "warning: some vertices were not reached\n";
        return costs;
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
