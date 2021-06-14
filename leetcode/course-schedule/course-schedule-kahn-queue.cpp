// LeetCode #210 - Course Schedule
// https://leetcode.com/problems/course-schedule/
// Via Kahn's algorithm with a queue (FIFO).

class Solution {
public:
    [[nodiscard]] static bool
    canFinish(int numCourses,
              const vector<vector<int>>& prerequisites) noexcept;
};

namespace {
    template<typename T>
    inline void ensure(T condition) noexcept
    {
        if (condition) return;
        abort();
    }

    class Graph {
    public:
        Graph(int vertex_count) noexcept;

        void add_edge(int src, int dest) noexcept;

        [[nodiscard]] bool has_cycle() && noexcept;

    private:
        [[nodiscard]] int vertex_count() const noexcept
        {
            return size(adj_);
        }

        [[nodiscard]] bool exists(const int vertex) const noexcept
        {
            return 0 <= vertex && vertex < vertex_count();
        }

        [[nodiscard]] queue<int> get_roots() const noexcept;

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

    bool Graph::has_cycle() && noexcept
    {
        auto count = vertex_count();

        for (auto roots = get_roots(); !empty(roots); ) {
            auto src = roots.front();
            roots.pop();

            --count;

            for (const auto dest : adj_[src])
                if (--indegrees_[dest] == 0) roots.push(dest);
        }

        return count != 0;
    }

    queue<int> Graph::get_roots() const noexcept
    {
        auto roots = queue<int>{};

        for (auto vertex = 0; vertex != vertex_count(); ++vertex)
            if (indegrees_[vertex] == 0) roots.push(vertex);

        return roots;
    }

    Graph build_graph(const int vertex_count,
                      const vector<vector<int>>& edges) noexcept
    {
        ensure(vertex_count >= 0);

        auto graph = Graph{vertex_count};

        for (const auto& edge : edges) {
            ensure(size(edge) == 2);
            graph.add_edge(edge[0], edge[1]);
        }

        return graph;
    }
}

bool Solution::canFinish(const int numCourses,
                         const vector<vector<int>>& prerequisites) noexcept
{
    return !build_graph(numCourses, prerequisites).has_cycle();
}
