import java.util.Optional;

class Solution {
    public int[] findOrder(int numCourses, int[][] prerequisites) {
        var graph = new Graph(numCourses);
        for (var edge : prerequisites) graph.addEdge(edge[0], edge[1]);

        return graph.reverseToposort()
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
    }

    void addEdge(int src, int dest) {
        _adj.get(src).add(dest);
    }

    Optional<List<Integer>> reverseToposort() {
        List<Integer> out = new ArrayList<>(order());
        var vis = freshVisitationList();

        // Returns true on success, false on failure due to cycle.
        var dfs = new IntPredicate() {
            @Override
            public boolean test(int src) {
                switch (vis[src]) {
                case WHITE:
                    vis[src] = Color.GRAY;
                    if (!_adj.get(src).stream().allMatch(this::test))
                        return false;
                    vis[src] = Color.BLACK;
                    out.add(src);
                    return true;

                case GRAY:
                    return false;

                case BLACK:
                    return true;

                default:
                    throw new AssertionError("unrecognized visitation state");
                }
            }
        };

        return vertices().allMatch(dfs) ? Optional.of(out) : Optional.empty();
    }

    private int order() {
        return _adj.size();
    }

    private IntStream vertices() {
        return IntStream.range(0, order());
    }

    private Color[] freshVisitationList() {
        return Stream.generate(() -> Color.WHITE)
                     .limit(order())
                     .toArray(Color[]::new);
    }

    private final List<List<Integer>> _adj;
}

enum Color {
    WHITE,
    GRAY,
    BLACK,
}
