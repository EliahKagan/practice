// LeetCode #94 - Binary Tree Inorder Traversal
// https://leetcode.com/problems/binary-tree-inorder-traversal/
// Implementation from general iterative DFS.

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
        dfs(root, Solution::noop, values::add, Solution::noop);
        return values;
    }

    private static void noop(int _value) {
        // Do nothing.
    }

    private static void dfs(TreeNode root,
                            IntConsumer preorderAction,
                            IntConsumer inorderAction,
                            IntConsumer postorderAction) {
        var stack = Collections.asLifoQueue(new ArrayDeque<TreeNode>());
        TreeNode last = null;

        while (root != null || !stack.isEmpty()) {
            // Go left as far as possible, doing the preorder action.
            for (; root != null; root = root.left) {
                preorderAction.accept(root.val);
                stack.add(root);
            }

            var cur = stack.element();

            if (cur.right == null || cur.right != last) {
                // We have not gone right. Do the inorder action.
                inorderAction.accept(cur.val);
            }

            if (cur.right != null && cur.right != last) {
                // We can go right but we haven't. Do that next.
                root = cur.right;
            } else {
                // Do the postorder action and retreat.
                postorderAction.accept(cur.val);
                last = cur;
                stack.remove();
            }
        }
    }
}
