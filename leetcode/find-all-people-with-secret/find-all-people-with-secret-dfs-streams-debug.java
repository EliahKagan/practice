// LeetCode #2092 - Find All People With Secret
// https://leetcode.com/problems/find-all-people-with-secret/
// By grouping by time, sorting, and recursive DFS for each group.
// This fails on some larger test cases due to Memory Limit Exceeded.

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Consumer;
import java.util.stream.Collectors;
import java.util.stream.Stream;

class Solution {
    public List<Integer>
    findAllPeople(int n, int[][] meetings, int firstPerson) {
        var head = Stream.of(new Meeting(new Edge(ORIGIN, firstPerson), 0));
        var tail = Stream.of(meetings).map(Meeting::fromArray);
        return solve(Stream.concat(head, tail)).stream().toList();
    }

    /** "Patient zero" for knowing the secret. */
    private static final Integer ORIGIN = 0;

    private static Set<Integer> solve(Stream<Meeting> meetings) {
        Set<Integer> component = new HashSet<>();
        component.add(ORIGIN);

        var grouper = Collectors.groupingBy(
            Meeting::time,
            Collectors.mapping(Meeting::edge, Collectors.toList()));

        meetings.collect(grouper)
            .entrySet()
            .stream()
            .sorted(Map.Entry.comparingByKey()) // Sort by time.
            .map(Map.Entry::getValue)
            .forEachOrdered(edges -> growComponent(component, edges));

        return component;
    }

    private static void
    growComponent(Set<Integer> component, List<Edge> edges) {
        var graph = buildGraph(edges);
        var roots = graph.vertices().stream().filter(component::contains);
        component.addAll(graph.findReachable(roots));
    }

    private static Graph buildGraph(List<Edge> edges) {
        var graph = new Graph();
        edges.forEach(graph::addEdge);
        return graph;
    }
}

/** An unweighted undirected edge. */
record Edge(Integer x, Integer y) { }

/** An edge whose endpoints represent people, and the time they meet. */
record Meeting(Edge edge, int time) {
    static Meeting fromArray(int[] row) {
        return new Meeting(new Edge(row[0], row[1]), row[2]);
    }
}

/** An unweighted undirected graph. */
final class Graph { // TODO: Make this generic to better express the algorithm.
    Set<Integer> vertices() {
        return _vertices;
    }

    void addEdge(Edge edge) {
        _adj.computeIfAbsent(edge.x(), ArrayList::new).add(edge.y());
        _adj.computeIfAbsent(edge.y(), ArrayList::new).add(edge.x());
    }

    Set<Integer> findReachable(Stream<Integer> roots) {
        Set<Integer> vis = new HashSet<>();

        var dfs = new Consumer<Integer>() {
            @Override
            public void accept(Integer src) {
                if (vis.contains(src)) return;
                vis.add(src);
                _adj.get(src).forEach(this);
            }
        };

        roots.forEach(dfs);
        return vis;
    }

    private final Map<Integer, List<Integer>> _adj = new HashMap<>();

    private final Set<Integer> _vertices =
        Collections.unmodifiableSet(_adj.keySet());
}
