// Prim's (MST): Special Subtree
// https://www.hackerrank.com/challenges/primsmstsub
// Using std::priority_queue.

#include <iostream>
#include <queue>
#include <vector>

namespace {
    // Visitation state for vertex (to avoid std::vector<bool>).
    enum Vis : bool { not_done, done };

    // Information on an outward neighbor in a weighted undirected graph.
    struct OutEdge {
        int dest;
        int weight;
    };

    // Priority-queue entry representing best cost so far to reach a vertex.
    struct Entry {
        int vertex;
        int cost;
    };

    // Create an initially empty priority queue for use in Prim's algorithm.
    auto make_priority_queue() noexcept
    {
        constexpr auto compare = [](const Entry& lhs,
                                    const Entry& rhs) noexcept
        {
            return lhs.cost > rhs.cost;
        };

        return std::priority_queue<
            Entry,
            std::vector<Entry>,
            decltype(compare)
        >{compare};
    }

    // A weighted undirected graph.
    class Graph {
    public:
        // Make a graph with vertices 0, ..., vertex_count - 1, no edges yet.
        Graph(int vertex_count) noexcept;

        // Add an edge to the graph.
        void add_edge(int u, int v, int weight) noexcept;

        // Compute the weight of a minimum spanning tree with Prim's algorithm.
        // The MST is found from the given start vertex.
        [[nodiscard]] int mst_weight(int start) const noexcept;

    private:
        std::vector<std::vector<OutEdge>> adj_;
    };

    Graph::Graph(const int vertex_count) noexcept : adj_(vertex_count)
    {
    }

    inline void
    Graph::add_edge(const int u, const int v, const int weight) noexcept
    {
        adj_[u].push_back({v, weight});
        adj_[v].push_back({u, weight});
    }

    int Graph::mst_weight(const int start) const noexcept
    {
        constexpr auto unseen = -1;

        auto pq = make_priority_queue();
        pq.push({start, 0});
        auto costs = std::vector<int>(size(adj_), unseen);
        costs[start] = 0;
        auto vis = std::vector<Vis>(size(adj_), Vis::not_done);
        auto total_weight = 0;

        while (!empty(pq)) {
            const auto [src, src_cost] = pq.top();
            pq.pop();
            if (vis[src] == Vis::done) continue;

            vis[src] = Vis::done;
            total_weight += src_cost;

            for (const auto [dest, weight] : adj_[src]) {
                if (vis[dest] == Vis::done) continue;

                if (costs[dest] == unseen || costs[dest] > weight) {
                    costs[dest] = weight;
                    pq.push({dest, weight});
                }
            }
        }

        return total_weight;
    }

    [[nodiscard]] Graph read_graph() noexcept
    {
        auto vertex_count = 0, edge_count = 0;
        std::cin >> vertex_count >> edge_count;

        auto graph = Graph{vertex_count + 1}; // +1 for 1-based indexing.

        while (edge_count-- > 0) {
            auto u = 0, v = 0, weight = 0;
            std::cin >> u >> v >> weight;
            graph.add_edge(u, v, weight);
        }

        return graph;
    }
}

int main()
{
    std::ios_base::sync_with_stdio(false);

    const auto graph = read_graph();
    auto start = 0;
    std::cin >> start;
    std::cout << graph.mst_weight(start) << '\n';
}
