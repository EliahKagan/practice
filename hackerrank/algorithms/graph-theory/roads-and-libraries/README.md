# Roads and Libraries

https://www.hackerrank.com/challenges/torque-and-development

Also called "Torque and Development."

# Strategy Used

Cities are vertices and roads are edges. Conceptually:

1. If libraries are cheaper than roads, build one library per vertex and we're done.

2. Otherwise, count the number of vertices in each connected component, via DFS, BFS, or union-find.

3. In each component with *n* vertices, build *1* component and *n - 1* roads.

Really, there's no need to find the sizes of any particular components. Computing the number of components or the number of edges in a minimum spanning forest is sufficient to calucluate everything (and simpler).