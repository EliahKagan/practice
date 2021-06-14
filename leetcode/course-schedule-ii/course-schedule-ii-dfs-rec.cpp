// LeetCode #210 - Course Schedule II
// https://leetcode.com/problems/course-schedule-ii/
// Via recursive DFS implemented with std::function.

class Solution {
public:
    [[nodiscard]] static vector<int>
    findOrder(int numCourses,
              const vector<vector<int>>& prerequisites) noexcept;
};

namespace {
    template<typename T>
    void ensure(T condition) noexcept
    {
        if (condition) return;
        abort();
    }

    template<typename C, typename F>
    constexpr bool any_of(const C& items, F predicate) noexcept
    {
        return any_of(cbegin(items), cend(items), predicate);
    }

    // Visitation states for depth-first traversal of a directed graph.
    enum class Color : char {
        white, // Not yet visited.
        gray,  // Visited but not yet fully explored.
        black, // Fully explored.
    };

    // A directed graph represented as an adjacency list.
    class Graph {
    public:
        Graph(int vertex_count) noexcept;

        [[nodiscard]] int vertex_count() const noexcept
        {
            return size(adj_);
        }

        void add_edge(int src, int dest) noexcept;

        [[nodiscard]] optional<vector<int>> reverse_toposort() const noexcept;

    private:
        [[nodiscard]] bool exists(int vertex) const noexcept
        {
            return 0 <= vertex && vertex < vertex_count();
        }

        vector<vector<int>> adj_;
    };

    Graph::Graph(const int vertex_count) noexcept : adj_(vertex_count) { }

    void Graph::add_edge(const int src, const int dest) noexcept
    {
        ensure(exists(src));
        ensure(exists(dest));
        adj_[src].push_back(dest);
    }

    optional<vector<int>> Graph::reverse_toposort() const noexcept
    {
        auto vis = vector(vertex_count(), Color::white);
        auto out = vector<int>{};

        // Puts vertices into the reverse toposort while checking for a cycle.
        const function<bool(int)> has_cycle_from {[&](const int src) noexcept {
            switch (vis[src]) {
            case Color::white:
                vis[src] = Color::gray;
                if (any_of(adj_[src], has_cycle_from)) return true;
                vis[src] = Color::black;
                out.push_back(src);
                return false;

            case Color::gray:
                return true;

            case Color::black:
                return false;
            }

            abort(); // Unrecognized visitation state.
        }};

        for (auto start = 0; start != vertex_count(); ++start)
            if (has_cycle_from(start)) return nullopt;

        return move(out); // Move to construct different return type (no NRVO).
    }

    Graph build_graph(const int vertex_count,
                      const vector<vector<int>>& edges) noexcept
    {
        auto graph = Graph{vertex_count};

        for (const auto& edge : edges) {
            ensure(size(edge) == 2);
            graph.add_edge(edge[0], edge[1]);
        }

        return graph;
    }
}

vector<int>
Solution::findOrder(int numCourses,
                    const vector<vector<int>>& prerequisites) noexcept
{
    auto order = build_graph(numCourses, prerequisites).reverse_toposort();
    if (order) return move(*order);
    return {};
}
