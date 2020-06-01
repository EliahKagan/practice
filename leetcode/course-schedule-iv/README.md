# LeetCode #1462 - Course Schedule IV

https://leetcode.com/problems/course-schedule-iv/

# Strategy Used

I don't believe there's a solution with better worst-case time complexity than V^3, in a dense graph.

I used DFS, which has the same worst-case time complexity (|V|^3) as BFS or Floyd-Warshall.

I don't think there's an asymptotically better way to do this (in the worst case, and for a dense graph), so of the |V|^3 approaches I just went with the one I considered simplest.

There are at most 100 vertices, so recursively implemented DFS doesn't risk a stack overflow. I used that implementation approach.
