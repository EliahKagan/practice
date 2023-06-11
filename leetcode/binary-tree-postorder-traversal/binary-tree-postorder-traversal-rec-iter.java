// LeetCode #145 - Binary Tree Postorder Traversal
// https://leetcode.com/problems/binary-tree-postorder-traversal/
// Iterative implementation of recursive algorithm (state machine).

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

    private static enum State {
        GO_LEFT,
        GO_RIGHT,
        RETREAT
    }

    private static final class Frame {
        Frame(TreeNode node) {
            this.node = node;
            this.state = State.GO_LEFT;
        }

        final TreeNode node;
        State state;
    }

    private static void postorder(TreeNode root, IntConsumer action) {
        if (root == null) return;

        var stack = Collections.asLifoQueue(new ArrayDeque<Frame>());
        stack.add(new Frame(root));

        while (!stack.isEmpty()) {
            var frame = stack.element();

            switch (frame.state) {
            case GO_LEFT:
                frame.state = State.GO_RIGHT;
                if (frame.node.left != null)
                    stack.add(new Frame(frame.node.left));
                break;

            case GO_RIGHT:
                frame.state = State.RETREAT;
                if (frame.node.right != null)
                    stack.add(new Frame(frame.node.right));
                break;

            case RETREAT:
                action.accept(frame.node.val);
                stack.remove();
                break;
            }
        }
    }
}
