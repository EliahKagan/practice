// HackerRank - Median Updates
// https://www.hackerrank.com/challenges/median
// In Java 8, because that's what HackerRank supports. The problem is intended
// to be solved with self-balancing trees, but this solution uses binary heaps
// equipped with an O(log(n)) remove operation.

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * A priority queue with an O(log(n)) remove operation.
 * <p>
 *   Implemented as a binary heap augmented with a table mapping each key to
 *   all of its occurrences in the heap.
 * </p>
 **/
final class BinaryHeap<E> {
    static <E extends Comparable<E>> BinaryHeap<E> makeMinHeap() {
        return new BinaryHeap<>(Comparator.naturalOrder());
    }

    static <E extends Comparable<E>> BinaryHeap<E> makeMaxHeap() {
        return new BinaryHeap<>(Collections.reverseOrder());
    }

    boolean isEmpty() {
        return _heap.isEmpty();
    }

    int size() {
        return _heap.size();
    }

    void clear() {
        _heap.clear();
        _map.clear();
    }

    void push(E value) {
        _heap.add(null);
        int child = siftUp(value);
        _map.computeIfAbsent(value, val -> new HashSet<>()).add(child);
        _heap.set(child, value);
    }

    E pop() {
        E value = peek();

        if (size() == 1) {
            clear();
        } else {
            _map.computeIfPresent(value, (val, indices) -> {
                if (indices.size() == 1) {
                    return null; // Remove the mapping.
                } else {
                    indices.remove(0); // Remove the index from the mapped set.
                    return indices; // Keep the mapping.
                }
            });

            cutRoot();
        }

        return value;
    }

    E peek() {
        return _heap.get(0);
    }

    boolean remove(E value) {
        Set<Integer> indices = _map.get(value);
        if (indices == null) return false;

        if (size() == 1) {
            clear();
        } else {
            // Get any index to this value in the heap.
            int child = indices.iterator().next();

            if (indices.size() == 1) {
                _map.remove(value); // Remove the mapping.
            } else {
                child = highestEqualAncestor(child);
                indices.remove(child); // Remove the index from the mapped set.
            }

            yankUp(child);
            cutRoot();
        }

        return true;
    }

    private static final int NO_CHILD = -1;

    private BinaryHeap(Comparator<? super E> comp) {
        _comp = comp;
    }

    private void cutRoot() {
        int last = size() - 1;
        E value = _heap.get(last);
        _heap.remove(last); // Remove the item whose index is last.

        Set<Integer> indices = _map.get(value);
        indices.remove(last); // Remove the item comparing equal to last.

        int index = siftDown(value);
        indices.add(index);
        _heap.set(index, value);
    }

    private int highestEqualAncestor(int child) {
        E value = _heap.get(child);

        while (child != 0) {
            int parent = (child - 1) / 2;
            if (!_heap.get(parent).equals(value)) break;
            child = parent;
        }

        return child;
    }

    private void yankUp(int child) {
        while (child != 0) {
            int parent = (child - 1) / 2;
            E parentValue = _heap.get(parent);

            Set<Integer> indices = _map.get(parentValue);
            indices.remove(parent);
            indices.add(child);
            _heap.set(child, parentValue);

            child = parent;
        }
    }

    private int siftUp(E childValue) {
        int child = size() - 1;

        while (child != 0) {
            int parent = (child - 1) / 2;
            E parentValue = _heap.get(parent);
            if (orderOk(parentValue, childValue)) break;

            Set<Integer> indices = _map.get(parentValue);
            indices.remove(parent);
            indices.add(child);
            _heap.set(child, parentValue);

            child = parent;
        }

        return child;
    }

    private int siftDown(E parentValue) {
        int parent = 0;

        for (; ; ) {
            int child = pickChild(parent);
            if (child == NO_CHILD) break;
            E childValue = _heap.get(child);
            if (orderOk(parentValue, childValue)) break;

            Set<Integer> indices = _map.get(childValue);
            indices.remove(child);
            indices.add(parent);
            _heap.set(parent, childValue);

            parent = child;
        }

        return parent;
    }

    private int pickChild(int parent) {
        int left = parent * 2 + 1;
        if (left >= size()) return NO_CHILD;

        int right = left + 1;
        return right == size() || orderOk(_heap.get(left), _heap.get(right))
                ? left
                : right;
    }

    private boolean orderOk(E parentValue, E childValue) {
        return _comp.compare(parentValue, childValue) <= 0;
    }

    private final Map<E, Set<Integer>> _map = new HashMap<>();

    private final List<E> _heap = new ArrayList<>();

    private final Comparator<? super E> _comp;
}

final class MedianBag {
    boolean isEmpty() {
        return _low.isEmpty() && _high.isEmpty();
    }

    void add(int value) {
        if (!_low.isEmpty() && value < _low.peek())
            _low.push(value);
        else
            _high.push(value);

        rebalance();
    }

    boolean remove(int value) {
        if (_low.remove(value) || _high.remove(value)) {
            rebalance();
            return true;
        }

        return false;
    }

    void printMedian() {
        switch (balanceFactor()) {
        case -1:
            System.out.println(_low.peek());
            break;

        case +1:
            System.out.println(_high.peek());
            break;

        case 0:
            long sum = (long)_low.peek() + (long)_high.peek();
            long half = sum / 2;

            if (sum % 2 == 0)
                System.out.println(half);
            else if (sum == -1)
                System.out.println("-0.5");
            else
                System.out.println(half + ".5");

            break;

        default:
            throw new AssertionError("Bug: balancing invariant violated");
        }
    }

    private void rebalance() {
        switch (balanceFactor()) {
        case -2:
            _high.push(_low.pop());
            break;

        case +2:
            _low.push(_high.pop());
            break;

        default:
            break; // Can't be made more balanced.
        }
    }

    private int balanceFactor() {
        return _high.size() - _low.size();
    }

    private final BinaryHeap<Integer> _low = BinaryHeap.makeMaxHeap();

    private final BinaryHeap<Integer> _high = BinaryHeap.makeMinHeap();
}

enum Solution {
    ;

    public static void main(String[] args) throws IOException {
        MedianBag bag = new MedianBag();

        try (   Reader isr = new InputStreamReader(System.in);
                BufferedReader br = new BufferedReader(isr)) {
            Matcher matcher = TOKEN.matcher(br.readLine());
            for (int count = nextInt(matcher); count > 0; --count) {
                matcher.reset(br.readLine());
                char opcode = next(matcher).charAt(0);
                int argument = nextInt(matcher);

                switch (opcode) {
                case 'a':
                    bag.add(argument);
                    break;

                case 'r':
                    if (!bag.remove(argument) || bag.isEmpty()) {
                        System.out.println("Wrong!");
                        continue;
                    }
                    break;

                default:
                    break; // Ignore unrecognized opcodes.
                }

                bag.printMedian();
            }
        }
    }

    private static String next(Matcher matcher) {
        matcher.find();
        return matcher.group();
    }

    private static int nextInt(Matcher matcher) {
        return Integer.parseInt(next(matcher));
    }

    private static final Pattern TOKEN = Pattern.compile("\\S+");
}
