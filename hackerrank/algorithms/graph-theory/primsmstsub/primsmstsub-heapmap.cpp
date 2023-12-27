// Prim's (MST): Special Subtree
// https://www.hackerrank.com/challenges/primsmstsub
// Using a custom binary minheap + map data structure.

#include <iostream>
#include <vector>

namespace {
    // Visitation state for vertex (to avoid std::vector<bool>).
    enum Vis : bool { not_done, done };

    // Information on an outward neighbor in a weighted undirected graph.
    struct OutEdge {
        int dest;
        int weight;
    };

    // Heap entry representing best cost so far to reach a vertex.
    struct Entry {
        int vertex;
        int cost;
    };

    // Binary heap + map data structure for Prim's and Dijkstra's algorithms.
    class Heap {
    public:
        explicit Heap(int vertex_count) noexcept;

        [[nodiscard]] bool empty() const noexcept;

        void insert_or_decrease(int vertex, int cost) noexcept;

        Entry pop() noexcept;

    private:
        static constexpr int absent {-1};

        [[nodiscard]] int size() const noexcept;

        void sift_up(int child) noexcept;

        void sift_down(int parent) noexcept;

        [[nodiscard]] int pick_child(int parent) const noexcept;

        void do_swap(int parent, int child) noexcept;

        std::vector<Entry> heap_; // index -> (vertex, cost)
        std::vector<int> map_; // vertex -> index
    };

    Heap::Heap(const int vertex_count) noexcept : map_(vertex_count, absent)
    {
    }

    inline bool Heap::empty() const noexcept
    {
        return std::empty(heap_);
    }

    void Heap::insert_or_decrease(const int vertex, const int cost) noexcept
    {
        auto child = map_[vertex];

        if (child == absent) {
            map_[vertex] = child = size();
            heap_.push_back({vertex, cost});
        } else if (heap_[child].cost > cost) {
            heap_[child].cost = cost;
        } else {
            return; // No change, so no need to restore invariant.
        }

        sift_up(child);
    }

    Entry Heap::pop() noexcept
    {
        const auto entry = heap_[0];
        map_[entry.vertex] = absent;

        const auto last = size() - 1;

        if (last == 0) {
            heap_.clear();
        } else {
            heap_[0] = heap_[last];
            heap_.pop_back();
            map_[heap_[0].vertex] = 0;
            sift_down(0);
        }

        return entry;
    }

    inline int Heap::size() const noexcept
    {
        return static_cast<int>(heap_.size());
    }

    void Heap::sift_up(int child) noexcept
    {
        while (child != 0) {
            const auto parent = (child - 1) / 2;
            if (heap_[parent].cost <= heap_[child].cost) break;

            do_swap(parent, child);
            child = parent;
        }
    }

    void Heap::sift_down(int parent) noexcept
    {
        for (; ; ) {
            const auto child = pick_child(parent);
            if (child == absent || heap_[parent].cost <= heap_[child].cost)
                break;

            do_swap(parent, child);
            parent = child;
        }
    }

    inline int Heap::pick_child(const int parent) const noexcept
    {
        const auto left = parent * 2 + 1;
        if (left >= size()) return absent;

        const auto right = left + 1;
        if (right == size() || heap_[left].cost <= heap_[right].cost)
            return left;

        return right;
    }

    inline void Heap::do_swap(const int parent, const int child) noexcept
    {
        std::swap(map_[heap_[parent].vertex], map_[heap_[child].vertex]);
        std::swap(heap_[parent], heap_[child]);
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
        int vertex_count() const noexcept;

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
        auto vis = std::vector(vertex_count(), Vis::not_done);
        auto heap = Heap{vertex_count()};
        heap.insert_or_decrease(start, 0);
        auto total_weight = 0;

        while (!heap.empty()) {
            const auto [src, src_cost] = heap.pop();
            vis[src] = Vis::done;
            total_weight += src_cost;

            for (const auto [dest, weight] : adj_[src]) {
                if (vis[dest] == Vis::not_done)
                    heap.insert_or_decrease(dest, weight);
            }
        }

        return total_weight;
    }

    inline int Graph::vertex_count() const noexcept
    {
        return static_cast<int>(adj_.size());
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
