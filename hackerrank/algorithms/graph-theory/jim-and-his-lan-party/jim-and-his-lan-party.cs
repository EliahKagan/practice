// Jim and his LAN Party
// https://www.hackerrank.com/challenges/jim-and-his-lan-party

using System;
using System.Collections.Generic;
using System.Linq;

/// <summary>
/// A network of elements representing users or machines, each of whom is a
/// member of exactly one group, which can meet/play when all members are
/// connected in a component (possibly shared with members of other groups).
/// </summary>
internal sealed class Network {
    /// <summary>
    /// Creates a new network of disconnected elements whose groups are known.
    /// </summary>
    /// <param name="groupCount">Groups are [0, <c>groupCount</c>).</param>
    /// <param name="elementGroups">
    /// Elements are [0, <c>elementGroups.Count</c>).
    /// Element <c>i</c> is a member of <c>elementGroups[i]</c>.
    /// </param>
    internal Network(int groupCount, IList<int> elementGroups)
    {
        _groupSizes = new int[groupCount];
        foreach (var group in elementGroups) ++_groupSizes[group];

        _groupCompletionTimes = _groupSizes
            .Select(size => size < 2 ? _time : NotConnected)
            .ToArray();

        _elemContributions = elementGroups
            .Select(group => _groupCompletionTimes[group] == NotConnected
                                ? SingletonContribution(group)
                                : null)
            .ToArray();

        var totalSize = elementGroups.Count;
        _elemParents = Enumerable.Range(0, totalSize).ToArray();
        _elemRanks = new int[totalSize];
    }

    /// <summary>
    /// The times at which each group finished becoming connected.
    /// For groups that were never connected, <c>NotConnected</c> is given.
    /// </summary>
    internal IEnumerable<int> CompletionTimes
        => _groupCompletionTimes.Select(x => x);

    /// <summary>
    /// Adds an edge/wire connecting <c>elem1</c> and <c>elem2</c>.
    /// </summary>
    internal void Connect(int elem1, int elem2)
    {
        ++_time;

        // Find the ancestors and stop if they are already the same.
        elem1 = FindSet(elem1);
        elem2 = FindSet(elem2);
        if (elem1 == elem2) return;

        // Union by rank, merging contributions.
        if (_elemRanks[elem1] < _elemRanks[elem2]) {
            Join(parent: elem2, child: elem1);
        } else {
            if (_elemRanks[elem1] == _elemRanks[elem2]) ++_elemRanks[elem1];
            Join(parent: elem1, child: elem2);
        }
    }

    internal const int NotConnected = -1;

    private static IDictionary<int, int> SingletonContribution(int group)
        => new Dictionary<int, int> { { group, 1 } };

    /// <summary>
    /// Union-find "findset" operation with full path compression.
    /// </summary>
    private int FindSet(int elem)
    {
        // Find the ancestor.
        var leader = elem;
        while (leader != _elemParents[leader]) leader = _elemParents[leader];

        // Compress the path.
        while (elem != leader) {
            var parent = _elemParents[elem];
            _elemParents[elem] = leader;
            elem = parent;
        }

        return leader;
    }

    /// <summary>Joins sets and merges contributions into the parent.</summary>
    /// <param name="parent">The leader of the new parent set.</param>
    /// <param name="child">The current leader of the new child set.</param>
    private void Join(int parent, int child)
    {
        _elemParents[child] = parent;

        _elemContributions[parent] = MergeContributions(
                                        _elemContributions[parent],
                                        _elemContributions[child]);
        _elemContributions[child] = null;
    }

    /// <summary>
    /// Merges contributions into whichever contribution dictionary started out
    /// larder, recording and removing items that became complete as a result.
    /// </summary>
    /// <param name="contrib1">The first contribution dictionary.</param>
    /// <param name="contrib2">The second contribution dictionary.</param>
    /// <returns>
    /// The resulting map, or <c>null</c> if it is ultimately empty.
    /// </returns>
    /// <remarks>
    /// If both contribution dictionaries have the same number of entries, the
    /// first one, <c>contrib1</c>, is used as the sink.
    /// </remarks>
    private IDictionary<int, int>
    MergeContributions(IDictionary<int, int> contrib1,
                       IDictionary<int, int> contrib2)
    {
        // If either or both is null, there is nothing to do.
        if (contrib1 == null) return contrib2;
        if (contrib2 == null) return contrib1;

        // Merge to the bigger one (so we loop over the smaller).
        return contrib1.Count < contrib2.Count
                ? DoMergeContributions(sink: contrib2, source: contrib1)
                : DoMergeContributions(sink: contrib1, source: contrib2);
    }

    /// <summary>Merges <c>source</c> into <c>sink</c>.</summary>
    /// <remarks>Helper for <see cref="MergeContributions"/>.</remarks>
    private IDictionary<int, int>
    DoMergeContributions(IDictionary<int, int> sink,
                         IDictionary<int, int> source)
    {
        foreach (var sourceEntry in source) {
            var group = sourceEntry.Key;
            var sourceCount = sourceEntry.Value;

            if (!sink.TryGetValue(group, out var sinkCount)) {
                sink.Add(group, sourceCount);
            } else if (sinkCount + sourceCount < _groupSizes[group]) {
                sink[group] = sinkCount + sourceCount;
            } else {
                sink.Remove(group);
                _groupCompletionTimes[group] = _time;
            }
        }

        return sink.Count == 0 ? null : sink;
    }

    private int _time = 0;
    private readonly IList<int> _groupSizes;
    private readonly IList<int> _groupCompletionTimes;
    private readonly IList<IDictionary<int, int>> _elemContributions;
    private readonly IList<int> _elemParents;
    private readonly IList<int> _elemRanks;
}

internal static class Solution {
    private static void Main()
    {
        // Read the problem parameters.
        // (The player count, counts[0], is currently not checked.)
        var counts = ReadRecord().ToArray();
        var gameCount = counts[1];
        var wireCount = counts[2];

        // Make the LAN.
        // The extra 0 element and 0 group faciliate 1-based indexing.
        var network = new Network(gameCount + 1,
                                  ReadRecord().Prepend(0).ToArray());

        // Read and apply all the connections.
        for (var wire = 0; wire < wireCount; ++wire) {
            var elems = ReadRecord().ToArray();
            network.Connect(elems[0], elems[1]);
        }

        // Skip the extra 0 group and print the other gorups' completion times.
        foreach (var time in network.CompletionTimes.Skip(1))
            Console.WriteLine(time);
    }

    /// <summary>Reads a line as a sequence of integers.</summary>
    private static IEnumerable<int> ReadRecord()
        => Console.ReadLine().Split((char[])null,
                                    StringSplitOptions.RemoveEmptyEntries)
                  .Select(int.Parse);
}
