<Query Kind="Program" />

// Advent of Code, day 9, part A

#LINQPad optimize+

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

    internal (IList<int> tour, int cost) FindMinCostTour()
    {
        _adj.Dump(nameof(_adj));

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

    internal (IList<T> tour, int cost) FindMinCostTour()
    {
        var (tour, cost) = _graph.FindMinCostTour();
        return (tour.Select(vertex => _keys[vertex]).ToList(), cost);
    }

    private KeyGraph(Graph graph, IReadOnlyList<T> keys)
        => (_graph, _keys) = (graph, keys);

    private readonly Graph _graph;

    private readonly IReadOnlyList<T> _keys;
}

internal static class Program {
    private static void Main(string[] args)
    {
        var path = (args.Length == 0 ? "input" : args[0]);

        var (tour, cost) = ReadEdges(path)
            .Reverse()//.ToList() // Fail fast on syntax errors.
            .ToKeyGraph()
            .FindMinCostTour();

        tour.Dump(nameof(tour));
        cost.Dump(nameof(cost));
    }

    private static IEnumerable<(string src, string dest, int weight)>
    ReadEdges(string path)
        => from line in File.ReadLines(path)
           where !string.IsNullOrWhiteSpace(line)
           select EdgePattern.Match(line) into match
           select (match.Get("src"),
                   match.Get("dest"),
                   int.Parse(match.Get("weight")));

    private static KeyGraph<T>
    ToKeyGraph<T>(this IEnumerable<(T src, T dest, int weight)> edges)
        where T : notnull
    {
        var builder = new KeyGraph<T>.Builder();

        foreach (var (src, dest, weight) in edges)
            builder.AddEdge(src, dest, weight);

        return builder.Build();
    }

    private static string Get(this Match match, string name)
        => match.Groups[name].Value;

    private static readonly Regex EdgePattern =
        new(@"^\s*(?<src>\w+)\s+to\s+(?<dest>\w+)\s+=\s+(?<weight>\d+)\s*$");
}
