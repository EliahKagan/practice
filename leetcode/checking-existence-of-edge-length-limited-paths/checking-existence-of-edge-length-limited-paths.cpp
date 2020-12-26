// LeetCode 1697 - Checking Existence of Edge Length Limited Paths

class Solution {
public:
    [[nodiscard]] static vector<bool>
    distanceLimitedPathsExist(int order,
                              vector<vector<int>>& edges,
                              const vector<vector<int>>& queries) noexcept;
};

namespace {
    [[nodiscard]] vector<int> ascending_integers(const int count) noexcept
    {
        auto integers = std::vector<int>(count);
        iota(begin(integers), end(integers), 0);
        return integers;
    }

    class DisjointSets {
    public:
        DisjointSets(int element_count) noexcept;

        void unite(int elem1, int elem2) noexcept;

        [[nodiscard]] int find_set(int elem) noexcept;

    private:
        vector<int> parents_;
        vector<int> ranks_;
    };

    DisjointSets::DisjointSets(const int element_count) noexcept
        : parents_(ascending_integers(element_count)), ranks_(element_count)
    {
    }

    void DisjointSets::unite(int elem1, int elem2) noexcept
    {
        // Find the ancestors and stop if they are already the same.
        elem1 = find_set(elem1);
        elem2 = find_set(elem2);
        if (elem1 == elem2) return;

        // Unite by rank.
        if (ranks_[elem1] < ranks_[elem2]) {
            parents_[elem1] = elem2;
        } else {
            if (ranks_[elem1] == ranks_[elem2]) ++ranks_[elem1];
            parents_[elem2] = elem1;
        }
    }

    int DisjointSets::find_set(int elem) noexcept
    {
        // Find the ascestor.
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

    [[nodiscard]] inline tuple<int, int>
    endpoints(const vector<int>& edge_or_query) noexcept
    {
        return {edge_or_query[0], edge_or_query[1]};
    }


    [[nodiscard]] inline int
    weight_or_limit(const vector<int>& edge_or_query) noexcept
    {
        return edge_or_query[2];
    }

    void sort_by_weight(vector<vector<int>>& edges) noexcept
    {
        sort(begin(edges), end(edges), [](const auto& lhs_edge,
                                          const auto& rhs_edge) noexcept {
            return weight_or_limit(lhs_edge) < weight_or_limit(rhs_edge);
        });
    }

    [[nodiscard]] vector<int>
    indices_sorted_by_limit(const vector<vector<int>>& queries) noexcept
    {
        auto indices = ascending_integers(size(queries));

        sort(begin(indices), end(indices),
             [&queries](const auto lhs_index, const auto rhs_index) noexcept {
            const auto& lhs_query = queries[lhs_index];
            const auto& rhs_query = queries[rhs_index];
            return weight_or_limit(lhs_query) < weight_or_limit(rhs_query);
        });

        return indices;
    }
}

vector<bool> Solution::distanceLimitedPathsExist(
                const int order,
                vector<vector<int>>& edges,
                const vector<vector<int>>& queries) noexcept
{
    sort_by_weight(edges);
    auto edge_pos = cbegin(edges);
    const auto edge_endpos = cend(edges);

    auto sets = DisjointSets{order};
    auto results = vector<bool>(size(queries));

    for (const auto index : indices_sorted_by_limit(queries)) {
        const auto limit = weight_or_limit(queries[index]);

        while (edge_pos != edge_endpos && weight_or_limit(*edge_pos) < limit) {
            const auto [u, v] = endpoints(*edge_pos);
            sets.unite(u, v);
            ++edge_pos;
        }

        const auto [start, finish] = endpoints(queries[index]);
        if (sets.find_set(start) == sets.find_set(finish))
            results[index] = true;
    }

    return results;
}
