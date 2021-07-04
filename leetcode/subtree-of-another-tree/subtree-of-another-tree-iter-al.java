// LeetCode #572 - Subtree of Another Tree
// https://leetcode.com/problems/subtree-of-another-tree/
// By hashing, linear O(M + N) runtime, implemented iteratively. The state
// machine uses "arm's length" recursion (which is rarely appropriate in actual
// recursive code, but which sometimes simplifies or improves the performance
// of state machines simulating recursion).

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
        Map<Key, Integer> table = new HashMap<>();
        traverse(root, table, true);
        return traverse(subRoot, table, false);
    }

    private static boolean traverse(TreeNode root,
                                    Map<Key, Integer> table,
                                    boolean addIfAbsent) {
        var lastId = -1; // "return" cell
        var stack = Collections.asLifoQueue(new ArrayDeque<Frame>());
        if (root != null) stack.add(new Frame(root));

        while (!stack.isEmpty()) {
            var frame = stack.element();

            switch (frame.state) {
            case GO_LEFT:
                frame.state = State.GO_RIGHT;

                if (frame.node.left == null)
                    lastId = 0;
                else
                    stack.add(new Frame(frame.node.left));

                break;

            case GO_RIGHT:
                frame.leftId = lastId;
                frame.state = State.RETREAT;

                if (frame.node.right == null)
                    lastId = 0;
                else
                    stack.add(new Frame(frame.node.right));

                break;

            case RETREAT:
                var key = new Key(frame.node.val, frame.leftId, lastId);

                if (addIfAbsent) {
                    lastId = table.computeIfAbsent(key, k -> table.size() + 1);
                } else {
                    var id = table.get(key);
                    if (id == null) return false;
                    lastId = id;
                }

                stack.remove();
            }
        }

        return true;
    }
}

final class Key {
    Key(int val, int leftId, int rightId) {
        _val = val;
        _leftId = leftId;
        _rightId = rightId;
    }

    @Override
    public boolean equals(Object other) {
        if (!(other instanceof Key)) return false;

        var rhs = (Key)other;

        return _val == rhs._val
                && _leftId == rhs._leftId
                && _rightId == rhs._rightId;
    }

    @Override
    public int hashCode() {
        final var bias = 1907;
        final var multiplier = 131071;

        var ret = bias;
        ret = ret * multiplier + _val;
        ret = ret * multiplier + _leftId;
        ret = ret * multiplier + _rightId;
        return ret;
    }

    private final int _val;

    private final int _leftId;

    private final int _rightId;
}

enum State { GO_LEFT, GO_RIGHT, RETREAT }

final class Frame {
    Frame(TreeNode _node) {
        node = _node;
        state = State.GO_LEFT;
    }

    final TreeNode node;

    int leftId = -1;

    State state;
}
