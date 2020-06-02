# LeetCode #1382 - Balance a Binary Search Tree

https://leetcode.com/problems/balance-a-binary-search-tree/

# Strategy Used

Though the title suggests that the goal is to modify the provided tree by performing rotations, the wording of the problem just says to return a tree. Its phrasing

> Given a binary search tree, return a balanced binary search tree with the same node values.

suggests that it is even preferred to return a new tree, though I think either way would be fine.

It is simpler to make a new tree, which one can build to be balanced initially. This is easiest (and probably also faster, due to the cost of indirections, than a method that traverses the input tree twice) to copy the values, emitted by inorder traversal, into array, then build the new balanced BST from the array by recursively selecting the middle element and building the subtrees.

If the tree is not too badly unbalanced, then this inorder traversal could be performed recursively. I decided that the problem should be solved in a way that avoids a stack overflow even for huge trees that are very unbalanced, and thus wrote the traversal with an iterative technique.
