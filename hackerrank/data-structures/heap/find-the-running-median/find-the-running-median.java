// HackerRank - Find the Running Median
// https://www.hackerrank.com/challenges/find-the-running-median
// Using two heaps, provided by java.util.PriorityQueue.

import java.util.Collections;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Scanner;

final class MedianBag {
    void add(int value) {
        if (!_low.isEmpty() && value < _low.element())
            _low.add(value);
        else
            _high.add(value);

        rebalance();
    }

    double median() {
        switch (balanceFactor()) {
        case -1:
            return _low.element();

        case +1:
            return _high.element();

        case 0:
            return (_low.element() + _high.element()) / 2.0;

        default:
            throw new AssertionError("balancing invariant violated");
        }
    }

    private void rebalance() {
        switch (balanceFactor()) {
        case -2:
            _high.add(_low.remove());
            break;

        case +2:
            _low.add(_high.remove());
            break;

        default:
            break; // Can't be made more balanced.
        }
    }

    private int balanceFactor() {
        return _high.size() - _low.size();
    }

    /** Maxheap of the smaller values. */
    private final Queue<Integer> _low =
        new PriorityQueue<>(Collections.reverseOrder());

    /** Minheap of the larger values. */
    private final Queue<Integer> _high = new PriorityQueue<>();
}

enum Solution {
    ;

    public static void main(String[] args) {
        MedianBag bag = new MedianBag();

        try (Scanner sc = new Scanner(System.in)) {
            for (int count = sc.nextInt(); count > 0; --count) {
                bag.add(sc.nextInt());
                System.out.format("%.1f%n", bag.median());
            }
        }
    }
}
