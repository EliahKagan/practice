<Query Kind="Program" />

// https://www.hackerrank.com/challenges/dijkstrashortreach
// In C# 6.0 (because HackerRank doesn't support newer versions).
// Dijkstra's algorithm, using a naive linear-time extract-min data structure.

/// <summary>
/// A naive linear-time extra-min data structure for implementing Prim's and
/// Dijkstra's algorithms.
/// </summary>
internal sealed class NaivePrimHeap {
    /// <summary>An entry, representing a vertex -> min-cost mapping.</summary>
    internal struct Entry {
        internal Entry(int vertex, int cost)
        {
            Vertex = vertex;
            Cost = cost;
        }

        internal int Vertex { get; }
        internal int Cost { get; }
    }
    
    /// <summary> Creates a NaivePrimHeap with a set capacity.</summary>
    /// <param name="capacity">The number of vertices supported.</param>
    /// <remarks>Keys must range from 0 to <c>capacity</c> - 1.</remarks>
    internal NaivePrimHeap(int capacity)
    {
        if (capacity < 0) {
            throw new ArgumentOutOfRangeException(
                    paramName: nameof(capacity),
                    message: "a negative capacity makes no sense");
        }
        
        _costs = new int[capacity];
        
        for (var vertex = 0; vertex < _costs.Length; ++vertex)
            _costs[vertex] = NotFound;
        
        Count = 0;
    }

    internal int Count { get; private set; }

    internal int Capacity => _costs.Length;

    internal void InsertOrDecrease(int vertex, int cost)
    {
        if (!(0 <= vertex && vertex < Capacity)) {
            throw new ArgumentOutOfRangeException(
                    paramName: nameof(vertex),
                    message: $"vertex not in range [0, {Capacity})");
        }
        
        if (cost < 0) {
            throw new ArgumentException(paramName: nameof(cost),
                                        message: $"cost must be nonnegative");
        }

        if (_costs[vertex] == NotFound) {
            _costs[vertex] = cost;
            ++Count;
        } else if (cost < _costs[vertex]) {
            _costs[vertex] = cost;
        }
    }

    internal Entry ExtractMin()
    {
        if (Count == 0) {
            throw new InvalidOperationException(
                    "can't extract from empty heap");
        }
        
        var u = 0;
        while (_costs[u] == NotFound) ++u;
        
        for (var v = u + 1; v < Capacity; ++v)
            if (_costs[v] != NotFound && _costs[v] < _costs[u]) u = v;
        
        var ret = new Entry(u, _costs[u]);
        _costs[u] = NotFound;
        --Count;
        return ret;
    }

    private const int NotFound = -1;

    private readonly int[] _costs;
}

internal sealed class Graph {
    /// <summary>Creates a graph with a specified number of vertices.</summary>
    /// <param name="order">The vertex count.</param>
    internal Graph(int order)
    {
        if (order < 0) {
            throw new ArgumentOutOfRangeException(
                    paramName: nameof(order),
                    message: "graph can't have negatively many vertices");
        }

        // Create an empty adjacency list.
        _adj = new List<OutEdge>[order];
        for (var i = 0; i < order; ++i) _adj[i] = new List<OutEdge>();
    }

    internal int Order => _adj.Length;

    /// <summary>Adds a weighted edge to this undirected graph.</summary>
    /// <param name="u">The first vertex.</param>
    /// <param name="v">The second vertex.</param>
    /// <param name="weight">The edge weight.</param>
    internal void AddEdge(int u, int v, int weight)
    {
        // This ensures no change is made if an exception is thrown
        // (and also gives an understandable stack trace).
        EnsureExists(nameof(u), u);
        EnsureExists(nameof(v), v);

        // Add entries to both vertices' rows, as the graph is undirected.
        _adj[u].Add(new OutEdge(v, weight));
        _adj[v].Add(new OutEdge(u, weight));
    }

    internal int[] ComputeDijkstraShortestPathCosts(int start)
    {
        EnsureExists(nameof(start), start);

        var costs = InfiniteCosts;
        var heap = new NaivePrimHeap(Order);

        for (heap.InsertOrDecrease(start, 0); heap.Count != 0; ) {
            var src = heap.ExtractMin();
            costs[src.Vertex] = src.Cost;

            foreach (var dest in _adj[src.Vertex]) {
                if (costs[dest.Vertex] == NotReached)
                    heap.InsertOrDecrease(dest.Vertex, src.Cost + dest.Weight);
            }
        }

        return costs;
    }

    private struct OutEdge {
        internal OutEdge(int vertex, int weight)
        {
            Vertex = vertex;
            Weight = weight;
        }

        internal int Vertex { get; }
        internal int Weight { get; }
    }

    private const int NotReached = -1;

    private int[] InfiniteCosts {
        get {
            var costs = new int[Order];
            for (var i = 0; i < costs.Length; ++i) costs[i] = NotReached;
            return costs;
        }
    }

    private void EnsureExists(string vertexParamName, int vertexValue)
    {
        if (!(0 <= vertexValue && vertexValue < Order)) {
            throw new ArgumentOutOfRangeException(
                    paramName: vertexParamName,
                    message: "vertex out of range (not in graph)");
        }
    }

    private readonly List<OutEdge>[] _adj;
}

internal static class Solution {
    private static int ReadValue() => int.Parse(Console.ReadLine());

    private static int[] ReadRecord()
        => Array.ConvertAll(
            Console.ReadLine().Split((char[])null,
                                     StringSplitOptions.RemoveEmptyEntries),
            int.Parse);
    
    private static Graph ReadGraph()
    {
        var parameters = ReadRecord();
        var vertexCount = parameters[0];
        var edgeCount = parameters[1];
        var graph = new Graph(vertexCount + 1); // +1 for 1-based indexing

        while (edgeCount-- > 0) {
            var edgeValues = ReadRecord();
            var u = edgeValues[0];
            var v = edgeValues[1];
            var weight = edgeValues[2];
            graph.AddEdge(u, v, weight);
        }

        return graph;
    }

    private static void DisplayCosts(int[] costs, int start)
    {
        var builder = new StringBuilder();

        for (var i = 1; i < costs.Length; ++i)
            if (i != start) builder.Append(costs[i]).Append(' ');
        
        Console.WriteLine(builder);
    }

    private static void Main()
    {
        for (var t = ReadValue(); t > 0; --t) {
            var graph = ReadGraph();
            var start = ReadValue();
            var costs = graph.ComputeDijkstraShortestPathCosts(start);
            DisplayCosts(costs, start);
        }
    }
}
