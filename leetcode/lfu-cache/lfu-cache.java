// https://leetcode.com/problems/lfu-cache/

class LFUCache {
    LFUCache(int capacity) {
        if (capacity < 0)
            throw new IllegalArgumentException("capacity must be nonnegative");

        _capacity = capacity;
    }

    int get(int key) {
        if (_capacity == 0) return NOT_FOUND;

        var inner = _map.get(key);
        if (inner == null) return NOT_FOUND;

        promote(inner);
        return inner.value();
    }

    void put(int key, int value) {
        if (_capacity == 0) return;

        var inner = _map.get(key);

        if (inner != null) {
            inner.setValue(value);
            promote(inner);
            return;
        }

        if (_map.size() < _capacity) {
            var outer = _outerSentinel.next().frequency() == 1
                            ? _outerSentinel.next()
                            : OuterNode.make(1, _outerSentinel);

            inner = InnerNode.make(key, value, outer.innerSentinel());
        } else {
            inner = recycle();
            _map.remove(inner.key());
            inner.set(key, value);
        }

        _map.put(key, inner);
    }

    private static final class OuterNode {
        static OuterNode makeSentinel() {
            return new OuterNode();
        }

        static OuterNode make(int frequency, OuterNode prev) {
            return new OuterNode(frequency, prev);
        }

        OuterNode prev() {
            return _prev;
        }

        OuterNode next() {
            return _next;
        }

        InnerNode innerSentinel() {
            return _innerSentinel;
        }

        int frequency() {
            return _frequency;
        }

        void setFrequency(int frequency) {
            _frequency = frequency;
        }

        void connectAfter(OuterNode prev) {
            detach();
            attach(prev);
        }

        void discard() {
            detach();
            _prev = _next = null;
        }

        private OuterNode() {
            _prev = _next = this;
            _innerSentinel = null;
            _frequency = 0;
        }

        private OuterNode(int frequency, OuterNode prev) {
            attach(prev);
            _innerSentinel = InnerNode.makeSentinel(this);
            _frequency = frequency;
        }

        private void detach() {
            _prev._next = _next;
            _next._prev = _prev;
        }

        private void attach(OuterNode prev) {
            _prev = prev;
            _next = prev._next;
            _prev._next = _next._prev = this;
        }

        private OuterNode _prev;

        private OuterNode _next;

        private final InnerNode _innerSentinel;

        private int _frequency;
    }

    private static final class InnerNode {
        static InnerNode makeSentinel(OuterNode outer) {
            return new InnerNode(outer);
        }

        static InnerNode make(int key, int value, InnerNode prev) {
            return new InnerNode(key, value, prev);
        }

        OuterNode outer() {
            return _outer;
        }

        InnerNode prev() {
            return _prev;
        }

        InnerNode next() {
            return _next;
        }

        int key() {
            return _key;
        }

        int value() {
            return _value;
        }

        void set(int key, int value) {
            _key = key;
            _value = value;
        }

        void setValue(int value) {
            _value = value;
        }

        void connectAfter(InnerNode prev) {
            detach();
            attach(prev);
        }

        private InnerNode(OuterNode outer) {
            _outer = outer;
            _prev = _next = this;
            _key = _value = 0;
        }

        private InnerNode(int key, int value, InnerNode prev) {
            attach(prev);
            set(key, value);
        }

        private void detach() {
            _prev._next = _next;
            _next._prev = _prev;
        }

        private void attach(InnerNode prev) {
            _outer = prev._outer;
            _prev = prev;
            _next = prev._next;
            _prev._next = _next._prev = this;
        }

        private OuterNode _outer;

        private InnerNode _prev;

        private InnerNode _next;

        private int _key;

        private int _value;
    }

    private static final int NOT_FOUND = -1;

    private void promote(InnerNode inner) {
        var outer = inner.outer();
        var singleton = inner.prev() == inner.next();

        if (outer.next().frequency() == outer.frequency() + 1) {
            // A group for the target frequency already exists. Use it.
            inner.connectAfter(outer.next().innerSentinel());

            // If the group became empty, remove it.
            if (singleton) outer.discard();
        } else if (singleton) {
            // Turn this into the group for the next highest frequency.
            outer.setFrequency(outer.frequency() + 1);
        } else {
            // Make a new group for the target frequency.
            var nextOuter = OuterNode.make(outer.frequency() + 1, outer);
            inner.connectAfter(nextOuter.innerSentinel());
        }
    }

    private InnerNode recycle() {
        var outer = _outerSentinel.next();
        var inner = outer.innerSentinel().prev();

        if (outer.frequency() != 1) {
            if (inner.prev() == inner.next()) {
                // Turn this singleton group into a once group.
                outer.setFrequency(1);
            } else {
                // Create a new once group.
                outer = OuterNode.make(1, _outerSentinel);
            }
        }

        inner.connectAfter(outer.innerSentinel());
        return inner;
    }

    private final Map<Integer, InnerNode> _map = new HashMap<>();

    private final OuterNode _outerSentinel = OuterNode.makeSentinel();

    private final int _capacity;
}

/**
 * Your LFUCache object will be instantiated and called as such:
 * LFUCache obj = new LFUCache(capacity);
 * int param_1 = obj.get(key);
 * obj.put(key,value);
 */
