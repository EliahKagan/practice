// Jim and his LAN Party
// https://www.hackerrank.com/challenges/jim-and-his-lan-party
// In Java 8.

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * A network of elements representing users or machines, each of whom is a
 * member of exactly one group, which can meet/play when all members are
 * connected in a component (possibly shared with members of other groups).
 */
final class Network {
    /**
     * Creates a new network of disconnected elements whose groups are known.
     * @param groupCount  Groups are [0, {@code groupCount}).
     * @param elementGroups  Elements are [0, {@code elementGroups.length}).
     *   Element {@code i} is a member of {@code elementGroups[i]}.
     */
    Network(int groupCount, int[] elementGroups) {
        _groupSizes = new int[groupCount];
        for (int group : elementGroups) ++_groupSizes[group];

        _groupCompletionTimes =
            Arrays.stream(_groupSizes)
                  .map(size -> size < 2 ? _time : NOT_CONNECTED)
                  .toArray();

        _elemContributions =
            Arrays.stream(elementGroups)
                  .mapToObj(group -> _groupCompletionTimes[group] == NOT_CONNECTED
                                        ? singletonContribution(group)
                                        : null)
                  .collect(Collectors.toCollection(ArrayList::new));

        int totalSize = elementGroups.length;
        _elemParents = IntStream.range(0, totalSize).toArray();
        _elemRanks = new int[totalSize];
    }

    /**
     * Retrieves the times at which each group finished being connected.
     * For groups that were never connected, {@code NOT_CONNECTED} is returned.
     * @return A stream of times in group order.
     */
    IntStream completionTimes() {
        return Arrays.stream(_groupCompletionTimes);
    }

    /** Adds an edge/wire connecting {@code elem1} and {@code elem2}. */
    void connect(int elem1, int elem2) {
        ++_time;

        // Find the ancestors and stop if they are already the same.
        elem1 = findSet(elem1);
        elem2 = findSet(elem2);
        if (elem1 == elem2) return;

        // Union by rank, merging contributions.
        if (_elemRanks[elem1] < _elemRanks[elem2]) {
            join(elem2, elem1);
        } else {
            if (_elemRanks[elem1] == _elemRanks[elem2]) ++_elemRanks[elem1];
            join(elem1, elem2);
        }
    }

    static final int NOT_CONNECTED = -1;

    private static Map<Integer, Integer> singletonContribution(int group) {
        Map<Integer, Integer> contrib = new HashMap<>();
        contrib.put(group, 1);
        return contrib;
    }

    /** Union-find "findset" operation with full path compression. */
    private int findSet(int elem) {
        // Find the ancestor.
        int leader = elem;
        while (leader != _elemParents[leader]) leader = _elemParents[leader];

        // Compress the path.
        while (elem != leader) {
            int parent = _elemParents[elem];
            _elemParents[elem] = leader;
            elem = parent;
        }

        return leader;
    }

    /**
     * Joins sets and merges their contributions to the parent.
     * @param parent  The leader of the new parent set.
     * @param child  The current leader of the new child set.
     */
    private void join(int parent, int child) {
        _elemParents[child] = parent;

        Map<Integer, Integer> merged = mergeContributions(
                                        _elemContributions.get(parent),
                                        _elemContributions.get(child));

        _elemContributions.set(parent, merged);
        _elemContributions.set(child, null);
    }

    /**
     * Merges contributions into whichever contribution map started out larger,
     * recording and removing items that became complete as a result.
     * @param contrib1  The first contribution map. If both maps have the same
     *                  number of entries, this one is used as the sink.
     * @param contrib2  The second contribution map.
     * @return  The resulting map, or null if that map is ultimately empty.
     */
    private Map<Integer, Integer>
    mergeContributions(Map<Integer, Integer> contrib1,
                       Map<Integer, Integer> contrib2) {
        // If either or both is null, there is nothing to do.
        if (contrib1 == null) return contrib2;
        if (contrib2 == null) return contrib1;

        // Merge to the bigger one (so we loop over the smaller).
        return contrib1.size() < contrib2.size()
                ? doMergeContributions(contrib2, contrib1)
                : doMergeContributions(contrib1, contrib2);
    }

    /**
     * Merges {@code source} into {@code sink}.
     * Helper for {@link #mergeContributions(Map, Map)}.
     */
    private Map<Integer, Integer>
    doMergeContributions(Map<Integer, Integer> sink,
                         Map<Integer, Integer> source) {
        source.forEach((group, count) -> {
            sink.merge(group, count, (sourceCount, sinkCount) -> {
                if (sinkCount + sourceCount < _groupSizes[group])
                    return sinkCount + sourceCount;

                _groupCompletionTimes[group] = _time;
                return null;
            });
        });

        return sink.isEmpty() ? null : sink;
    }

    private int _time = 0;
    private final int[] _groupSizes;
    private final int[] _groupCompletionTimes;
    private final List<Map<Integer, Integer>> _elemContributions;
    private final int[] _elemParents;
    private final int[] _elemRanks;
}

enum Solution {
    ;

    public static void main(String[] args) {
        try (Scanner sc = new Scanner(System.in)) {
            run(sc);
        }
    }

    /** Solves one problem instance, reading its description from stdin. */
    private static void run(Scanner sc) {
        // Read the problem parameters.
        int playerCount = sc.nextInt();
        int gameCount = sc.nextInt();
        int wireCount = sc.nextInt();

        // Make the LAN.
        Network network = new Network(gameCount + 1, // 1-based indexing
                                      readPlayerGames(sc, playerCount));

        // Apply all the connections.
        for (int wire = 0; wire < wireCount; ++wire) {
            int elem1 = sc.nextInt();
            int elem2 = sc.nextInt();
            network.connect(elem1, elem2);
        }

        // Skip the extra 0 group and print other groups' completion times.
        network.completionTimes().skip(1).forEachOrdered(System.out::println);
    }

    /** Reads each player's game. Prepends a 0 for 1-based indeixng. */
    private static int[] readPlayerGames(Scanner sc, int playerCount) {
        return prefixZero(readRecord(sc, playerCount)).toArray();
    }

    /** Reads {@code count} integers from {@code sc} as a stream. */
    private static IntStream readRecord(Scanner sc, int count) {
        return IntStream.range(0, count).map(i -> sc.nextInt());
    }

    /** Adds a leading 0 element. (Used to facilitate 1-based indexing.) */
    private static IntStream prefixZero(IntStream stream) {
        return IntStream.concat(IntStream.of(0), stream);
    }
}
