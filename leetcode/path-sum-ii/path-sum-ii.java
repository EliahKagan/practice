// LeetCode #113 - Path Sum II
// https://leetcode.com/problems/path-sum-ii/

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
    public List<List<Integer>> pathSum(TreeNode root, int targetSum) {
        List<List<Integer>> allPaths = new ArrayList<>();
        List<Integer> path = new ArrayList<>();

        var dfs = new ObjIntConsumer<TreeNode>() {
            @Override
            public void accept(TreeNode node, int target) {
                if (node == null) return;

                var subtarget = target - node.val;
                path.add(node.val);

                if (node.left != null || node.right != null) {
                    accept(node.left, subtarget);
                    accept(node.right, subtarget);
                } else if (subtarget == 0) {
                    allPaths.add(new ArrayList<>(path));
                }

                path.remove(path.size() - 1);
            }
        };

        dfs.accept(root, targetSum);
        return allPaths;
    }
}
