// Kruskal (MST): Really Special Subtree
// https://www.hackerrank.com/challenges/kruskalmstrsub
// By Kruskal's algorithm.

#include <algorithm>
#include <iostream>
#include <numeric>
#include <vector>

namespace {
    // Disjoint-set union data structure for the union-find algorithm.
    class DisjointSets {
    public:
        // Creates with singleton sets for elements 0, ..., element_count - 1.
        explicit DisjointSets(int element_count) noexcept;

        // Joins the sets of elem1 and elem2.
        // Returns true if joined, or false if they were already the same set.
        [[nodiscard]] bool unite(int elem1, int elem2) noexcept;

    private:
        // Find the representative element of the set with elem in it.
        [[nodiscard]] int find(int elem) noexcept;

        std::vector<int> parents_;
        std::vector<int> ranks_;
    };

    DisjointSets::DisjointSets(const int element_count) noexcept
        : parents_(element_count), ranks_(element_count)
    {
        std::iota(begin(parents_), end(parents_), 0);
    }

    bool DisjointSets::unite(int elem1, int elem2) noexcept
    {
        // Find the ancestors and stop if they are already the same.
        elem1 = find(elem1);
        elem2 = find(elem2);
        if (elem1 == elem2) return false;

        // Union by rank.
        if (ranks_[elem1] < ranks_[elem2]) {
            parents_[elem1] = elem2;
        } else {
            if (ranks_[elem1] == ranks_[elem2]) ++ranks_[elem1];
            parents_[elem2] = elem1;
        }

        return true;
    }

    int DisjointSets::find(int elem) noexcept
    {
        // Find the ancestor.
        auto leader = elem;
        while (leader != parents_[leader]) leader = parents_[leader];

        // Compress the path.
        while (elem != leader) {
            const auto parent = parents_[elem];
            parents_[elem] = leader;
            elem = parent;
        }

        return leader;
    }

    // An edge in a weighted undirected graph.
    struct Edge {
        int u;
        int v;
        int weight;
    };

    [[nodiscard]] std::vector<Edge> read_edges(int edge_count) noexcept
    {
        auto edges = std::vector<Edge>{};

        while (edge_count-- > 0) {
            auto u = 0, v = 0, weight = 0;
            std::cin >> u >> v >> weight;
            edges.push_back({u, v, weight});
        }

        return edges;
    }

    void sort_edges(std::vector<Edge>& edges) noexcept
    {
        std::sort(begin(edges), end(edges),
                  [](const Edge& lhs, const Edge& rhs) noexcept {
            return lhs.weight < rhs.weight;
        });
    }
}

int main()
{
    std::ios_base::sync_with_stdio(false);

    auto vertex_count = 0, edge_count = 0;
    std::cin >> vertex_count >> edge_count;

    auto edges = read_edges(edge_count);
    sort_edges(edges);

    auto total_weight = 0;
    auto sets = DisjointSets{vertex_count + 1}; // +1 for 1-based indexing.
    for (const auto& edge : edges) {
        if (sets.unite(edge.u, edge.v)) total_weight += edge.weight;
    }

    std::cout << total_weight << '\n';
}
