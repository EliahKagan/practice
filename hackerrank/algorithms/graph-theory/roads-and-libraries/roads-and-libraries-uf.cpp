// https://www.hackerrank.com/challenges/torque-and-development
// In C++14. Using union-find (disjoint-set union).

#include <cassert>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <numeric>
#include <utility>
#include <vector>

namespace {
    // Terminates the progam abnormally if the given condition fails.
    inline void ensure(const bool condition) noexcept
    {
        if (!condition) std::abort();
    }

    class DisjointSets {
    public:
        // Performs element_count makeset operations.
        explicit DisjointSets(int element_count);

        // Union by rank with full path compression. Returns true if the
        // the elements were in two different sets, which were joined.
        // Otherwise the elements were in the same set and false is returned.
        bool unite(int elem1, int elem2) noexcept;

    private:
        int find_set(int elem) noexcept;

        std::vector<int> elems_;
    };

    DisjointSets::DisjointSets(const int element_count)
        : elems_(element_count, -1)
    {
    }

    bool DisjointSets::unite(int elem1, int elem2) noexcept
    {
        // Find the ancestors and stop if they are the same.
        elem1 = find_set(elem1);
        elem2 = find_set(elem2);
        if (elem1 == elem2) return false;

        if (elems_[elem1] > elems_[elem2]) {
            // #2 ranks higher (more negative) than #1. So make #2 the parent.
            elems_[elem1] = elem2;
        } else {
            // If #1 and #2 have the same rank, promote #1.
            if (elems_[elem1] == elems_[elem2]) --elems_[elem1];

            // #1 ranks higher (more negative) than #2. So make #1 the parent.
            elems_[elem2] = elem1;
        }

        return true;
    }

    int DisjointSets::find_set(int elem) noexcept
    {
        // Find the ancestor.
        auto leader = elem;
        while (elems_[leader] >= 0) leader = elems_[leader];

        // Compress the path.
        while (elem != leader) {
            auto parent = elems_[elem];
            elems_[elem] = leader;
            elem = parent;
        }

        return leader;
    }

    // An undirected edge.
    using Edge = std::pair<int, int>;

    // Reads the edges of a graph as an adjacency list.
    std::vector<Edge> read_edges(const int vertex_count, const int edge_count)
    {
        auto edges = std::vector<Edge>(edge_count);

        for (auto& edge : edges) {
            std::cin >> edge.first >> edge.second;
            ensure(0 < edge.first && edge.first <= vertex_count);
            ensure(0 < edge.second && edge.second <= vertex_count);
        }

        return edges;
    }

    // Reads and discards the edges of a graph.
    void consume_edges(int edge_count)
    {
        auto discard = 0;
        for (; edge_count != 0; --edge_count) std::cin >> discard >> discard;
    }

    // Computes the number of edges in a spanning forest.
    int count_forest_edges(const int vertex_count,
                           const std::vector<Edge>& edges)
    {
        auto sets = DisjointSets{vertex_count + 1}; // +1 for 1-based indexing

        return std::accumulate(cbegin(edges), cend(edges), 0,
                [&sets](const int acc, const Edge edge) noexcept {
            return acc + sets.unite(edge.first, edge.second);
        });
    }

    // Computes the cost of an optimal road- and library-building strategy.
    std::int_fast64_t
    compute_minimum_cost(const int city_count, const int road_count,
                         const int lib_cost, const int road_cost)
    {
        ensure(city_count >= 0 && road_count >= 0);
        ensure(lib_cost >= 0 && road_cost >= 0);

        if (lib_cost <= road_cost) {
            consume_edges(road_count);
            return city_count * std::int_fast64_t{lib_cost};
        }

        const auto roads = read_edges(city_count, road_count);
        const auto repair_count = count_forest_edges(city_count, roads);
        assert(repair_count <= road_count);
        assert(repair_count <= city_count);
        const auto build_count = city_count - repair_count;

        return build_count * std::int_fast64_t{lib_cost}
                + repair_count * std::int_fast64_t{road_cost};
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
