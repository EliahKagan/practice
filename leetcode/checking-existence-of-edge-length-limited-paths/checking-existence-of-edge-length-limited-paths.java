// LeetCode 1697 - Checking Existence of Edge Length Limited Paths

class Solution {
    public boolean[] distanceLimitedPathsExist(int order,
                                               int[][] edges,
                                               int[][] queries) {
        var results = new boolean[queries.length];

        distanceLimitedPathsExistHelper(new DisjointSets(order),
                                        edgesByWeight(edges),
                                        indexedQueriesByLimit(queries),
                                        results);

        return results;
    }

    List<Edge> edgesByWeight(int[][] edges) {
        return Arrays.stream(edges)
            .map(xs -> new Edge(xs[0], xs[1], xs[2]))
            .sorted(Comparator.comparingInt(Edge::weight))
            .collect(Collectors.toCollection(ArrayList::new));
    }

    List<Query> indexedQueriesByLimit(int[][] queries) {
        return IntStream.range(0, queries.length)
            .mapToObj(index -> new Query(queries[index][0],
                                         queries[index][1],
                                         queries[index][2],
                                         index))
            .sorted(Comparator.comparingInt(Query::limit))
            .collect(Collectors.toCollection(ArrayList::new));
    }

    private void distanceLimitedPathsExistHelper(DisjointSets sets,
                                                 List<Edge> edges,
                                                 List<Query> queries,
                                                 boolean[] results) {
        var edge_index = 0;

        for (var query : queries) {
            while (edge_index < edges.size()) {
                var edge = edges.get(edge_index);
                if (edge.weight() >= query.limit()) break;

                sets.union(edge.u(), edge.v());
                ++edge_index;
            }

            results[query.index()] =
                sets.findSet(query.start()) == sets.findSet(query.finish());
        }
    }
}

final class Edge {
    Edge(int u, int v, int weight) {
        _u = u;
        _v = v;
        _weight = weight;
    }

    int u() {
        return _u;
    }

    int v() {
        return _v;
    }

    int weight() {
        return _weight;
    }

    final int _u;
    final int _v;
    final int _weight;
}

final class Query {
    Query(int start, int finish, int limit, int index) {
        _start = start;
        _finish = finish;
        _limit = limit;
        _index = index;
    }

    int start() {
        return _start;
    }

    int finish() {
        return _finish;
    }

    int limit() {
        return _limit;
    }

    int index() {
        return _index;
    }

    final int _start;
    final int _finish;
    final int _limit;
    final int _index;
}

final class DisjointSets {
    DisjointSets(int elementCount) {
        _parents = IntStream.range(0, elementCount).toArray();
        _ranks = new int[elementCount];
    }

    void union(int elem1, int elem2) {
        // Find the ancestors and stop if they are already the same.
        elem1 = findSet(elem1);
        elem2 = findSet(elem2);
        if (elem1 == elem2) return;

        // Unite by rank.
        if (_ranks[elem1] < _ranks[elem2]) {
            _parents[elem1] = elem2;
        } else {
            if (_ranks[elem1] == _ranks[elem2]) ++_ranks[elem1];
            _parents[elem2] = elem1;
        }
    }

    int findSet(int elem) {
        // Find the ancestor.
        var leader = elem;
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
