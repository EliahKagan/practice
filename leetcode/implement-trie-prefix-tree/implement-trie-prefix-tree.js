// LeetCode #208 - Implement Trie (Prefix Tree)
// https://leetcode.com/problems/implement-trie-prefix-tree/

const WORD_MARK = null; // Any non-character works for this.

const Trie = function () {
    this._root = new Map();
};

/**
 * @param {string} word
 * @return {void}
 */
Trie.prototype.insert = function (word) {
    let node = this._root;

    for (const ch of word) {
        let child = node.get(ch);

        if (child === undefined) {
            child = new Map();
            node.set(ch, child);
        }

        node = child;
    }

    node.set(WORD_MARK, null);
};

/**
 * @param {string} word
 * @return {boolean}
 */
Trie.prototype.search = function (word) {
    const node = this._traverse(word);
    return node !== undefined && node.has(WORD_MARK);
};

/**
 * @param {string} prefix
 * @return {boolean}
 */
Trie.prototype.startsWith = function (prefix) {
    return this._traverse(prefix) !== undefined;
};

Trie.prototype._traverse = function (prefix) {
    let node = this._root;

    for (const ch of prefix) {
        node = node.get(ch);
        if (node === undefined) break;
    }

    return node;
};

/**
 * Your Trie object will be instantiated and called as such:
 * var obj = new Trie()
 * obj.insert(word)
 * var param_2 = obj.search(word)
 * var param_3 = obj.startsWith(prefix)
 */
