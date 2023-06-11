// LeetCode #145 - Binary Tree Postorder Traversal
// https://leetcode.com/problems/binary-tree-postorder-traversal/
// By reversing the result of iterative right-to-left preorder traversal.

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
        rightToLeftPreorder(root, values::add);
        Collections.reverse(values);
        return values;
    }

    private static void
    rightToLeftPreorder(TreeNode root, IntConsumer action) {
        if (root == null) return;

        var stack = Collections.asLifoQueue(new ArrayDeque<TreeNode>());
        stack.add(root);

        while (!stack.isEmpty()) {
            var node = stack.remove();
            action.accept(node.val);
            if (node.left != null) stack.add(node.left);
            if (node.right != null) stack.add(node.right);
        }
    }
}
