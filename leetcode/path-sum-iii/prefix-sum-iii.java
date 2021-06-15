// LeetCode #437 - Path Sum III
// https://leetcode.com/problems/path-sum-iii/
// Prefix-sum hashing solution. Runs in linear time.

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
    public int pathSum(TreeNode root, int targetSum) {
        var history = new Counter<Integer>();
        history.increment(0);

        class Dfs {
            int apply(TreeNode node, int acc) {
                if (node == null) return 0;

                acc += node.val;
                var count = history.count(acc - targetSum);

                history.increment(acc);
                count += apply(node.left, acc);
                count += apply(node.right, acc);
                history.decrement(acc);

                return count;
            }
        }

        return new Dfs().apply(root, 0);
    }
}

final class Counter<E> {
    int count(E element) {
        return _counts.getOrDefault(element, 0);
    }

    void increment(E element) {
        _counts.compute(element, (e, c) -> c == null ? 1 : c + 1);
    }

    void decrement(E element) {
        _counts.compute(element, (e, c) -> c == 1 ? null : c - 1);
    }

    final Map<E, Integer> _counts = new HashMap<>();
}
