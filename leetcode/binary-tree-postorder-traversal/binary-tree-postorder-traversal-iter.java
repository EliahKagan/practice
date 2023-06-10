// LeetCode #145 - Binary Tree Postorder Traversal
// https://leetcode.com/problems/binary-tree-postorder-traversal/
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
    public List<Integer> postorderTraversal(TreeNode root) {
        List<Integer> values = new ArrayList<>();
        postorder(root, values::add);
        return values;
    }

    private static void postorder(TreeNode root, IntConsumer action) {
        var stack = Collections.asLifoQueue(new ArrayDeque<TreeNode>());
        TreeNode last = null;

        while (root != null || !stack.isEmpty()) {
            // Go left as far as possible.
            for (; root != null; root = root.left) stack.add(root);

            var cur = stack.element();

            if (cur.right != null && cur.right != last) {
                // We can go right but haven't, so do that next.
                root = cur.right;
            } else {
                // Do the postorder action and retreat.
                action.accept(cur.val);
                last = cur;
                stack.remove();
            }
        }
    }
}
