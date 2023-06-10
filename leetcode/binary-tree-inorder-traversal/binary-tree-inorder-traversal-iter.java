// LeetCode #94 - Binary Tree Inorder Traversal
// https://leetcode.com/problems/binary-tree-inorder-traversal/
// Iterative implementation.

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
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> values = new ArrayList<>();
        inorder(root, values::add);
        return values;
    }

    private static void inorder(TreeNode root, IntConsumer action) {
        var stack = Collections.asLifoQueue(new ArrayDeque<TreeNode>());

        while (root != null || !stack.isEmpty()) {
            // Go left as far as possible.
            for (; root != null; root = root.left) stack.add(root);

            // Do the inorder action.
            var cur = stack.remove();
            action.accept(cur.val);

            // If we can go right, do that next.
            root = cur.right;
        }
    }
}
