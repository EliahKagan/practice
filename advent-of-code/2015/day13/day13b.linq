<Query Kind="Program" />

// Advent of Code, day 13, part B

#LINQPad optimize+

internal sealed class Graph {
    internal static Graph CreateZeroCostCompleteGraph(int order) => new(order);

    internal void ChangeUndirectedEdgeWeight(int u, int v, int weightDelta)
    {
        // Change edge weights transactionally (so there is no change if an
        // exception is thrown). This doesn't matter for the current
        // implementation, but it can matter if directed edges are supported
        // (e.g., if a ChangeDirectedEdgeWeight method is added).
        var uv = checked(_adj[u, v] + weightDelta);
        var vu = checked(_adj[v, u] + weightDelta);
        _adj[u, v] = uv;
        _adj[v, u] = vu;
    }

    internal (IList<int> path, int cost) FindMaxCostHamiltonianPath()
    {
        var bestPath = Enumerable.Repeat(-1, Order).ToArray();
        var bestCost = -Infinity;
        var vis = new bool[Order];
        var path = new List<int>();
        var cost = 0;

        void SearchFrom(int src)
        {
            Debug.Assert(!vis[src]);
            vis[src] = true;
            path.Add(src);

            if (path.Count < Order) {
                for (var dest = 0; dest < Order; ++dest) {
                    if (vis[dest] || _adj[src, dest] == Infinity) continue;

                    cost = checked(cost + _adj[src, dest]);
                    SearchFrom(dest);
                    cost = checked(cost - _adj[src, dest]);
                }
            } else if (cost > bestCost) {
                path.CopyTo(bestPath);
                bestCost = cost;
            }

            path.RemoveAt(path.Count - 1);
            vis[src] = false;
        }

        for (var start = 0; start < Order; ++start) SearchFrom(start);
        return (bestPath, bestCost);
    }

    private Graph(int order) => _adj = new int[order, order];

    private const int Infinity = int.MaxValue;

    private int Order => _adj.GetLength(0);

    private readonly int[,] _adj;
}

internal sealed class KeyGraph<T> where T : notnull {
    internal sealed class Builder {
        internal void
        ChangeUndirectedEdgeWeight(T uKey, T vKey, int weightDelta)
            => _edgeDeltas.Add((GetVertex(uKey),
                                GetVertex(vKey),
                                weightDelta));

        internal KeyGraph<T> Build()
        {
            var graph = Graph.CreateZeroCostCompleteGraph(Order);

            foreach (var (src, dest, weightDelta) in _edgeDeltas)
                graph.ChangeUndirectedEdgeWeight(src, dest, weightDelta);

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

        private readonly List<(int u, int v, int weight)> _edgeDeltas = new();
    }

    internal (IList<T> cycle, int cost) FindMaxCostHamiltonianPath()
    {
        var (path, cost) = _graph.FindMaxCostHamiltonianPath();
        return (path.Select(vertex => _keys[vertex]).ToList(), cost);
    }

    private KeyGraph(Graph graph, IReadOnlyList<T> keys)
        => (_graph, _keys) = (graph, keys);

    private readonly Graph _graph;

    private readonly IReadOnlyList<T> _keys;
}

internal static class Program {
    private static void Main(string[] args)
    {
        var filespec = (args.Length == 0 ? "input" : args[0]);

        var (path, cost) = ReadEdges(filespec)
            .ToList() // Fail fast on syntax errors.
            .ToKeyGraph()
            .FindMaxCostHamiltonianPath();

        path.Dump(nameof(path));
        cost.Dump(nameof(cost));
    }

    private static IEnumerable<(string u, string v, int weightDelta)>
    ReadEdges(string filespec)
        => from line in File.ReadLines(filespec)
           where !string.IsNullOrWhiteSpace(line)
           select EdgeDeltaPattern.Match(line) into match
           let u = match.Get("u")
           let v = match.Get("v")
           let sign = match.Get("sign") switch {
                "gain" => +1,
                "lose" => -1,
                _ => throw new NotSupportedException(
                        "Bug: uncaught syntax error")
            }
           let magnitude = int.Parse(match.Get("magnitude"))
           select (u: u, v: v, weightDelta: sign * magnitude);

    private static KeyGraph<T>
    ToKeyGraph<T>(this IEnumerable<(T u, T v, int weightDelta)> edgeDeltas)
        where T : notnull
    {
        var builder = new KeyGraph<T>.Builder();

        foreach (var (u, v, weightDelta) in edgeDeltas)
            builder.ChangeUndirectedEdgeWeight(u, v, weightDelta);

        return builder.Build();
    }

    private static string Get(this Match match, string name)
        => match.Groups[name].Value;

    private static readonly Regex EdgeDeltaPattern =
        new(@"^\s*(?<u>\w+)\s+would\s+(?<sign>gain|lose)"
            + @"\s+(?<magnitude>\d+)\s+happiness\s+units?"
            + @"\s+by\s+sitting\s+next\s+to\s+(?<v>\w+)\.\s*$");
}
