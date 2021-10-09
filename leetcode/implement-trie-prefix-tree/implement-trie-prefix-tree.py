# LeetCode #208 - Implement Trie (Prefix Tree)
# https://leetcode.com/problems/implement-trie-prefix-tree/


class Trie:
    __slots__ = '_root'

    _WORD_MARK = None  # Can be anything hashable except a character.

    def __init__(self):
        self._root = {}

    def insert(self, word: str) -> None:
        node = self._root

        for ch in word:
            try:
                node = node[ch]
            except KeyError:
                child = {}
                node[ch] = child
                node = child

        node[Trie._WORD_MARK] = None

    def search(self, word: str) -> bool:
        node = self._traverse(word)
        return node is not None and Trie._WORD_MARK in node

    def startsWith(self, prefix: str) -> bool:
        return self._traverse(prefix) is not None

    def _traverse(self, prefix):
        node = self._root

        for ch in prefix:
            try:
                node = node[ch]
            except KeyError:
                return None

        return node


# Your Trie object will be instantiated and called as such:
# obj = Trie()
# obj.insert(word)
# param_2 = obj.search(word)
# param_3 = obj.startsWith(prefix)
