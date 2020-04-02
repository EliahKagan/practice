// https://www.hackerrank.com/challenges/torque-and-development
// In C++14. Using recursive depth-first search.

#include <cassert>
#include <cstdlib>
#include <iostream>
#include <vector>

namespace {
    // Terminates the progam abnormally if the given condition fails.
    inline void ensure(const bool condition) noexcept
    {
        if (!condition) std::abort();
    }

    // Adjacency-list representation of a graph.
    using Graph = std::vector<std::vector<int>>;

    // Visitaton states. (Since std::vector<bool> is a bitset, and weird.)
    enum class Color : bool { white, black };

    // Reads the edges of a graph as an adjacency list.
    Graph read_graph(const int vertex_count, int edge_count)
    {
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

    // Reads and discards the edges of a graph.
    void consume_graph_vertices(int edge_count)
    {
        auto discard = 0;
        for (; edge_count != 0; --edge_count) std::cin >> discard >> discard;
    }

    // Computes the number of components in the given graph.
    int count_components(const Graph& adj)
    {
        auto vis = std::vector<Color>(adj.size(), Color::white);

        const auto dfs = [&](const auto& me, const int src) noexcept {
            if (vis[src] != Color::white) return;
            vis[src] = Color::black;
            for (const auto dest : adj[src]) me(me, dest);
        };

        auto count = 0;
        for (auto start = 1; start != adj.size(); ++start) {
            if (vis[start] != Color::white) continue;
            ++count;
            dfs(dfs, start);
        }

        return count;
    }

    // Computes the cost of an optimal road- and library-building strategy.
    int compute_minimum_cost(const int city_count, const int road_count,
                             const int lib_cost, const int road_cost)
    {
        ensure(city_count >= 0 && road_count >= 0);
        ensure(lib_cost >= 0 && road_cost >= 0);

        if (lib_cost <= road_cost) {
            consume_graph_vertices(road_count);
            return city_count * lib_cost;
        }

        const auto adj = read_graph(city_count, road_count);
        const auto component_count = count_components(adj);
        assert(component_count <= city_count);

        const auto total_lib_cost = component_count * lib_cost;
        const auto total_road_cost = (city_count - component_count) * road_cost;
        return total_lib_cost + total_road_cost;
    }
}

int main()
{
    std::ios_base::sync_with_stdio(false);

    auto q = 0;
    for (std::cin >> q; q > 0; --q) {
        auto city_count = 0, road_count = 0, lib_cost = 0, road_cost = 0;
        std::cin >> city_count >> road_count >> lib_cost >> road_cost;

        std::cout << compute_minimum_cost(city_count, road_count,
                                          lib_cost, road_cost)
                  << '\n';
    }
}
