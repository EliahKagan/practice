// LeetCode #572 - Subtree of Another Tree
// https://leetcode.com/problems/subtree-of-another-tree/
// Naive solution, quadratic O(MN) runtime, implemented iteratively.

/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode() {}
 *     TreeNode(int val) { this.val = val; }
 *     TreeNode(int val, TreeNode left, TreeNode right) {
 *         this.val = val;
 *         this.left = left;
 *         this.right = right;
 *     }
 * }
 */
class Solution {
    public boolean isSubtree(TreeNode root, TreeNode subRoot) {
        if (subRoot == null) return true;

        var stack = Collections.asLifoQueue(new ArrayDeque<TreeNode>());
        if (root != null) stack.add(root);

        while (!stack.isEmpty()) {
            root = stack.remove();
            if (equalTrees(root, subRoot)) return true;

            if (root.left != null) stack.add(root.left);
            if (root.right != null) stack.add(root.right);
        }

        return false;
    }

    private static boolean equalTrees(TreeNode root1, TreeNode root2) {
        var stack = Collections.asLifoQueue(
                        new ArrayDeque<Duo<TreeNode, TreeNode>>());

        for (stack.add(new Duo<>(root1, root2)); !stack.isEmpty(); ) {
            var duo = stack.remove();
            if (duo.first == null && duo.second == null) continue;

            if (duo.first == null || duo.second == null
                    || duo.first.val != duo.second.val)
                return false;

            stack.add(new Duo<>(duo.first.left, duo.second.left));
            stack.add(new Duo<>(duo.first.right, duo.second.right));
        }

        return true;
    }
}

final class Duo<E1, E2> {
    Duo(E1 _first, E2 _second) {
        first = _first;
        second = _second;
    }

    final E1 first;

    final E2 second;
}
