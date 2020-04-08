// https://www.hackerrank.com/challenges/bfsshortreach
// In Java 8. (Using breadth-first search.)

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.List;
import java.util.Queue;
import java.util.Scanner;
import java.util.StringJoiner;
import java.util.stream.IntStream;

/** Error indicating that the input does not satisfy problem constraints. */
class InputError extends Error {
    InputError(final String message) {
        super(message);
    }
}

final class Solution {
    /** Ensures the specific vertex and edge counts are nonnegative. */
    private static void checkGraphParameters(final int vertexCount,
                                             final int edgeCount) {
        if (vertexCount < 0)
            throw new InputError("can't have negatively many vertices");

        if (edgeCount < 0)
            throw new InputError("can't have negatively many edges");
    }

    /** Creates an adjacency list for a graph of isolated vertices. */
    private static List<List<Integer>> getEmptyGraph(final int vertexCount) {
        // +1 for 1-based indexing
        final List<List<Integer>> adj = new ArrayList<>(vertexCount + 1);
        while (adj.size() <= vertexCount) adj.add(new ArrayList<>());
        return adj;
    }

    /** Reads a graph as an adjacency list. */
    private static List<List<Integer>> readGraph(final Scanner sc) {
        final int vertexCount = sc.nextInt(), edgeCount = sc.nextInt();
        checkGraphParameters(vertexCount, edgeCount);

        final List<List<Integer>> adj = getEmptyGraph(vertexCount);

        for (int moreEdges = edgeCount; moreEdges > 0; --moreEdges) {
            final int u = sc.nextInt(), v = sc.nextInt();
            adj.get(u).add(v); // Throws if u is out of range, as desired.
            adj.get(v).add(u); // Throws if v is out of range, as desired.
        }

        return adj;
    }

    /**
     * Given as the minimum cost to reach an unreachable vetex. Conceptually,
     * this value represents positive infinity.
     */
    private static final int NOT_REACHED = -1;

    /** Gets the "best known costs" of all unreached vertices. */
    private static int[] getUnpopulatedCosts(final int vertexCount) {
        return IntStream.rangeClosed(0, vertexCount)
                        .map(i -> NOT_REACHED)
                        .toArray();
    }

    /**
     * Computes path lengths, with edge weights of 1, from src to each vertex.
     */
    private static int[] bfs(final List<List<Integer>> adj, final int start) {
        final int[] costs = getUnpopulatedCosts(adj.size() - 1);
        costs[start] = 0;
        final Queue<Integer> queue = new ArrayDeque<>();
        queue.add(start);

        for (int cost = 1; !queue.isEmpty(); ++cost) {
            for (int breadth = queue.size(); breadth != 0; --breadth) {
                for (final int dest : adj.get(queue.remove())) {
                    if (costs[dest] != NOT_REACHED) continue;
                    costs[dest] = cost;
                    queue.add(dest);
                }
            }
        }

        return costs;
    }

    /** Each edge actually has this weight, rather than 1. */
    private static final int EDGE_WEIGHT = 6;

    /** Reports the actual costs from start to every other vertex. */
    private static void report(final int[] costs, final int start) {
        final StringJoiner sj = new StringJoiner(" ");

        IntStream.concat(IntStream.range(1, start),
                         IntStream.range(start + 1, costs.length))
                 .map(vertex -> costs[vertex])
                 .map(cost -> cost == NOT_REACHED ? NOT_REACHED
                                                  : cost * EDGE_WEIGHT)
                 .mapToObj(Integer::toString)
                 .forEachOrdered(sj::add);

        System.out.println(sj);
    }

    public static void main(final String[] args) {
        try (final Scanner sc = new Scanner(System.in)) {
            for (int q = sc.nextInt(); q > 0; --q) {
                final List<List<Integer>> adj = readGraph(sc);

                final int start = sc.nextInt();
                if (!(0 < start && start < adj.size()))
                    throw new InputError("start vertex is not in graph");

                report(bfs(adj, start), start);
            }
        }
    }

    private Solution() { throw new AssertionError(); }
}
