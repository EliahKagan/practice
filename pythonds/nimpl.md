# `NotImplemented` in binary dunders: why it's important

*Note that this only applies to binary dunders, which are called indirectly by
the interpreter to resolve binary operations like `==` and `+`. In particular,
the material here is completely inapplicable to ordinary (i.e., non-dunder)
methods: do not return `NotImplemented` when what you mean to do is directly
raise `TypeError`.*

In nearly all cases, *including* in all the code in this directory, it is a
design bug to fail to return `NotImplemented` when the other operand of a
binary dunder method does not support the operation.

This is important even when runtime type checking is not (otherwise) being
done. Returning `NotImplemented` allows other classes' implementations of the
operation to be attempted.

That is, dunder methods used to implement the logic for binary operators do not
merely represent carrying out that operation. They also represent the operation
of *checking* if that operation can actually be performed.

Exceptions are rare.

*I think* a design that omits such logic is only ever defensible in the rare
cases that:

1. The behavior is really correct, even with other types, including
   unanticipated types.

2. It is a performance optimization, oriented toward a specific case and
   supported by careful benchmarking, in a non-public class whose instances are
   strictly controlled, and the special responsibility this imposes on the
   caller is clearly noted.

I do not claim that list is exhaustive. Conversely, I do not insist that
everyone accepts that those cases really do justify omitting `NotImplement`
logic. My broader point is that exceptions are not just rare; they're downright
weird. Ordinarily one does not, and should not, teach rare, weird techniques
that are always wrong to novices.

The problem is that the techniques for implementing dunders have to be taught
in *some* order. Although I don't take such an approach when teaching Python,
it is arguably defensible to present a first implementation of a dunder like
`__add__`, or even `__eq__`, that doesn't check the suitability of its second
operand. I think such an approach may defensible so long as it is made clear
that the code is not yet correct, and so long as objectively false claims, such
as the misconception that these dunders are "syntactic sugar," are thoroughly
avoided.

In the code in this directory, some of which is based on (or completes)
exercises presented in *pythonds* and its accompanying (embedded) videos, I've
taken a mixed approach. For comparison operators, I've included the appropriate
checks, because attempting order comparison on potentially incompatible objects
is common, and attempting equality comparison on arbitrary objects that may be
entirely unrelated is *ubiquitous*. (For example, the latter happens anytime
the objects are used as keys in a hash-based container.) In contrast, I have
sometimes omitted the checks in dunders like `__add__` that represent
arithmetic operations (where checks that are not excessively restrictive can
also be more complicated to write).
