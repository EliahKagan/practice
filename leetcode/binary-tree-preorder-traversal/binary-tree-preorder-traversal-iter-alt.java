// LeetCode #114 - Binary Tree Preorder Traversal
// https://leetcode.com/problems/binary-tree-preorder-traversal/
// Alternative iterative implementation.

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
    public List<Integer> preorderTraversal(TreeNode root) {
        List<Integer> values = new ArrayList<>();
        preorder(root, values::add);
        return values;
    }

    private static void preorder(TreeNode root, IntConsumer action) {
        var stack = Collections.asLifoQueue(new ArrayDeque<TreeNode>());

        while (root != null || !stack.isEmpty()) {
            // Go left as far as possible, doing the preorder action.
            for (; root != null; root = root.left) {
                action.accept(root.val);
                stack.add(root);
            }

            // If we can go right, do that next.
            root = stack.remove().right;
        }
    }
}
