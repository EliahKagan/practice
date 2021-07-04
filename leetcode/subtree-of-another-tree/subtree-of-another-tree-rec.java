// LeetCode #572 - Subtree of Another Tree
// https://leetcode.com/problems/subtree-of-another-tree/
// By hashing, linear O(M + N) runtime, implemented recursively.

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
        add(table, root);
        return search(table, subRoot) != null;
    }

    private static int add(Map<Key, Integer> table, TreeNode node) {
        if (node == null) return 0;

        return table.computeIfAbsent(new Key(node.val,
                                             add(table, node.left),
                                             add(table, node.right)),
                                     k -> table.size() + 1);
    }

    private static Integer search(Map<Key, Integer> table, TreeNode node) {
        if (node == null) return 0;

        var leftId = search(table, node.left);
        if (leftId == null) return null;

        var rightId = search(table, node.right);
        if (rightId == null) return null;

        return table.get(new Key(node.val, leftId, rightId));
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
