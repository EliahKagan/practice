// LeetCode #208 - Implement Trie (Prefix Tree)

class Trie {
public:
    Trie() noexcept
    {
        make_node(); // Create the root node.
    }

    void insert(string_view word) noexcept
    {
        auto node = root();

        for (const auto ch : word) {
            if (!ch) abort(); // Null characters not allowed in words.
            auto& child = (*node)[ch];
            if (!child) child = make_node();
            node = child;
        }

        (*node)['\0'] = nullptr;
    }

    [[nodiscard]] bool search(string_view word) const noexcept
    {
        const auto node = traverse(word);
        return node && node->count('\0');
    }

    [[nodiscard]] bool startsWith(string_view prefix) const noexcept
    {
        return traverse(prefix);
    }

private:
    class Node : public unordered_map<char, Node*> { };

    Node* make_node() noexcept
    {
        return &nodes_.emplace_back();
    }

    [[nodiscard]] const Node* root() const noexcept
    {
        return &nodes_.front();
    }

    [[nodiscard]] Node* root() noexcept
    {
        return &nodes_.front();
    }

    [[nodiscard]] const Node* traverse(string_view prefix) const noexcept
    {
        auto node = root();

        for (const auto ch : prefix) {
            if (!ch) abort(); // Null characters not allowed in words.
            const auto it = node->find(ch);
            if (it == end(*node)) return nullptr;
            node = it->second;
        }

        return node;
    }

    deque<Node> nodes_;
};

/**
 * Your Trie object will be instantiated and called as such:
 * Trie* obj = new Trie();
 * obj->insert(word);
 * bool param_2 = obj->search(word);
 * bool param_3 = obj->startsWith(prefix);
 */
