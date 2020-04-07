// https://www.hackerrank.com/challenges/journey-to-the-moon
// In C++14. Using union-find (disjoint-set union).

#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <utility>
#include <vector>

namespace {
    // Terminates the program abnormally if the given condition fails.
    inline void ensure(const bool condition) noexcept
    {
        if (!condition) std::abort();
    }

    class DisjointSets {
    public:
        // Performs element_count makeset operations.
        explicit DisjointSets(int element_count);

        // Performs an action for each set's cardinality.
        template<typename UnaryFunction>
        void for_each_cardinality(UnaryFunction f) const;

        // Union by size with full path compression.
        void unite(int elem1, int elem2) noexcept;

    private:
        int find_set(int elem) noexcept;

        void join(int parent, int child) noexcept;

        std::vector<int> elems_;
    };

    DisjointSets::DisjointSets(const int element_count)
        : elems_(element_count, -1)
    {
    }

    template<typename UnaryFunction>
    void DisjointSets::for_each_cardinality(UnaryFunction f) const
    {
        for (const auto parent_or_size : elems_)
            if (parent_or_size < 0) f(-parent_or_size);
    }

    void DisjointSets::unite(int elem1, int elem2) noexcept
    {
        // Find the ancestors and stop if they are already the same.
        elem1 = find_set(elem1);
        elem2 = find_set(elem2);
        if (elem1 == elem2) return;

        if (elems_[elem2] < elems_[elem1]) {
            // 2 has greater (negated) size. Make it the parent.
            join(elem2, elem1);
        } else {
            // 1 has greater or equal (negated) size. Make it the parent.
            join(elem1, elem2);
        }
    }

    int DisjointSets::find_set(int elem) noexcept
    {
        // Find the ancestor.
        auto leader = elem;
        while (elems_[leader] >= 0) leader = elems_[leader];

        // Compress the path.
        while (elem != leader) {
            const auto parent = elems_[elem];
            elems_[elem] = leader;
            elem = parent;
        }

        return leader;
    }

    void DisjointSets::join(const int parent, const int child) noexcept
    {
        elems_[parent] += elems_[child];
        elems_[child] = parent;
    }

    // Edge-list representation of a graph, for iterating over component sizes.
    class Graph {
    public:
        // Reads a graph from standard input.
        explicit Graph(std::istream& in);

        // Performs an action for each component size in the graph.
        template<typename UnaryFunction>
        void for_each_component_size(UnaryFunction f) const;

    private:
        using Edge = std::pair<int, int>;

        constexpr bool has_vertex(int vertex) const noexcept;

        std::vector<Edge> edges_ {};
        int vertex_count_ {-1};
    };

    Graph::Graph(std::istream& in)
    {
        auto edge_count = -1;
        in >> vertex_count_ >> edge_count;
        ensure(in && vertex_count_ >= 0 && edge_count >= 0);

        edges_.resize(edge_count);

        for (auto& edge : edges_) {
            in >> edge.first >> edge.second;
            ensure(in && has_vertex(edge.first) && has_vertex(edge.second));
        }
    }

    template<typename UnaryFunction>
    inline void Graph::for_each_component_size(UnaryFunction f) const
    {
        auto sets = DisjointSets{vertex_count_};
        for (const auto edge : edges_) sets.unite(edge.first, edge.second);
        sets.for_each_cardinality(f);
    }

    constexpr bool Graph::has_vertex(const int vertex) const noexcept
    {
        return 0 <= vertex && vertex < vertex_count_;
    }

    // Computes the number of cross-component unordered vertex pairs.
    std::int_fast64_t count_pairs(const Graph& graph)
    {
        auto total_size = std::int_fast64_t{0};
        auto pair_count = std::int_fast64_t{0}; // May become large.

        const auto do_component = [&total_size, &pair_count](
                const std::int_fast64_t size) noexcept {
            pair_count += total_size * size;
            total_size += size;
        };

        graph.for_each_component_size(do_component);
        return pair_count;
    }
}

int main()
{
    std::ios_base::sync_with_stdio(false);

    std::cout << count_pairs(Graph{std::cin}) << '\n';
}
