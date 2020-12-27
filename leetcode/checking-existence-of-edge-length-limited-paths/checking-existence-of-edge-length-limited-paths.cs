// LeetCode 1697 - Checking Existence of Edge Length Limited Paths

public class Solution {
    public bool[] DistanceLimitedPathsExist(int order,
                                            int[][] edges,
                                            int[][] queries)
    {
        Array.Sort(edges, WeightOrLimitComparer);

        var indices = Enumerable.Range(0, queries.Length).ToArray();
        Array.Sort(queries, indices, WeightOrLimitComparer);

        IEnumerable<bool> Compute()
        {
            var sets = new DisjointSets(order);
            var i = 0;

            foreach (var query in queries) {
                var limit = WeightOrLimit(query);

                while (i != edges.Length && WeightOrLimit(edges[i]) < limit) {
                    var (u, v) = Endpoints(edges[i]);
                    sets.Union(u, v);
                    ++i;
                }

                var (start, finish) = Endpoints(query);
                yield return sets.FindSet(start) == sets.FindSet(finish);
            }
        }

        var results = Compute().ToArray();
        Array.Sort(indices, results);
        return results;
    }

    static Solution()
    {
        Comparison<int[]> compareByWeightOrLimit =
            (lhs, rhs) => WeightOrLimit(lhs).CompareTo(WeightOrLimit(rhs));

        WeightOrLimitComparer = Comparer<int[]>.Create(compareByWeightOrLimit);
    }

    private static IComparer<int[]> WeightOrLimitComparer { get; }

    private static (int, int) Endpoints(int[] edgeOrQuery)
        => (edgeOrQuery[0], edgeOrQuery[1]);

    private static int WeightOrLimit(int[] edgeOrQuery) => edgeOrQuery[2];
}

internal sealed class DisjointSets {
    internal DisjointSets(int elementCount)
    {
        _parents = Enumerable.Range(0, elementCount).ToArray();
        _ranks = new int[elementCount];
    }

    internal void Union(int elem1, int elem2)
    {
        // Find the ancestors and stop if they are already the same.
        elem1 = FindSet(elem1);
        elem2 = FindSet(elem2);

        // Unite by rank.
        if (_ranks[elem1] < _ranks[elem2]) {
            _parents[elem1] = elem2;
        } else {
            if (_ranks[elem1] == _ranks[elem2]) ++_ranks[elem1];
            _parents[elem2] = elem1;
        }
    }

    internal int FindSet(int elem)
    {
        // Find the ancestor.
        var leader = elem;
        while (leader != _parents[leader]) leader = _parents[leader];

        // Compress the path;
        while (elem != leader) {
            var parent = _parents[elem];
            _parents[elem] = leader;
            elem = parent;
        }

        return leader;
    }

    private readonly int[] _parents;

    private readonly int[] _ranks;
}
