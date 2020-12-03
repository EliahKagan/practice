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

        IntPredicate hasCycleFrom = start -> {
            if (vis[start] == Color.BLACK) return false;
            if (vis[start] != Color.WHITE)
                throw new AssertionError("corrupted visitation state");

            Deque<Frame> stack = new ArrayDeque<>();
            vis[start] = Color.GRAY;
            stack.push(new Frame(start, _adj));

            while (!stack.isEmpty()) {
                var frame = stack.peek();

                if (!frame.iter.hasNext()) {
                    vis[frame.src] = Color.BLACK;
                    stack.pop();
                    continue;
                }

                int dest = frame.iter.next();

                switch (vis[dest]) {
                case WHITE:
                    vis[dest] = Color.GRAY;
                    stack.push(new Frame(dest, _adj));
                    break;
                case GRAY:
                    return true;
                case BLACK:
                    break;
                default:
                    throw new AssertionError("unrecognized visitation state");
                }
            }

            return false;
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

final class Frame {
    Frame(int src, List<List<Integer>> adj) {
        this.src = src;
        this.iter = adj.get(src).iterator();
    }

    final int src;

    final Iterator<Integer> iter;
}

enum Color {
    WHITE,
    GRAY,
    BLACK,
}
