// LeetCode #787 - Cheapest Flights Within K Stops
// https://leetcode.com/problems/cheapest-flights-within-k-stops/
// Via BFS with relaxations (compare to Dijkstra's algorithm).

class Solution {
    public int
    findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
        return buildGraph(n, flights).minPathCost(src, dst, k + 1);
    }

    private static Graph buildGraph(int vertexCount, int[][] edges) {
        var graph = new Graph(vertexCount);
        for (var edge : edges) graph.addEdge(edge[0], edge[1], edge[2]);
        return graph;
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

        var costs = new int[vertexCount()];
        Arrays.fill(costs, -1);
        costs[start] = 0;

        Queue<VertexCostPair> queue = new ArrayDeque<>();
        queue.add(new VertexCostPair(start, 0));

        while (maxDepth-- > 0 && !queue.isEmpty()) {
            for (var breadth = queue.size(); breadth > 0; --breadth) {
                var src = queue.remove();

                for (var edge : _adj.get(src.vertex)) {
                    // Use the enqueued source cost, since that was the cost to
                    // get here via BFS; costs[src] may already be lower, but
                    // using it may take a path that exceeds the depth limit.
                    var newCost = src.cost + edge.weight;

                    if (costs[edge.dest] != NO_ROUTE
                            && costs[edge.dest] <= newCost)
                        continue;

                    costs[edge.dest] = newCost;
                    queue.add(new VertexCostPair(edge.dest, newCost));
                }
            }
        }

        return costs[finish];
    }

    int vertexCount() {
        return _adj.size();
    }

    void ensureExists(int vertex) {
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

final class VertexCostPair {
    VertexCostPair(int vertex, int cost) {
        this.vertex = vertex;
        this.cost = cost;
    }

    final int vertex;

    final int cost;
}
