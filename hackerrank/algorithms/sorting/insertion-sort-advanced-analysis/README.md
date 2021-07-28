# HackerRank: Insertion Sort Advanced Analysis

This is the HackerRank sorting practice problem [Insertion Sort Advanced
Analysis](https://www.hackerrank.com/challenges/insertion-sort). The URL is
slighty misleading in that, while the problem to be solved is about insertion
sort, the way to solve it requries understanding and implementation of
mergesort.

It is also available (with a different, more explanatory description) elsewhere
on HackerRank as [Merge Sort: Counting
Inversions](https://www.hackerrank.com/challenges/ctci-merge-sort). This was
part of a series of practice problems developed or presented by HackerRank in
collaboration with Gayle Laakmann McDowell, author of *Cracking the Coding
Interview* (which is what the `ctci` in the URL stands for).

## Explanation

In mergesort, when the current (i.e., leftmost unmerged) element in the right
subarray has strictly lower value than the current (i.e., leftmost unmerged)
element in the left subarray, it is selected (i.e., merged) and the right index
is incremented. When this happens, it is in effect being moved ahead in line
over all the yet-unmerged elements from the left subarray.

In contrast, in insertion sort, it would have to be swapped with that many
elements (or they would have to be moved right by one and it put in place, which
may be faster in practice but has the same asymptotic time complexity and,
furthermore, involves the exact same number of iterations of an inner loop).

This is one way to gain further intuitive insight (in addition to the
straightforward proof that mergesort is *O(n log n)*) into why mergesort is
asymptotically faster than insertion sort.

If one wishes to know how many swaps insertion sort would perform to sort an
array, one approach is to write an instrumented implementation of insertion sort
that counts the number of swaps (or the number of shifts, if implemented without
swapping). But this will often not be feasible since insertion sort has
worst-case, and average case, quadratic (*O(n&#178;)*) runtime.

On modern hardware (where contiguous copying is fast and CPUs have vector units
and vector assembly-language instructions), the *constants* may in practice be
much improved by implementing binary insertion sort (where binary search is used
to find the insertion point) and shifting elements using a technique that
facilitates vectorization. In particular, with a high-quality C++ compiler with
optimizations enabled, using
[`std::move_backward`](https://en.cppreference.com/w/cpp/algorithm/move_backward)
or [`std::rotate`](https://en.cppreference.com/w/cpp/algorithm/rotate)&mdash;on
contiguously represented sequences of primitive integers, as in this
problem&mdash;vector instructions will be generated. Likewise, with a
high-quality C (or C++) compiler with optimizations enabled, using
[`memmove`](https://en.cppreference.com/w/c/string/byte/memmove) (or
[`std::memmove`](https://en.cppreference.com/w/cpp/string/byte/memmove)) under
these conditions, vector instructions will be generated.

But that is only a constant-factor improvement, so it is not a feasible way to
solve this problem for large inputs. Thus, a more fruitful approaach, rather
than instrumenting insertion sort, is to instrument mergesort, taking the sum of
the number of remaining (unmerged) left-subarray elements each time a
right-subarray element is selected (i.e., merged). Mergesort is has worst-case
*O(n log n)* runtime, so this solution does too.
