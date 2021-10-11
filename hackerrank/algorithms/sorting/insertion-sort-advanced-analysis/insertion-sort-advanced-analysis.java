// HackerRank: Insertion Sort Advanced Analysis
// https://www.hackerrank.com/challenges/insertion-sort/
// By instrumenting recursive top-down mergesort.

import java.util.Scanner;

enum Algo {
    ;

    /**
     * Mergesorts an array and returns the number of inversions it had.
     * @param{values}  The array to sort and count inversions in.
     * @return  The number of inversions originally present. This is the same
     *          as the number of swaps/shifts insertion sort would do.
     * */
    static int mergesort(int[] values) {
        var aux = new int[values.length];
        return mergesortSubarray(values, 0, values.length, aux);
    }

    private static int
    mergesortSubarray(int[] values, int low, int high, int[] aux) {
        if (high - low < 2) return 0;

        var mid = low + (high - low) / 2;

        var count = 0;
        count += mergesortSubarray(values, low, mid, aux);
        count += mergesortSubarray(values, mid, high, aux);
        count += merge(values, low, mid, high, aux);
        return count;
    }

    private static int
    merge(int[] values, int low, int mid, int high, int[] aux) {
        var count = 0;
        var left = low;
        var right = mid;
        var out = 0;

        while (left < mid && right < high) {
            if (values[right] < values[left]) {
                aux[out++] = values[right++];
                count += mid - left;
            } else {
                aux[out++] = values[left++];
            }
        }

        while (left < mid) aux[out++] = values[left++];
        if (right - low != out) throw new AssertionError("length mismatch");
        for (var i = 0; i < out; ++i) values[low++] = aux[i];
        return count;
    }
}

enum Solution {
    ;

    public static void main(String[] args) {
        try (Scanner sc = new Scanner(System.in)) {
            for (var t = sc.nextInt(); t > -0; --t) {
                System.out.println(Algo.mergesort(readRecord(sc)));
            }
        }
    }

    private static int[] readRecord(Scanner sc) {
        var values = new int[sc.nextInt()];
        for (var i = 0; i < values.length; ++i) values[i] = sc.nextInt();
        return values;
    }
}
