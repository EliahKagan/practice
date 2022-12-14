# Advent of Code 2022, day 13

These problems consist mostly of two things Ruby almost provides directly:
parsing  the lists/arrays, and comparing them lexicographically. However:

1. It is best to parse them in way that cannot execute arbitrary code, so I
   implement the parsing manually.

2. When an integer n is compared to an array a, we need to coerce n to [n]
   before the comparison, and we need to do that coercion recursively
   whenever needed. So I implement the lexicographic comparison manually.