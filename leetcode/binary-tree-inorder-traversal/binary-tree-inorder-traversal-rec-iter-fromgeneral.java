// LeetCode #94 - Binary Tree Inorder Traversal
// https://leetcode.com/problems/binary-tree-inorder-traversal/
// From general iteratively implemented recursive DFS (state machine).

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

    private static void dfs(TreeNode root,
                            IntConsumer preorderAction,
                            IntConsumer inorderAction,
                            IntConsumer postorderAction) {
        if (root == null) return;

        var stack = Collections.asLifoQueue(new ArrayDeque<Frame>());
        stack.add(new Frame(root));

        while (!stack.isEmpty()) {
            var frame = stack.element();

            switch (frame.state) {
            case GO_LEFT:
                preorderAction.accept(frame.node.val);
                frame.state = State.GO_RIGHT;
                if (frame.node.left != null)
                    stack.add(new Frame(frame.node.left));
                break;

            case GO_RIGHT:
                inorderAction.accept(frame.node.val);
                frame.state = State.RETREAT;
                if (frame.node.right != null)
                    stack.add(new Frame(frame.node.right));
                break;

            case RETREAT:
                postorderAction.accept(frame.node.val);
                stack.remove();
                break;
            }
        }
    }
}
