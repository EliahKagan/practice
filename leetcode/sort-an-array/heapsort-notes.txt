In a binary heap represented as an array with zero-based indexing, child
indices are:

    left = parent * 2 + 1
    right = parent * 2 + 2

Parent indices are:

    parent = (child - 1) // 2

(where "//" denotes floor division).

Now consider an array of length N > 1. The last element has index N - 1, so its
parent has index:

    (N - 2) // 2  =  N // 2 - 1

That is the highest numbered index that can have an associated left or right
child index. So in the algorithm to convert an array to a binary heap in linear
time, it is sufficient to start at that index when repeatedly sifting down from
successively higher parent indices.

For example, consider an array with 5 elements. 5 - 1 = 4 is the highest index
of any element. 5 // 2 - 1 = 2 - 1 = 1. The children of 1 are 1 * 2 + 1 = 3 and
1 * 2 + 2 = 4; both children exist but no higher-indexed children do.

As another example, consider an array with 6 elements. 6 - 1 = 5 is the highest
index of any element. 6 // 2 - 1 = 3 - 1 = 2. The children of 2 are 2 * 2 + 1 =
5 and 2 * 2 + 2 = 6; the left child exists but neither the right child nor any
higher-indexed children do.
