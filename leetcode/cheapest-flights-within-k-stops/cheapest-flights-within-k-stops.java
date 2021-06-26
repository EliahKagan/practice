// LeetCode #787 - Cheapest Flights Within K Stops
// https://leetcode.com/problems/cheapest-flights-within-k-stops/
// Via BFS with relaxations (compare to Dijkstra's algorithm).

class Solution {
    public int findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
        var graph = new Graph(n);

        for (var flight : flights)
            graph.addEdge(flight[0], flight[1], flight[2]);

        return graph.minPathCost(src, dst, k);
    }
}

final class Graph {
    static final int NO_ROUTE = -1;

    Graph(int vertexCount) {
        _adj = new ArrayList<>(vertexCount);
        while (_adj.size() < vertexCount) _adj.add(new ArrayList<>());
    }

    void addEdge(int src, int dest, int weight) {
        ensureExists(src);
        ensureExists(dest);
        _adj.get(src).add(new OutEdge(dest, weight));
    }

    int minPathCost(int start, int finish, int maxDepth) {
        ensureExists(start);
        ensureExists(finish);

        var costs = new Integer[vertexCount()];
        Queue<Integer> queue = new ArrayDeque<>();
        costs[start] = 0;
        queue.add(start);

        for (var depth = 0; depth <= maxDepth; ++depth) {
            if (queue.isEmpty()) break;

            var src = queue.remove();

            for (var edge : _adj.get(src)) {
                if (costs[edge.dest] == null
                        || costs[src] + edge.weight < costs[edge.dest]) {
                    costs[edge.dest] = costs[src] + edge.weight;
                    queue.add(edge.dest);
                }
            }
        }

        return costs[finish] == null ? NO_ROUTE : costs[finish];
    }

    private int vertexCount() {
        return _adj.size();
    }

    private void ensureExists(int vertex) {
        if (!(0 <= vertex && vertex < vertexCount()))
            throw new IllegalArgumentException("vertex out of range");
    }

    private final List<List<OutEdge>> _adj;
}

final class OutEdge {
    OutEdge(int dest, int weight) {
        this.dest = dest;
        this.weight = weight;
    }

    final int dest;

    final int weight;
}
