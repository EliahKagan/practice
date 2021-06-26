// LeetCode #787 - Cheapest Flights Within K Stops
// https://leetcode.com/problems/cheapest-flights-within-k-stops/
// Via BFS with relaxations (compare to Dijkstra's algorithm).

public class Solution {
    public int
    FindCheapestPrice(int n, int[][] flights, int src, int dst, int k)
        => BuildGraph(n, flights).MinPathCost(src, dst, k + 1) ?? -1;

    private static Graph BuildGraph(int vertexCount, int[][] edges)
    {
        var graph = new Graph(vertexCount);
        foreach (var edge in edges) graph.AddEdge(edge[0], edge[1], edge[2]);
        return graph;
    }
}

internal sealed class Graph {
    internal Graph(int vertexCount)
    {
        _adj = new IList<(int dest, int weight)>[vertexCount];

        for (var i = 0; i < vertexCount; ++i)
            _adj[i] = new List<(int dest, int weight)>();
    }

    internal int Count => _adj.Length;

    internal void AddEdge(int src, int dest, int weight)
    {
        if (!Exists(src)) Throw(nameof(src));
        if (!Exists(dest)) Throw(nameof(dest));

        _adj[src].Add((dest, weight));
    }

    internal int? MinPathCost(int start, int finish, int maxDepth)
    {
        if (!Exists(start)) Throw(nameof(start));
        if (!Exists(finish)) Throw(nameof(finish));

        var costs = new int?[Count];
        var queue = new Queue<(int src, int cost)>();
        costs[start] = 0;
        queue.Enqueue((start, 0));

        while (maxDepth-- > 0 && queue.Count != 0) {
            for (var breadth = queue.Count; breadth != 0; --breadth) {
                var (src, srcCost) = queue.Dequeue();

                foreach (var (dest, weight) in _adj[src]) {
                    var destCost = srcCost + weight;
                    if (costs[dest] <= destCost) continue;

                    costs[dest] = destCost;
                    queue.Enqueue((dest, destCost));
                }
            }
        }

        return costs[finish];
    }

    private static void Throw(string vertexParamName)
        => throw new ArgumentException(
            paramName: vertexParamName,
            message: "Vertex out of range");

    private bool Exists(int vertex) => 0 <= vertex && vertex < Count;

    private readonly IList<(int dest, int weight)>[] _adj;
}
