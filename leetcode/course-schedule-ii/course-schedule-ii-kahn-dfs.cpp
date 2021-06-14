// LeetCode #210 - Course Schedule II
// https://leetcode.com/problems/course-schedule-ii/
// Via Kahn's algorithm with recursive DFS with std::function.

class Solution {
public:
    [[nodiscard]] static vector<int>
    findOrder(int numCourses,
              const vector<vector<int>>& prerequisites) noexcept;
};

namespace {
    template<typename T>
    inline void ensure(T condition) noexcept
    {
        if (condition) return;
        abort();
    }

    template<typename C, typename F>
    void for_each(const C& items, F action) noexcept
    {
        for_each(cbegin(items), cend(items), action);
    }

    class Graph {
    public:
        Graph(int vertex_count) noexcept;

        void add_edge(int src, int dest) noexcept;

        [[nodiscard]] optional<vector<int>> toposort() && noexcept;

    private:
        [[nodiscard]] int vertex_count() const noexcept
        {
            return size(adj_);
        }

        [[nodiscard]] bool exists(const int vertex) const noexcept
        {
            return 0 <= vertex && vertex < vertex_count();
        }

        [[nodiscard]] vector<int> get_roots() const noexcept;

        vector<vector<int>> adj_;

        vector<int> indegrees_;
    };

    Graph::Graph(const int vertex_count) noexcept
        : adj_(vertex_count), indegrees_(vertex_count) { }

    void Graph::add_edge(const int src, const int dest) noexcept
    {
        ensure(exists(src));
        ensure(exists(dest));
        adj_[src].push_back(dest);
        ++indegrees_[dest];
    }

    optional<vector<int>> Graph::toposort() && noexcept
    {
        auto out = vector<int>{};

        const function<void(int)> dfs = [&](const int src) noexcept {
            out.push_back(src);

            for (const auto dest : adj_[src])
                if (--indegrees_[dest] == 0) dfs(dest);
        };

        for_each(get_roots(), dfs);
        if (size(out) == vertex_count()) return out;
        return nullopt;
    }

    vector<int> Graph::get_roots() const noexcept
    {
        auto roots = vector<int>{};

        for (auto vertex = 0; vertex != vertex_count(); ++vertex)
            if (indegrees_[vertex] == 0) roots.push_back(vertex);

        return roots;
    }

    Graph build_reverse_graph(const int vertex_count,
                              const vector<vector<int>>& edges) noexcept
    {
        ensure(vertex_count >= 0);

        auto graph = Graph{vertex_count};

        for (const auto& edge : edges) {
            ensure(size(edge) == 2);
            graph.add_edge(edge[1], edge[0]);
        }

        return graph;
    }
}

vector<int>
Solution::findOrder(int numCourses,
                    const vector<vector<int>>& prerequisites) noexcept
{
    auto order = build_reverse_graph(numCourses, prerequisites).toposort();
    if (order) return move(*order);
    return {};
}
