# [LeetCode #114 - Flatten Binary Tree to Linked List](https://leetcode.com/problems/flatten-binary-tree-to-linked-list)

I've solved this in time linear in the size of the tree, space linear in the
height of the tree, by preorder depth-first traversal of the tree.

The only subtlety is that one must traverse to each node's original children,
not the new children (or nulls) arising from modifying the tree.

In recursive preorder traversal this is easily achieved by storing the child
links in variables before appending the current node to the chain, then
recursing using those variables.

In simple iterative preorder traversal with a stack of nodes (the usual
technique of pushing right, then left, to achieve left-to-right traversal),
nothing special has to be done, so long as child links are pushed to the stack
before the current node is appended to the chain.

The prewritten comment includes:

> Do not return anything, modify root in-place instead.

But at least for Ruby the online judge accepts the root node to be returned.
Presumably the return value is not examined. My solutions do modify the root
(and the whole tree) in-place, of course. I just find it much more intuitive to
return the root, especially in Ruby where a "void" return is really a return of
nil, which conceptually represents an empty tree.
