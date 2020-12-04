import java.util.Optional;

class Solution {
    public int[] findOrder(int numCourses, int[][] prerequisites) {
        var graph = new Graph(numCourses);
        for (var edge : prerequisites) graph.addEdge(edge[1], edge[0]);

        return graph.toposort()
                .orElse(Collections.emptyList())
                .stream()
                .mapToInt(v -> v)
                .toArray();
    }
}

class Graph {
    Graph(int vertexCount) {
        _adj = new ArrayList<>(vertexCount);
        while (_adj.size() < vertexCount) _adj.add(new ArrayList<>());

        _indegrees = new int[vertexCount];
    }

    void addEdge(int src, int dest) {
        _adj.get(src).add(dest);
        ++_indegrees[dest];
    }

    Optional<List<Integer>> toposort() {
        List<Integer> out = new ArrayList<>(order());
        var fringe = roots();
        var indegs = _indegrees.clone();

        while (!fringe.isEmpty()) {
            var src = fringe.remove();
            out.add(src);

            for (var dest : _adj.get(src))
                if (--indegs[dest] == 0) fringe.add(dest);
        }

        return out.size() == order() ? Optional.of(out) : Optional.empty();
    }

    private int order() {
        return _indegrees.length;
    }

    private Queue<Integer> roots() {
        var deque = IntStream.range(0, order())
                     .filter(vertex -> _indegrees[vertex] == 0)
                     .boxed()
                     .collect(Collectors.toCollection(ArrayDeque::new));

        return Collections.asLifoQueue(deque);
    }

    private final List<List<Integer>> _adj;

    private final int[] _indegrees;
}
