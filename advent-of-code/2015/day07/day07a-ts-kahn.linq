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
    
    internal IEnumerable<T> TopologicalSort()
        => _graph.TopologicalSort().Select(index => _keysByIndex[index]);

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

internal sealed class Expression {
    internal static Expression FromTokens(params string[] tokens)
        => tokens.Length switch {
            1 => new Expression(null, tokens[0], null),
            2 => new Expression(tokens[0], tokens[1], null),
            3 => new Expression(tokens[1], tokens[0], tokens[2]),
            _ => throw new ArgumentException(paramName: nameof(tokens),
                                             message: "malformed expression")
        };
    
    internal IEnumerable<string> Terms
    {
        get {
            yield return _firstArgument;
            if (_secondArgument != null) yield return _secondArgument;
        }
    }
    
    internal ushort Evaluate(IReadOnlyDictionary<string, ushort> variables)
    {
        var arg1 = GetTerm(variables, _firstArgument);
        if (_operation == null) return arg1;
        if (_secondArgument == null) return Unaries[_operation](arg1);
        
        var arg2 = GetTerm(variables, _secondArgument);
        return Binaries[_operation](arg1, arg2);
    }

    private Expression(string? operation,
                       string firstArgument,
                       string? secondArgument)
    {
        if (secondArgument == null) {
            if (operation != null && !Unaries.ContainsKey(operation)) {
                throw new ArgumentException(
                        paramName: nameof(operation),
                        message: $"unrecognized unary operation: {operation}");
            }
        } else if (operation == null) {
            throw new ArgumentException(
                    paramName: nameof(secondArgument),
                    message: "got two arguments but no operation to perform");
        } else if (!Binaries.ContainsKey(operation)) {
            throw new ArgumentException(
                    paramName: nameof(operation),
                    message: $"unrecognized binary operation: {operation}");
        }
    
        _operation = operation;
        _firstArgument = firstArgument;
        _secondArgument = secondArgument;
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
    
    private ushort GetTerm(IReadOnlyDictionary<string, ushort> variables,
                           string term)
        => ushort.TryParse(term, out var value) ? value : variables[term];
    
    private readonly string? _operation;
    
    private readonly string _firstArgument;
    
    private readonly string? _secondArgument;
}

internal sealed class Scope {
    internal void Set(string variable, Expression expression)
        => _expressions[variable] = expression;
    
    internal void Set(string binding)
    {
        var parts = Array.ConvertAll(binding.Split(" -> "),
                                     side => side.Trim());
        
        if (parts.Length != 2) {
            throw new ArgumentException(
                    paramName: nameof(binding),
                    message: $"malformed binding: {binding.Trim()}");
        }
        
        Set(parts[1], Expression.FromTokens(Lex(parts[0])));
    }
    
    internal IDictionary<string, ushort> Solve()
    {
        var values = new Dictionary<string, ushort>();
        
        foreach (var (variable, expression) in _expressions)
            values[variable] = expression.Evaluate(values);
        
        return values;
    }
    
    private static string[] Lex(string record)
        => record.Split(default(char[]?),
                        StringSplitOptions.RemoveEmptyEntries);

    private readonly Dictionary<string, Expression> _expressions =
        new Dictionary<string, Expression>();
}

internal static class Program {
    private static Scope ToScope(this IEnumerable<string> lines)
    {
        var scope = new Scope();
        var bindings = lines.Where(line => !string.IsNullOrWhiteSpace(line));
        foreach (var binding in bindings) scope.Set(binding);
        return scope;
    }
    
    private static void SolveTinyExample()
    {
        var example = @"
            123 -> x
            456 -> y
            x AND y -> d
            x OR y -> e
            x LSHIFT 2 -> f
            y RSHIFT 2 -> g
            NOT x -> h
            NOT y -> i
        ";
        
        example.Split('\n')
               .ToScope()
               .Solve()
               .OrderBy(kv => kv.Key)
               .Dump("tiny example, showing all variables", noTotals: true);
    }
    
    private static void SolveFullProblem(string path)
    {
        var scope = File.ReadLines(path).ToScope();
        
        scope.Solve()["a"]
             .Dump("full problem, showing the specified variable");
    }
    
    private static void Main(string[] args)
    {
        if (args == null || args.Length == 0) {
            SolveTinyExample();
        } else if (args.Length == 1) {
            SolveFullProblem(args[0]);
        } else {
            throw new ArgumentException(paramName: nameof(args),
                                        message: "too many arguments");
        }
    }
}
