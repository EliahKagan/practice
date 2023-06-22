// LeetCode #429 - N-ary Tree Level Order Traversal
// https://leetcode.com/problems/n-ary-tree-level-order-traversal/

/*
// Definition for a Node.
class Node {
    public int val;
    public List<Node> children;

    public Node() {}

    public Node(int _val) {
        val = _val;
    }

    public Node(int _val, List<Node> _children) {
        val = _val;
        children = _children;
    }
};
*/

class Solution {
    public List<List<Integer>> levelOrder(Node root) {
        List<List<Integer>> rows = new ArrayList<>();
        if (root == null) return rows;

        Queue<Node> queue = new ArrayDeque<>();
        queue.add(root);

        while (!queue.isEmpty()) {
            List<Integer> row = new ArrayList<>();
            rows.add(row);

            for (var breadth = queue.size(); breadth > 0; --breadth) {
                var node = queue.remove();
                row.add(node.val);
                queue.addAll(node.children);
            }
        }

        return rows;
    }
}
