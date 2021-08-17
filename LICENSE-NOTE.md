# Notes about licensing and scaffolding code / example test case fair use

Code in this repository that I have written is licensed under 0BSD. That is
also the license under which this repository, as a whole, is offered. See
[`LICENSE`](LICENSE).

However, a small amount of code and other content in this repository is not
written by me. I believe the doctrine of fair use permits to me to include it,
where I have done so. When I have doubted that fair use permits this, I have
tried always to omit such code and other content, even when doing so would
make my own work less clear or useful. I believe it is possible to discern,
with minimal effort, which content I am claiming to have written. In cases
where I have doubted this, I have tried either to omit any content not written
by me, or I have included an explicit statement explaining the situation.

The reason this repository contains some (though it is a small amount) of
content not written by me relates to the nature of practice and competitive
programming problems and online judges. There are two kinds of situations where
I have sometimes included such content:

## 1. Scaffolding code and prewritten comments

Some problems require that submissions include scaffolding or other code or
contain prewritten comments documenting problem requirements or scaffolding
code that is not included.

Usually it is possible to tell when scaffolding code is present, due to the
presence of comments (or, in languages like Python to which they apply,
docstrings) containing at least one of the following:

1. A statement that particular code is written by the problem setter.

2. A statement that particular code must be included in submitted solutions.

3. A statement that no more than some amount of the code (e.g., some number of
   lines) is to be modified in solutions.

4. Information about how the code will be called. The code it refers to is
   generally (but not when otherwise indicated) written by me, but commented
   example code describing how it will be called is generally written by the
   problem setter, not me.

5. Directions, written imperatively, instructing people solving the problem (in
   the context of this repository, that's me) on how to write code. Such
   comments are written by problem setters, not me. Their content may sometimes
   provide contextual information to indicate what parts of a file are written
   by the problem setter.

6. A statement that a particular type (usually a class), whose implementation
   is not supplied outside of a comment, is implemented in a particular way:
   either by giving full or abridged code of the type, or by stating that it
   works as if it were implemented with particular given code. Most commonly,
   this is a comment showing the implementation of a simple linked list node or
   binary tree node type.

Furthermore, in problems where the purpose is to implement a function, the
problem setter will often have included information accompanying the top-level
function (the one that scaffolding code, which may or may not be included in
the solution but usually is not included, will call--this may or may not be
"top level" in a language-technical sense), which I have retained:

1. A comment or docstring at the top of the function may have been written by
   the problem setter, especially if the solution is in a dynamically typed
   language and the comment specifies the expected runtime types of arguments
   passed to the function.

2. When present, the name, number of parameters, parameter types, return type,
   and usually also the names of the parameters, are supplied by the problem
   setter. Changing these would either make the solution incorrect or very
   confusing.

Likewise, in problems where the purpose is to implement a type (usually this is
a class), comments and docstrings documenting the type and/or any of the
functions/methods in the type that must be written to satisfy the requirements
of the problem (because scaffolding code, which may or may not be included,
calls them), may likewise be retained.

## 2. Short example test cases

I've included some short example test cases. Their filenames end in `.in`
followed by zero or more digits. For example, in a competitive programming
problem titled "Overthink Licensing," a C++ solution might be titled
`overthink-licensing.cpp`, in which case example test cases are likely to be
named `overthink-licensing.in`, `overthink-licensing.in2`, and so forth.

The reason I've sometimes included these is that I think they make it easier to
try out or test my solutions, as well as to understand them, both for me and
for anyone else using this repository.

Sometimes these example test cases are the examples given in, or accompanying,
the problem, and thus written by the problem setter rather than me. That is the
most common case. Sometimes they are derived from such examples. Sometimes, I
have written them from scratch.

I have tried to omit such files from this repository in all cases except those
when they are short such that I believe fair use permits me to include them and
also that my inclusion of them is otherwise unobjectionable. Since such test
cases, while beneficial to understanding, do not need to be present for my code
to work or make sense, I've tried to err on the side of omitting anything
substantial or that I otherwise guess a problem setter would not wish to be
distributed. Still, it is possible that I have made mistakes. I hope not.

I have not usually indicated the origin of test cases. Although I may have
written or modified a small handful of them, I do not claim authorship of any
of them. But if you find a bug in a test case, please check that it is actually
supplied alongside the problem, before assuming the problem setter made a
mistake!

Please note that, other than any test cases I have written myself, I have tried
hard to include only example test cases (and sometimes modified versions of
them). By this I mean test cases that are supplied directly alongside a problem
in such a way as to be understood as, in effect, part of the problem
description. For example, I have tried never to include any test cases that are
not publicly available, require an account, or that are otherwise even
partially hidden or obscured. I think I've succeeded at avoiding this. If I
have not, that is a bug.
