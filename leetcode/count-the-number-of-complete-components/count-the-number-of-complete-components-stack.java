// LeetCode #2685 - Count the Number of Complete Components
// https://leetcode.com/problems/count-the-number-of-complete-components/
// By stack-based search to count each component's vertices and edges.

class Solution {
    public int countCompleteComponents(int n, int[][] edges) {
        return buildGraph(n, edges).countCompleteComponents();
    }

    private static Graph buildGraph(int vertexCount, int[][] edges) {
        var graph = new Graph(vertexCount);
        for (var edge : edges) graph.addEdge(edge[0], edge[1]);
        return graph;
    }
}

// An unweighted undirected graph with vertices 0, 1, ..., vertexCount - 1.
class Graph {
    Graph(int vertexCount) {
        _adj = Stream.generate(HashSet<Integer>::new)
            .limit(vertexCount)
            .collect(Collectors.toList());
    }

    void addEdge(int vertex1, int vertex2) {
        if (vertex1 == vertex2) {
            var message = "loops (self-edges) are not allowed";
            throw new IllegalArgumentException(message);
        }

        _adj.get(vertex1).add(vertex2);
        _adj.get(vertex2).add(vertex1);
    }

    int countCompleteComponents() {
        Set<Integer> vis = new HashSet<>();
        var count = 0;

        for (var start = 0; start < _adj.size(); ++start) {
            if (!vis.contains(start) && componentIsComplete(vis, start))
                ++count;
        }

        return count;
    }

    private boolean componentIsComplete(Set<Integer> vis, int start) {
        if (vis.contains(start))
            throw new IllegalArgumentException("start vertex already visited");

        var vertices = 0;
        var halfEdges = 0;
        var fringe = Collections.asLifoQueue(new ArrayDeque<Integer>());

        vis.add(start);
        fringe.add(start);

        while (!fringe.isEmpty()) {
            var row = _adj.get(fringe.remove());

            ++vertices;
            halfEdges += row.size();

            for (var dest : row) {
                if (vis.contains(dest)) continue;
                vis.add(dest);
                fringe.add(dest);
            }
        }

        return vertices * (vertices - 1) == halfEdges;
    }

    final List<Set<Integer>> _adj;
}
