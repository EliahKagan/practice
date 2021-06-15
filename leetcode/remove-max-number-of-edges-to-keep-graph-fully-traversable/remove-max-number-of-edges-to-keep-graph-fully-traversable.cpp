// LeetCode #1579 - Remove Max Number of Edges to Keep Graph Fully Traversable
// https://leetcode.com/problems/remove-max-number-of-edges-to-keep-graph-fully-traversable/
// Modified Kruskal's algorithm. Takes shared edges first, then copies the DSU.

class Solution {
public:
    // Computes the most edges that can be removed, keeping full connectivity
    // for Alice and Bob. Return -1 if the graph was not fully connected.
    [[nodiscard]] static int
    maxNumEdgesToRemove(int n, const vector<vector<int>>& edges) noexcept;
};

namespace {
    template<typename T>
    inline void ensure(T condition)
    {
        if (condition) return;
        abort();
    }

    inline size_t to_size(const int count) noexcept
    {
        ensure(0 <= count);
        return count;
    }

    // Disjoint-set-union data structure for union-find algorithm.
    // Elements are 1-based.
    class DisjointSets {
    public:
        // Creates element_count singletons.
        // Elements range from 1 to element_count (inclusive).
        explicit DisjointSets(int element_count) noexcept;

        // The number of (separate) sets.
        [[nodiscard]] constexpr int set_count() const noexcept
        {
            return set_count_;
        }

        // Union by rank with path compression.
        // Returns true iff the sets started separate (and were joined).
        bool unite(int elem1, int elem2) noexcept;

    private:
        [[nodiscard]] int element_count() const noexcept
        {
            return static_cast<int>(size(elems_)) - 1;
        }

        [[nodiscard]] bool exists(const int elem) const noexcept
        {
            return 0 < elem && elem <= element_count();
        }

        [[nodiscard]] int find_set(int elem) noexcept;

        vector<int> elems_;

        int set_count_;
    };

    DisjointSets::DisjointSets(const int element_count) noexcept
        : elems_(to_size(element_count) + 1, -1),
          set_count_{element_count} { }

    bool DisjointSets::unite(int elem1, int elem2) noexcept
    {
        // Find the ancestors and stop if they are already the same.
        elem1 = find_set(elem1);
        elem2 = find_set(elem2);
        if (elem1 == elem2) return false;

        // Unite by rank.
        if (elems_[elem1] > elems_[elem2]) {
            // elem2 has superior (more negative) rank. Use it as the parent.
            elems_[elem1] = elem2;
        } else {
            // If elem1 and elem2 have the same rank, promote elem1.
            if (elems_[elem1] == elems_[elem2]) --elems_[elem1];

            // elem1 has superior (more negative) rank. Use it as the parent.
            elems_[elem2] = elem1;
        }

        --set_count_;
        return true;
    }

    int DisjointSets::find_set(int elem) noexcept
    {
        ensure(exists(elem));

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

    // An unweighted undirected edge.
    struct Edge {
        int u;
        int v;
    };

    // Edges, grouped by which of Alice and Bob can trverse them.
    struct EdgeGroups {
        vector<Edge> alice;
        vector<Edge> bob;
        vector<Edge> alice_bob;
    };

    [[nodiscard]] EdgeGroups
    group_edges(const vector<vector<int>>& edges) noexcept
    {
        auto groups = EdgeGroups{};

        const auto get_group = [&groups](const int type) noexcept
                                -> vector<Edge>& {
            switch (type) {
            case 1:
                return groups.alice;
            case 2:
                return groups.bob;
            case 3:
                return groups.alice_bob;
            default:
                abort(); // Unrecognized edge type.
            }
        };

        for (const auto& edge : edges) {
            ensure(size(edge) == 3);
            get_group(edge[0]).push_back({edge[1], edge[2]});
        }

        return groups;
    }

    // Adds edges. Returns the number of edges that improved connectivity.
    int connect(DisjointSets& sets, const vector<Edge>& edges) noexcept
    {
        auto count = 0;

        for (const auto [u, v] : edges) {
            if (sets.set_count() < 2) break;
            if (sets.unite(u, v)) ++count;
        }

        return count;
    }

    // Computes the minimum number of edges needed to achieve full connectivity
    // for both Alice and Bob.
    [[nodiscard]] optional<int>
    compute_min_spanning_edges(const int vertex_count,
                               const EdgeGroups& groups) noexcept
    {
        // Pick up edges both Alice and Bob can use, giving them to both.
        auto alice_sets = DisjointSets{vertex_count};
        const auto alice_bob_count = connect(alice_sets, groups.alice_bob);
        auto bob_sets = alice_sets;

        // Pick up edges only Alice can use. Bail if Alice is still stranded.
        const auto alice_count = connect(alice_sets, groups.alice);
        if (alice_bob_count + alice_count + 1 < vertex_count) return nullopt;

        // Pick up edges only Bob can use. Bail if Bob is still stranded.
        const auto bob_count = connect(bob_sets, groups.bob);
        if (alice_bob_count + bob_count + 1 < vertex_count) return nullopt;

        return alice_bob_count + alice_count + bob_count;
    }
}

int Solution::maxNumEdgesToRemove(const int n,
                                  const vector<vector<int>>& edges) noexcept
{
    const auto count = compute_min_spanning_edges(n, group_edges(edges));

    return count ? static_cast<int>(size(edges)) - *count
                 : -1;
}
