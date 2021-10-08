// LeetCode #208 - Implement Trie (Prefix Tree)
// https://leetcode.com/problems/implement-trie-prefix-tree

public class Trie {
    public void Insert(string word)
    {
        var node = _root;

        foreach (var ch in word) {
            if (node.TryGetValue(ch, out var child)) {
                node = child;
            } else {
                child = new Node();
                node.Add(ch, child);
                node = child;
            }
        }

        node.IsWord = true;
    }

    public bool Search(string word)
        => Traverse(word) is Node node && node.IsWord;

    public bool StartsWith(string prefix)
        => Traverse(prefix) is Node;

    private sealed class Node : Dictionary<char, Node> {
        internal bool IsWord { get; set; } = false;
    }

    private Node Traverse(string prefix)
    {
        var node = _root;

        foreach (var ch in prefix) {
            if (!node.TryGetValue(ch, out node)) return null;
        }

        return node;
    }

    private readonly Node _root = new Node();
}

/**
 * Your Trie object will be instantiated and called as such:
 * Trie obj = new Trie();
 * obj.Insert(word);
 * bool param_2 = obj.Search(word);
 * bool param_3 = obj.StartsWith(prefix);
 */
