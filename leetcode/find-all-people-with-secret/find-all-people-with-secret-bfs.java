// LeetCode #2092 - Find All People With Secret
// https://leetcode.com/problems/find-all-people-with-secret/
// By grouping by time, sorting, and BFS for each group.
// This fails on some larger test cases due to Memory Limit Exceeded.

class Solution {
    public List<Integer>
    findAllPeople(int n, int[][] meetings, int firstPerson) {
        var vis = new boolean[n];
        vis[0] = vis[firstPerson] = true;
        Arrays.sort(meetings, Comparator.comparing(meeting -> meeting[2]));
        bfsEachChunk(vis, meetings);
        return getTrueIndices(vis);
    }

    private static void bfsEachChunk(boolean[] vis, int[][] meetings) {
        var left = 0;
        var right = 0;
        while (left < meetings.length) {
            var time = meetings[left][2];
            while (++right < meetings.length && meetings[right][2] == time) { }
            bfs(vis, meetings, left, right);
            left = right;
        }
    }

    private static void
    bfs(boolean[] vis, int[][] meetings, int fromIndex, int toIndex) {
        // Build the graph.
        Map<Integer, List<Integer>> adj = new HashMap<>();
        for (var index = fromIndex; index < toIndex; ++index) {
            var x = meetings[index][0];
            var y = meetings[index][1];
            adj.computeIfAbsent(x, ArrayList::new).add(y);
            adj.computeIfAbsent(y, ArrayList::new).add(x);
        }

        // Find roots for the BFS traversal.
        Queue<Integer> fringe = new ArrayDeque<>();
        for (var vertex : adj.keySet())
            if (vis[vertex]) fringe.add(vertex);

        // Do the BFS traversal, marking reachable vertices.
        while (!fringe.isEmpty()) {
            var src = fringe.remove();
            for (var dest : adj.get(src)) {
                if (vis[dest]) continue;
                vis[dest] = true;
                fringe.add(dest);
            }
        }
    }

    private static List<Integer> getTrueIndices(boolean[] bits) {
        List<Integer> trueIndices = new ArrayList<>();
        for (var index = 0; index < bits.length; ++index)
            if (bits[index]) trueIndices.add(index);
        return trueIndices;
    }
}
