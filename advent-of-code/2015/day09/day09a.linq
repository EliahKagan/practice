<Query Kind="Statements" />

// Advent of Code, day 9, part A

internal sealed class Graph {
    internal Graph(int order)
    {
        _adj = new int[order, order];

        for (var i = 0; i < order; ++i) {
            for (var j = 0; j < order; ++j)
                _adj[i, j] = Infinity;
        }
    }

    internal void AddEdge(int src, int dest, int weight)
        => _adj[src, dest] = Math.Min(_adj[src, dest], weight);

    internal (int[] tour, int cost) FindMinCostTour()
    {
        var bestTour = Enumerable.Repeat(-1, Order).ToArray();
        var bestCost = Infinity;
        var vis = new bool[Order];
        var tour = new List<int>();
        var cost = 0;

        void SearchFrom(int src)
        {
            Debug.Assert(!vis[src]);
            vis[src] = true;
            tour.Add(src);

            if (tour.Count < Order) {
                for (var dest = 0; dest < Order; ++dest) {
                    if (vis[dest] || _adj[src, dest] == Infinity) continue;

                    cost = checked(cost + _adj[src, dest]);
                    SearchFrom(dest);
                    cost = checked(cost - _adj[src, dest]);
                }
            } else if (cost < bestCost) {
                tour.CopyTo(bestTour);
                bestCost = cost;
            }

            tour.RemoveAt(tour.Count - 1);
            vis[src] = false;
        }

        for (var start = 0; start < Order; ++start) SearchFrom(start);
        return (bestTour, bestCost);
    }

    private const int Infinity = int.MaxValue;

    private int Order => _adj.GetLength(0);

    private readonly int[,] _adj;
}

internal sealed class KeyGraph<T> where T : notnull {
    internal sealed class Builder {
        internal void AddEdge(T srcKey, T destKey, int weight)
            => _edges.Add((GetVertex(srcKey), GetVertex(destKey), weight));

        internal KeyGraph<T> Build()
        {
            var graph = new Graph(Order);

            foreach (var (src, dest, weight) in _edges)
                graph.AddEdge(src, dest, weight);

            return new KeyGraph<T>(graph, _keys);
        }

        private int GetVertex(T key)
        {
            if (_vertices.TryGetValue(key, out var vertex)) return vertex;

            vertex = Order;
            _vertices.Add(key, vertex);
            _keys.Add(key);
            return vertex;
        }

        private int Order
        {
            get {
                var order = _vertices.Count;
                Debug.Assert(_keys.Count == order);
                return order;
            }
        }

        private readonly Dictionary<T, int> _vertices = new();

        private readonly List<T> _keys = new();

        private readonly List<(int src, int dest, int weight)> _edges = new();
    }

    internal (T[] tour, int cost) FindMinCostTour()
    {
        var (tour, cost) = _graph.FindMinCostTour();
        return (Array.ConvertAll(tour, vertex => _keys[vertex]), cost);
    }

    private KeyGraph(Graph graph, IReadOnlyList<T> keys)
        => (_graph, _keys) = (graph, keys);

    private readonly Graph _graph;

    private readonly IReadOnlyList<T> _keys;
}
