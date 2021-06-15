// LeetCode #1579 - Remove Max Number of Edges to Keep Graph Fully Traversable
// https://leetcode.com/problems/remove-max-number-of-edges-to-keep-graph-fully-traversable/
// Modified Kruskal's algorithm. Takes shared edges first, then copies the DSU.

public class Solution {
    /// <summary>
    /// Computes the most edges that can be removed, keeping full connectivity
    /// for Alice and Bob.
    /// </summary>
    /// <returns>
    /// The number of edges that could be removed, or -1 if the graph was not
    /// fully connected.
    /// </returns>
    public int MaxNumEdgesToRemove(int n, int[][] edges)
        => ComputeMinSpanningEdges(n, GroupEdges(edges)) switch {
            int count => edges.Length - count,
            null => -1,
        };

    /// <summmary>
    /// Computes the minimum number of eges needed to achieve full connectivity
    /// for both Alice and Bob.
    /// </summary>
    private static int?
    ComputeMinSpanningEdges(int vertexCount,
                            ILookup<string, (int, int)> groups)
    {
        // Pick up edges both Alice and Bob can use, giving them to both.
        var aliceSets = new DisjointSets(vertexCount);
        var aliceBobCount = Connect(aliceSets, groups["AliceBob"]);
        var bobSets = aliceSets.Clone();

        // Pick up edges only Alice can use. Bail if Alice is still stranded.
        var aliceCount = Connect(aliceSets, groups["Alice"]);
        if (aliceBobCount + aliceCount + 1 < vertexCount) return null;

        // Pick up edges only Bob can use. Bail if Bob is still stranded.
        var bobCount = Connect(bobSets, groups["Bob"]);
        if (aliceBobCount + bobCount + 1 < vertexCount) return null;

        return aliceBobCount + aliceCount + bobCount;
    }

    private static ILookup<string, (int, int)> GroupEdges(int[][] edges)
        => edges.ToLookup(
            keySelector: edge => edge[0] switch {
                1 => "Alice",
                2 => "Bob",
                3 => "AliceBob",
                var type => throw new ArgumentException(
                                paramName: nameof(edges),
                                message: $"Unrecognized edge type {type}"),
            },
            elementSelector: edge => (edge[1], edge[2]));

    /// <summary>Adds connections due to edges.</summary>
    /// <returns>The number of edges that improved connectivity.</returns>
    private static int Connect(DisjointSets sets,
                               IEnumerable<(int, int)> edges)
    {
        var count = 0;

        foreach (var (u, v) in edges) {
            if (sets.SetCount < 2) break;
            if (sets.Union(u, v)) ++count;
        }

        return count;
    }
}

/// <summary>
/// Disjoint-set-union data structure for union-find algorithm.
/// </summary>
/// <remarks>Elements are 1-based.</remarks>
internal sealed class DisjointSets {
    /// <summary>Creates <c>elementCount</c> singletons.</summary>
    /// <remarks>
    /// Elements range from 1 to <c>elementCount</c> (incusive).
    /// </remarks>
    internal DisjointSets(int elementCount)
    {
        _parents = Enumerable.Range(0, elementCount + 1).ToArray();
        _ranks = new int[elementCount + 1];
        _setCount = elementCount;
    }

    /// <summary>The number of (separate) sets.</summary>
    internal int SetCount => _setCount;

    /// <summary>Creates a copy of this DisjointSets.</summary>
    internal DisjointSets Clone() => new DisjointSets(this);

    /// <summary>Union by rank with path compression.</summary>
    /// <returns>
    /// true iff the sets started separate (and were joined).
    /// </returns>
    internal bool Union(int elem1, int elem2)
    {
        // Find the ancestors and stop if they are already the same.
        elem1 = FindSet(elem1);
        elem2 = FindSet(elem2);
        if (elem1 == elem2) return false;

        // Unite by rank.
        if (_ranks[elem1] < _ranks[elem2]) {
            _parents[elem1] = elem2;
        } else {
            if (_ranks[elem1] == _ranks[elem2]) ++_ranks[elem1];
            _parents[elem2] = elem1;
        }

        --_setCount;
        return true;
    }

    /// <summary>Copy constructor. Helper for <see cref="Clone"/>.</summary>
    private DisjointSets(DisjointSets sets)
    {
        _parents = sets._parents[..];
        _ranks = sets._ranks[..];
        _setCount = sets._setCount;
    }

    private int ElementCount => _parents.Length - 1;

    private bool Exists(int elem) => 0 < elem && elem <= ElementCount;

    private int FindSet(int elem)
        => Exists(elem)
            ? DoFindSet(elem)
            : throw new ArgumentOutOfRangeException(
                    paramName: nameof(elem),
                    message: $"No such element: {elem}");

    private int DoFindSet(int elem)
    {
        if (_parents[elem] != elem)
            _parents[elem] = DoFindSet(_parents[elem]);

        return _parents[elem];
    }

    private readonly int[] _parents;

    private readonly int[] _ranks;

    int _setCount;
}
