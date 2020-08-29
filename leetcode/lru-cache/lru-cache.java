// https://leetcode.com/problems/lru-cache/

final class LRUCache {
    LRUCache(int capacity) {
        if (capacity <= 0)
            throw new IllegalArgumentException("capacity must be positive");

        _capacity = capacity;
    }

    int get(int key) {
        var node = _map.get(key);
        if (node == null) return NOT_FOUND;

        bump(node);
        return node.value();
    }

    void put(int key, int value) {
        var node = _map.get(key);

        if (node != null) {
            node.setValue(value);
            bump(node);
            return;
        }

        if (_map.size() < _capacity) {
            node = new Node(key, value, _sentinel);
        } else {
            node = _sentinel.prev();
            _map.remove(node.key());
            node.set(key, value);
            bump(node);
        }

        _map.put(key, node);
    }

    private static final class Node {
        Node() {
            _prev = _next = this;
            _key = _value = 0;
        }

        Node(int key, int value, Node prev) {
            attach(prev);
            _key = key;
            _value = value;
        }

        void connectAfter(Node prev) {
            detach();
            attach(prev);
        }

        Node prev() {
            return _prev;
        }

        Node next() {
            return _next;
        }

        int key() {
            return _key;
        }

        int value() {
            return _value;
        }

        void setValue(int value) {
            _value = value;
        }

        void set(int key, int value) {
            _key = key;
            _value = value;
        }

        private void detach() {
            _prev._next = _next;
            _next._prev = _prev;
        }

        private void attach(Node prev) {
            _prev = prev;
            _next = prev._next;
            _prev._next = _next._prev = this;
        }

        private Node _prev;

        private Node _next;

        private int _key;

        private int _value;
    }

    private static final int NOT_FOUND = -1;

    private void bump(Node node) {
        node.connectAfter(_sentinel);
    }

    private final Map<Integer, Node> _map = new HashMap<>(); // key -> node

    private final Node _sentinel = new Node();

    private final int _capacity;
}

/**
 * Your LRUCache object will be instantiated and called as such:
 * LRUCache obj = new LRUCache(capacity);
 * int param_1 = obj.get(key);
 * obj.put(key,value);
 */
