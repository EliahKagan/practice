// https://www.hackerrank.com/challenges/journey-to-the-moon
// In C++14. Using recursive depth-first search.

#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <vector>

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

    // Reads the edges of a graph as an adjacency list.
    Graph read_graph()
    {
        auto vertex_count = -1, edge_count = -1;
        std::cin >> vertex_count >> edge_count;
        ensure(vertex_count >= 0);
        ensure(edge_count >= 0);

        auto adj = Graph(vertex_count);

        for (; edge_count != 0; --edge_count) {
            auto u = -1, v = -1;
            std::cin >> u >> v;

            ensure(0 <= u && u < vertex_count);
            ensure(0 <= v && v < vertex_count);

            adj[u].push_back(v);
            adj[v].push_back(u);
        }

        return adj;
    }

    // Peforms an action for each component size in the graph.
    template<typename UnaryFunction>
    void for_each_component_size(const Graph& adj, UnaryFunction f)
    {
        auto vis = std::vector<Color>(adj.size(), Color::white);

        const auto dfs = [&adj, &vis](const auto& me, const int src) noexcept {
            if (vis[src] != Color::white) return 0;
            vis[src] = Color::black;

            auto size = 1;
            for (const auto dest : adj[src]) size += me(me, dest);
            return size;
        };

        for (auto start = 0; start != adj.size(); ++start) {
            const auto size = dfs(dfs, start);
            if (size != 0) f(size);
        }
    }

    // Computes the number of cross-component unordered vertex pairs.
    std::int_fast64_t count_pairs(const Graph& adj)
    {
        auto total_size = std::int_fast64_t{0};
        auto pair_count = std::int_fast64_t{0}; // May become large.

        const auto do_component = [&total_size, &pair_count](
                const std::int_fast64_t size) noexcept {
            pair_count += total_size * size;
            total_size += size;
        };

        for_each_component_size(adj, do_component);
        return pair_count;
    }
}

int main()
{
    std::ios_base::sync_with_stdio(false);

    std::cout << count_pairs(read_graph()) << '\n';
}
