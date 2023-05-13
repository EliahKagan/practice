// LeetCode #1361 - Validate Binary Tree Nodes
// https://leetcode.com/problems/validate-binary-tree-nodes/

class Solution {
    public boolean
    validateBinaryTreeNodes(int n, int[] leftChild, int[] rightChild) {
        var roots = findRoots(n, leftChild, rightChild);
        if (roots.length != 1) return false;

        Set<Integer> vis = new HashSet<>();

        var isTree = new IntPredicate() {
            @Override
            public boolean test(int root) {
                if (root == -1) return true; // Simplifies the algorithm.
                if (vis.contains(root)) return false;
                vis.add(root);
                return test(leftChild[root]) && test(rightChild[root]);
            }
        };

        return isTree.test(roots[0]) && vis.size() == n;
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
