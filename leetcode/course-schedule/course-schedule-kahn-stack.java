class Solution {
    public boolean canFinish(int numCourses, int[][] prerequisites) {
        var graph = new Graph(numCourses);
        for (var edge : prerequisites) graph.addEdge(edge[1], edge[0]);
        return !graph.hasCycle();
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

    boolean hasCycle() {
        var count = order();
        var fringe = roots();
        var indegs = _indegrees.clone();

        while (!fringe.isEmpty()) {
            var src = fringe.remove();
            --count;

            for (var dest : _adj.get(src))
                if (--indegs[dest] == 0) fringe.add(dest);
        }

        return count > 0;
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
