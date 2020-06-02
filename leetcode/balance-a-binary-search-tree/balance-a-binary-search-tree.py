# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def balanceBST(self, root: TreeNode) -> TreeNode:
        """Creates a new balanced BST with the values of the tree at root."""
        return balanced_bst_from(list(inorder(root)))

def inorder(root):
    """Inorder traversal, yielding values held in nodes."""
    stack = []
    while root or stack:
        # Go left as far as possible.
        while root:
            stack.append(root)
            root = root.left

        # Use the value at the current node.
        cur = stack.pop()
        yield cur.val

        # Go right if possible.
        root = cur.right

def balanced_bst_from(values):
    """Builds a balanced BST from a list, which is presumed to be sorted."""
    def subtree(low, high):
        if low >= high:
            return None
        mid = (low + high) // 2
        return TreeNode(values[mid], subtree(low, mid), subtree(mid + 1, high))

    return subtree(0, len(values))
