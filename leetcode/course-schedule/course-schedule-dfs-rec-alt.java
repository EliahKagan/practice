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
    }

    void addEdge(int src, int dest) {
        _adj.get(src).add(dest);
    }

    boolean hasCycle() {
        var vis = freshVisitationList();

        var hasCycleFrom = new IntPredicate() {
            @Override
            public boolean test(int src) {
                switch (vis[src]) {
                case WHITE:
                    vis[src] = Color.GRAY;
                    if (_adj.get(src).stream().anyMatch(this::test))
                        return true;
                    vis[src] = Color.BLACK;
                    return false;

                case GRAY:
                    return true;

                case BLACK:
                    return false;

                default:
                    throw new AssertionError("unrecognized visitation state");
                }
            }
        };

        return vertices().anyMatch(hasCycleFrom);
    }

    private Color[] freshVisitationList() {
        return vertices().mapToObj(_vertex -> Color.WHITE)
                         .toArray(Color[]::new);
    }

    private IntStream vertices() {
        return IntStream.range(0, _adj.size());
    }

    private final List<List<Integer>> _adj;
}

enum Color {
    WHITE,
    GRAY,
    BLACK,
}
