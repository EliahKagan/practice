// LeetCode #208 - Implement Trie (Prefix Tree)
// https://leetcode.com/problems/implement-trie-prefix-tree

class Trie {
    public void insert(String word) {
        var node = _root;

        for (var i = 0; i < word.length(); ++i)
            node = node.computeIfAbsent(word.charAt(i), k -> new Node());

        node.isWord = true;
    }

    public boolean search(String word) {
        var node = traverse(word);
        return node != null && node.isWord;
    }

    public boolean startsWith(String prefix) {
        return traverse(prefix) != null;
    }

    private static class Node extends HashMap<Character, Node> {
        boolean isWord = false;
    }

    private Node traverse(String prefix) {
        var node = _root;

        for (var i = 0; i < prefix.length(); ++i) {
            node = node.get(prefix.charAt(i));
            if (node == null) return null;
        }

        return node;
    }

    private final Node _root = new Node();
}

/**
 * Your Trie object will be instantiated and called as such:
 * Trie obj = new Trie();
 * obj.insert(word);
 * boolean param_2 = obj.search(word);
 * boolean param_3 = obj.startsWith(prefix);
 */
