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

        RecursiveIntPredicate hasCycleFrom = (me, src) -> {
            switch (vis[src]) {
            case WHITE:
                vis[src] = Color.GRAY;
                if (_adj.get(src).stream().anyMatch(dest -> me.test(me, dest)))
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
        };

        return vertices()
                .anyMatch(start -> hasCycleFrom.test(hasCycleFrom, start));
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

@FunctionalInterface
interface RecursiveIntPredicate {
    boolean test(RecursiveIntPredicate me, int value);
}
