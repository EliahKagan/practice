// LeetCode #787 - Cheapest Flights Within K Stops
// https://leetcode.com/problems/cheapest-flights-within-k-stops/
// Via BFS with relaxations (compare to Dijkstra's algorithm).

class Solution {
public:
    [[nodiscard]] static int
    findCheapestPrice(int n,
                      const vector<vector<int>>& flights,
                      int src,
                      int dst,
                      int k) noexcept;
};

namespace {
    template<typename T>
    void ensure(T condition) noexcept
    {
        if (condition) return;
        abort();
    }

    // A weighted directed graph.
    class Graph {
    public:
        Graph(int vertex_count) noexcept;

        void add_edge(int src, int dest, int weight) noexcept;

        [[nodiscard]] optional<int>
        min_path_cost(int start, int finish, int max_depth) const noexcept;

    private:
        [[nodiscard]] int vertex_count() const noexcept { return size(adj_); }

        [[nodiscard]] bool exists(const int vertex) const noexcept
        {
            return 0 <= vertex && vertex < vertex_count();
        }

        vector<vector<tuple<int, int>>> adj_;
    };

    Graph::Graph(const int vertex_count) noexcept : adj_(vertex_count) { }

    void Graph::add_edge(const int src, const int dest, const int weight) noexcept
    {
        ensure(exists(src));
        ensure(exists(dest));

        adj_[src].emplace_back(dest, weight);
    }

    optional<int> Graph::min_path_cost(const int start,
                                       const int finish,
                                       int max_depth) const noexcept
    {
        ensure(exists(start));
        ensure(exists(finish));

        auto costs = vector<optional<int>>(vertex_count());
        auto queue = std::queue<tuple<int, int>>{};
        costs[start] = 0;
        queue.emplace(start, 0);

        while (max_depth-- > 0 && !empty(queue)) {
            for (auto breadth = size(queue); breadth != 0; --breadth) {
                const auto [src, src_cost] = queue.front();
                queue.pop();

                for (const auto [dest, weight] : adj_[src]) {
                    const auto dest_cost = src_cost + weight;
                    if (costs[dest] && *costs[dest] <= dest_cost) continue;

                    costs[dest] = dest_cost;
                    queue.emplace(dest, dest_cost);
                }
            }
        }

        return costs[finish];
    }

    [[nodiscard]] Graph build_graph(const int vertex_count,
                                    const vector<vector<int>>& edges) noexcept
    {
        auto graph = Graph{vertex_count};

        for (const auto& edge : edges) {
            ensure(size(edge) == 3);
            graph.add_edge(edge[0], edge[1], edge[2]);
        }

        return graph;
    }
}

int Solution::findCheapestPrice(const int n,
                                const vector<vector<int>>& flights,
                                const int src,
                                const int dst,
                                const int k) noexcept
{
    return build_graph(n, flights).min_path_cost(src, dst, k + 1).value_or(-1);
}
