// LeetCode #1361 - Validate Binary Tree Nodes
// https://leetcode.com/problems/validate-binary-tree-nodes/
// By checking for a unique root and doing BFS.

class Solution {
    public boolean
    validateBinaryTreeNodes(int n, int[] leftChild, int[] rightChild) {
        var roots = findRoots(n, leftChild, rightChild);
        if (roots.length != 1) return false;

        Set<Integer> vis = new HashSet<>();
        Queue<Integer> fringe = new ArrayDeque<>();
        fringe.add(roots[0]);

        while (!fringe.isEmpty()) {
            var parent = fringe.remove();
            if (parent == -1) continue;
            if (vis.contains(parent)) return false;
            vis.add(parent);
            fringe.add(leftChild[parent]);
            fringe.add(rightChild[parent]);
        }

        return vis.size() == n;
    }

    private static int[] findRoots(int n, int[] leftChild, int[] rightChild) {
        var indegrees = computeIndegrees(n, leftChild, rightChild);

        return IntStream.range(0, n)
            .filter(node -> indegrees[node] == 0)
            .toArray();
    }

    private static int[]
    computeIndegrees(int n, int[] leftChild, int[] rightChild) {
        var indegrees = new int[n];

        IntStream.concat(IntStream.of(leftChild), IntStream.of(rightChild))
            .filter(child -> child != -1)
            .forEach(child -> ++indegrees[child]);

        return indegrees;
    }
}
