<Query Kind="Program">
  <Namespace>System.Diagnostics.Contracts</Namespace>
</Query>

// Advent of code 2015, part A
// Via bottom-up toposort via Kahn's algorithm, no cycle checking.

internal sealed class IndexGraph {
    internal int Count => _adj.Count;

    internal int MakeVertex()
    {
        _adj.Add(new List<int>());
        _indegrees.Add(0);
        Contract.Assert(Count == _indegrees.Count);
        return Count - 1;
    }
    
    internal void AddEdge(int src, int dest)
    {
        EnsureExists(src);
        EnsureExists(dest);
        _adj[src].Add(dest);
        ++_indegrees[dest];
    }
    
    internal IEnumerable<int> TopologicalSort()
    {
        if (_toposortStarted) {
            throw new InvalidOperationException(
                    "topological sort already started");
        }
        
        _toposortStarted = true;
        return DoTopologicalSort();
    }
    
    private IEnumerable<int> DoTopologicalSort()
    {
        for (var roots = GetRoots(); roots.Count != 0; ) {
            var src = roots.Dequeue();
            
            foreach (var dest in _adj[src])
                if (--_indegrees[dest] == 0) roots.Enqueue(dest);
            
            yield return src;
        }
    }
    
    private Queue<int> GetRoots()
        => new Queue<int>(from vertex in Enumerable.Range(0, Count)
                          where _indegrees[vertex] != 0
                          select vertex);
    
    private void EnsureExists(int vertex)
    {
        if (0 <= vertex && vertex < Count) return;
        
        throw new IndexOutOfRangeException(message: "vertex does not exist");
    }

    private readonly List<List<int>> _adj = new List<List<int>>();
    
    private readonly List<int> _indegrees = new List<int>();
    
    private bool _toposortStarted = false;
}

internal sealed class HashGraph<T> where T : notnull {
    internal int Count => _graph.Count;
    
    internal void AddEdge(T src, T dest)
        => _graph.AddEdge(GetIndex(src), GetIndex(dest));

    private int GetIndex(T key)
    {
        if (_indicesByKey.TryGetValue(key, out var index)) return index;
        
        index = _graph.MakeVertex();
        _indicesByKey.Add(key, index);
        _keysByIndex.Add(key);
        
        Contract.Assert(Count == _indicesByKey.Count);
        Contract.Assert(Count == _keysByIndex.Count);
        
        return index;
    }

    private readonly IndexGraph _graph = new IndexGraph();
    
    private readonly Dictionary<T, int> _indicesByKey =
        new Dictionary<T, int>();
    
    private readonly List<T> _keysByIndex = new List<T>();
}

internal sealed class Mapping {
    internal Mapping(string variable, string? operation,
                     string firstArgument, string? secondArgument)
    {
        // TODO: Validate that variable is a valid variable name.
    
        if (secondArgument == null) {
            if (operation != null && !Unaries.ContainsKey(operation)) {
                throw new ArgumentException(
                        paramName: nameof(operation),
                        message: $"unrecognized unary operation: {operation}");
            }
        } else if (operation == null || !Binaries.ContainsKey(operation)) {
            throw new ArgumentException(
                paramName: nameof(operation),
                message: $"unrecognized binary operation: {operation}");
        }
    
        Variable = variable;
        _operation = operation;
        _firstArgument = firstArgument;
        _secondArgument = secondArgument;
    }
    
    internal string Variable { get; }
    
    internal IEnumerable<string> Terms
    {
        get {
            yield return _firstArgument;
            if (_secondArgument != null) yield return _secondArgument;
        }
    }
    
    private static IReadOnlyDictionary<string, Func<ushort, ushort>>
    Unaries = new Dictionary<string, Func<ushort, ushort>> {
        { "NOT", arg => (ushort)~arg }
    };

    private static IReadOnlyDictionary<string, Func<ushort, ushort, ushort>>
    Binaries = new Dictionary<string, Func<ushort, ushort, ushort>> {
        { "AND", (arg1, arg2) => (ushort)(arg1 & arg2) },
        { "OR", (arg1, arg2) => (ushort)(arg1 | arg2) },
        { "LSHIFT", (arg1, arg2) => (ushort)(arg1 << arg2) },
        { "RSHIFT", (arg1, arg2) => (ushort)(arg1 >> arg2) }
    };
    
    private ushort Evaluate(IReadOnlyDictionary<string, ushort> variables)
    {
        var arg1 = GetTerm(variables, _firstArgument);
        if (_operation == null) return arg1;
        if (_secondArgument == null) return Unaries[_operation](arg1);
        
        var arg2 = GetTerm(variables, _secondArgument);
        return Binaries[_operation](arg1, arg2);
    }
    
    private ushort GetTerm(IReadOnlyDictionary<string, ushort> variables,
                           string term)
        => ushort.TryParse(term, out var value) ? value : variables[term];
    
    private readonly string? _operation;
    
    private readonly string _firstArgument;
    
    private readonly string? _secondArgument;
}

internal sealed class Scope {
    private readonly Dictionary<
}
