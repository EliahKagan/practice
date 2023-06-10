// LeetCode #94 - Binary Tree Inorder Traversal
// https://leetcode.com/problems/binary-tree-inorder-traversal/
// Implementation from general recursive DFS.

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
        if (root == null) return;

        preorderAction.accept(root.val);
        dfs(root.left, preorderAction, inorderAction, postorderAction);
        inorderAction.accept(root.val);
        dfs(root.right, preorderAction, inorderAction, postorderAction);
        postorderAction.accept(root.val);
    }
}
