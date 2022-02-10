# Advent of Code 2021, day 15

Passing `-a`/`--acyclic` to `day15a.py` causes it to find shortest paths in a
DAG where only rightward and downward moves are permitted. After solving both
parts successfully&mdash;on the cyclic undirected 4-way adjacency graph, using
Dijkstra&rsquo;s algorithm&mdash;I wanted to check if restricting to that DAG
(permitting a simpler and faster algorithm) would also *happen* to give a
correct answer for my `input` file, since it does on the `example` input, and
the problem description seemed borderline ambiguous as to what kind of movement
was permitted.

It did not. Upward and leftward movement is also permitted, and optimal paths
must use it (at least for part A; I did not repeat this experiment on part B).
