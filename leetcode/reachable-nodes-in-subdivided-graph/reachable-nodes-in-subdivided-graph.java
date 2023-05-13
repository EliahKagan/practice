// LeetCode #882 - Reachable Nodes In Subdivided Graph
// https://leetcode.com/problems/reachable-nodes-in-subdivided-graph/
// By Dijkstra's algorithm, adding "sub-reach" into edges from their endpoints.

class Solution {
    public int reachableNodes(int[][] edges, int maxMoves, int n) {
        return (int)solve(parseEdges(edges), maxMoves, n);
    }

    private static final int START = 0;

    private static DivEdge[] parseEdges(int[][] rawEdges) {
        return Stream.of(rawEdges)
            .map(edge -> new DivEdge(edge[0], edge[1], edge[2]))
            .toArray(DivEdge[]::new);
    }

    private static long solve(DivEdge[] edges, int maxCost, int vertexCount) {
        var pathTree = buildGraph(edges, vertexCount).dijkstra(START, maxCost);
        long reach = Stream.of(pathTree).filter(Objects::nonNull).count();

        for (var edge : edges) {
            var subReach = IntStream.of(edge.u(), edge.v())
                .mapToObj(endpoint -> pathTree[endpoint])
                .filter(Objects::nonNull)
                .mapToInt(pair -> maxCost - pair.cost())
                .sum();

            reach += Math.min(subReach, edge.count());
        }

        return reach;
    }

    private static Graph buildGraph(DivEdge[] edges, int vertexCount) {
        var graph = new Graph(vertexCount);

        for (var edge : edges)
            graph.addEdge(edge.u(), edge.v(), edge.count() + 1);

        return graph;
    }
}

/** An edge that may (conceptually) be subdivided into multiple edges. */
record DivEdge(int u, int v, int count) { }

/** An edge's destination weight and destination vertex. */
record OutEdge(int dest, int weight) { }

/** A vertex and the best cost, so far, of reaching it. */
record VertexCostPair(int vertex, int cost) { }

/** The parent (predecessor) and cost to reach a vertex by a shortest path. */
record ParentCostPair(int parent, int cost) { }

/** A weighted undirected graph. Edge weights are assumed nonnegative. */
final class Graph {
    Graph(int vertexCount) {
        _vertexCount = vertexCount;

        _adj = new ArrayList<>(vertexCount);
        for (var src = 0; src < vertexCount; ++src)
            _adj.add(new ArrayList<>());
    }

    void addEdge(int u, int v, int weight) {
        _adj.get(u).add(new OutEdge(v, weight));
        _adj.get(v).add(new OutEdge(u, weight));
    }

    // TODO: The problem being solved doesn't need parents, just costs.
    //       Simplify this by not tracking parents. Remove ParentCostPair.
    ParentCostPair[] dijkstra(int start, int maxCost) {
        var finished = new boolean[_vertexCount];
        var parents = makeArrayOfUndefined(_vertexCount);
        var costs = makeArrayOfUndefined(_vertexCount);
        var heap = makeHeap();

        costs[start] = 0;
        heap.add(new VertexCostPair(start, 0));

        while (!heap.isEmpty()) {
            var src = heap.remove();
            if (finished[src.vertex()]) continue;

            finished[src.vertex()] = true;
            if (costs[src.vertex()] != src.cost())
                throw new AssertionError("Bug: cost mismatch");

            for (var edge : _adj.get(src.vertex())) {
                if (finished[edge.dest()]) continue;

                var newCost = src.cost() + edge.weight();
                if (newCost > maxCost) continue;

                var oldCost = costs[edge.dest()];
                if (oldCost != UNDEFINED && oldCost <= newCost) continue;

                parents[edge.dest()] = src.vertex();
                costs[edge.dest()] = newCost;
                heap.add(new VertexCostPair(edge.dest(), newCost));
            }
        }

        return zipPathTree(parents, costs);
    }

    private static int UNDEFINED = -1;

    private static int[] makeArrayOfUndefined(int length) {
        var undefineds = new int[length];
        Arrays.fill(undefineds, UNDEFINED);
        return undefineds;
    }

    private static Queue<VertexCostPair> makeHeap() {
        return new PriorityQueue<>(Comparator.comparing(VertexCostPair::cost));
    }

    private ParentCostPair[] zipPathTree(int[] parents, int[] costs) {
        var pathTree = new ParentCostPair[_vertexCount];

        for (var vertex = 0; vertex < _vertexCount; ++vertex) {
            if (costs[vertex] != UNDEFINED) {
                pathTree[vertex] =
                    new ParentCostPair(parents[vertex], costs[vertex]);
            }
        }

        return pathTree;
    }

    private final int _vertexCount;

    private final List<List<OutEdge>> _adj;
}
