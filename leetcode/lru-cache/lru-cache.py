# https://leetcode.com/problems/lru-cache


class _Node:
    """A helper doubly linked list node for LRUCache."""

    __slots__ = ('_prev', '_next', 'key', 'value')

    def __init__(self, key = None, value = None, prev : '_Node' = None):
        """Creates a new sentinel or non-sentinel node."""
        if prev is None:
            self._prev = self._next = self # sentinel node
        else:
            self._attach(prev) # non-sentinel node

        self.key = key
        self.value = value

    @property
    def prev(self):
        """The node before this one."""
        return self._prev

    @property
    def next(self):
        """The node after this one."""
        return self._next

    def connect_after(self, prev : '_Node'):
        """Places this node after prev. Updates prior neighbors."""
        self._prev._next = self._next
        self._next._prev = self._prev
        self._attach(prev)

    def _attach(self, prev : '_Node'):
        """Places this node after prev. Does not update prior neighbors."""
        self._prev = prev
        self._next = prev._next
        self._prev._next = self._next._prev = self


NOT_FOUND = -1


class LRUCache:
    """A cache with a least-recently-used validation policy."""

    __slots__ = ('_capacity', '_map', '_sentinel')

    def __init__(self, capacity: int):
        """Makes an initially empty LRU cache of the given capacity."""
        if capacity <= 0:
            raise ValueError('capacity must be positive')

        self._capacity = capacity
        self._map = {}
        self._sentinel = _Node()

    def get(self, key: int) -> int:
        """
        Retreives the value associated with the given key.
        If there is no mapping with that key, returns NOT_FOUND.
        """
        try:
            node = self._map[key]
        except KeyError:
            return NOT_FOUND

        self._bump(node)
        return node.value

    def put(self, key: int, value: int) -> None:
        """Associates a value with a (new or existing) key."""
        try:
            node = self._map[key]
        except KeyError:
            pass
        else:
            self._bump(node)
            node.value = value
            return

        if len(self._map) < self._capacity:
            node = _Node(key, value, self._sentinel)
        else:
            node = self._sentinel.prev
            del self._map[node.key]
            node.key = key
            node.value = value
            self._bump(node)

        self._map[key] = node

    def _bump(self, node):
        """Brings node to the front of the chain."""
        node.connect_after(self._sentinel)


# Your LRUCache object will be instantiated and called as such:
# obj = LRUCache(capacity)
# param_1 = obj.get(key)
# obj.put(key,value)
