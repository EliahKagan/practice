// LeetCode #114 - Binary Tree Preorder Traversal
// https://leetcode.com/problems/binary-tree-preorder-traversal/
// Iterative implementation of right-side tail recursive algorithm
// (state machine, 2 states instead of 3).

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

    private static void noop(int _value) {
        // Do nothing.
    }

    private static enum State {
        GO_LEFT,
        GO_RIGHT
    }

    private static final class Frame {
        Frame(TreeNode node) {
            this.node = node;
            this.state = State.GO_LEFT;
        }

        final TreeNode node;
        State state;
    }

    private static void preorder(TreeNode root, IntConsumer action) {
        if (root == null) return;

        var stack = Collections.asLifoQueue(new ArrayDeque<Frame>());
        stack.add(new Frame(root));

        while (!stack.isEmpty()) {
            var frame = stack.element();

            switch (frame.state) {
            case GO_LEFT:
                action.accept(frame.node.val);
                frame.state = State.GO_RIGHT;
                if (frame.node.left != null)
                    stack.add(new Frame(frame.node.left));
                break;

            case GO_RIGHT:
                stack.remove();
                if (frame.node.right != null)
                    stack.add(new Frame(frame.node.right));
                break;
            }
        }
    }
}
