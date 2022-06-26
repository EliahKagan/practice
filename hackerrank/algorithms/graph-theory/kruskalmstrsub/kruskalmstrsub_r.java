// Kruskal (MST): Really Special Subtree - Kruskal's algorithm
// https://www.hackerrank.com/challenges/kruskalmstrsub
// This version uses records. This feature became stable in Java 16.

import java.util.Comparator;
import java.util.Scanner;
import java.util.stream.IntStream;
import java.util.stream.Stream;

/** Disjoint-set union data structure over a range of nonnegative integers. */
final class DisjointSets {
    /**
     * Creates a disjoint-set union with singletons 0 to elementCount - 1.
     * @param elementCount  The number of makeset operations to perform.
     */
    DisjointSets(int elementCount) {
        _parents = IntStream.range(0, elementCount).toArray();
        _ranks = new int[elementCount];
    }

    /**
     * Joins two elements' sets, if they are not already the same.
     * @param elem1  The first element whose set participates in the union.
     * @param elem2  The second element whose set participates in the union.
     * @return true if the sets were separate, false otherwise
     */
    boolean union(int elem1, int elem2) {
        // Find the ancestors and stop if they are already the same.
        elem1 = findSet(elem1);
        elem2 = findSet(elem2);
        if (elem1 == elem2) return false;

        // Unite by rank.
        if (_ranks[elem1] < _ranks[elem2]) {
            _parents[elem1] = elem2;
        } else {
            if (_ranks[elem1] == _ranks[elem2]) ++_ranks[elem1];
            _parents[elem2] = elem1;
        }

        return true;
    }

    private int findSet(int elem) {
        var leader = elem;

        // Find the ancestor.
        while (leader != _parents[leader]) leader = _parents[leader];

        // Compress the path.
        while (elem != leader) {
            var parent = _parents[elem];
            _parents[elem] = leader;
            elem = parent;
        }

        return leader;
    }

    private final int[] _parents;

    private final int[] _ranks;
}

/** A weighted edge in an undirected graph. */
final record Edge(int u, int v, int weight) { }

final class Solution {
    public static void main(String[] args) {
        try (var scanner = new Scanner(System.in)) {
            var vertexCount = scanner.nextInt();
            var edgeCount = scanner.nextInt();
            var sets = new DisjointSets(vertexCount + 1);

            var totalWeight = Stream.generate(() -> readEdge(scanner))
                .limit(edgeCount)
                .sorted(Comparator.comparingInt(Edge::weight))
                .sequential()
                .filter(edge -> sets.union(edge.u(), edge.v()))
                .mapToInt(Edge::weight)
                .sum();

            System.out.println(totalWeight);
        }
    }

    private static Edge readEdge(Scanner scanner) {
        var u = scanner.nextInt();
        var v = scanner.nextInt();
        var weight = scanner.nextInt();
        return new Edge(u, v, weight);
    }
}
