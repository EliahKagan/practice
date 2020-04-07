# Breadth First Search: Shortest Reach

https://www.hackerrank.com/challenges/bfsshortreach

# Strategy Used

This is straightforward breadth-first search, like it says on the tin. All edges have the same weight.

1. Input is provided as an edge list. Read it into an adjacency list.

2. Do breadth-first search, recording costs and keeping track of visitation (which can be done together by only proceeding with a vertex if its recird cost is still infinite).

3. In most BFS problems, all edges have weight 1, but any positive value works the same. In this problem it's 6. For modularity, I performed step 2 with edge weights of 1, so then I scaled them up.

4. Report the results.
