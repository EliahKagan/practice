// LeetCode #572 - Subtree of Another Tree
// https://leetcode.com/problems/subtree-of-another-tree/
// Naive solution, quadratic O(MN) runtime, implemented recursively.

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
        if (equalTrees(root, subRoot)) return true;

        if (root == null) return false;

        return isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot);
    }

    private static boolean equalTrees(TreeNode root1, TreeNode root2) {
        if (root1 == null && root2 == null) return true;

        return root1 != null && root2 != null && root1.val == root2.val
                && equalTrees(root1.left, root2.left)
                && equalTrees(root1.right, root2.right);
    }
}
