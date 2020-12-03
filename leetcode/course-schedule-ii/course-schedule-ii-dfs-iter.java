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
        IntPredicate dfs = start -> {
            if (vis[start] == Color.BLACK) return true;
            if (vis[start] != Color.WHITE)
                throw new AssertionError("corrupted visitation state");

            Deque<Frame> stack = new ArrayDeque<>();
            vis[start] = Color.GRAY;
            stack.push(new Frame(start, _adj));

            while (!stack.isEmpty()) {
                var frame = stack.peek();

                if (!frame.iter.hasNext()) {
                    vis[frame.src] = Color.BLACK;
                    out.add(frame.src);
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
                    return false;
                case BLACK:
                    break;
                default:
                    throw new AssertionError("unrecognized visitation state");
                }
            }

            return true;
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
