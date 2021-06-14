// LeetCode #210 - Course Schedule II
// https://leetcode.com/problems/course-schedule-ii/
// Via iterative DFS.

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

    // Visitation states for depth-first traversal of a directed graph.
    enum class Color : char {
        white, // Not yet visited.
        gray,  // Visited but not yet fully explored.
        black, // Fully explored.
    };

    struct Frame {
        int vertex;
        int index;
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
        auto frames = stack<Frame>{};

        const auto push = [&](const auto vertex) noexcept {
            assert(vis[vertex] == Color::white);
            vis[vertex] = Color::gray;
            frames.push({vertex, 0});
        };

        // Puts vertices into the reverse toposort while checking for a cycle.
        const auto has_cycle_from = [&](const int start) noexcept {
            if (vis[start] != Color::black) push(start);

            while (!empty(frames)) {
                auto& [src, index] = frames.top();

                if (index == size(adj_[src])) {
                    vis[src] = Color::black;
                    out.push_back(src);
                    frames.pop();
                } else {
                    const auto dest = adj_[src][index++];
                    if (vis[dest] == Color::black) continue;
                    if (vis[dest] == Color::gray) return true;
                    push(dest);
                }
            }

            return false;
        };

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
