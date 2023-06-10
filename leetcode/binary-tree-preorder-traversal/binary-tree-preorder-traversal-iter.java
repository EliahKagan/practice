// LeetCode #114 - Binary Tree Preorder Traversal
// https://leetcode.com/problems/binary-tree-preorder-traversal/
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
    public List<Integer> preorderTraversal(TreeNode root) {
        List<Integer> values = new ArrayList<>();
        preorder(root, values::add);
        return values;
    }

    private static void preorder(TreeNode root, IntConsumer action) {
        if (root == null) return;

        var stack = Collections.asLifoQueue(new ArrayDeque<TreeNode>());
        stack.add(root);

        while (!stack.isEmpty()) {
            var node = stack.remove();
            action.accept(node.val);
            if (node.right != null) stack.add(node.right);
            if (node.left != null) stack.add(node.left);
        }
    }
}
