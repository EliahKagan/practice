#!/usr/bin/env python

"""Advent of Code 2015, day 7"""

import fileinput
import operator


MASK = 2**16 - 1

UNARY_OPERATORS = {
    'NOT': lambda arg: ~arg & MASK,
}

BINARY_OPERATORS = {
    'AND': operator.and_,
    'OR': operator.or_,
    'LSHIFT': lambda arg1, arg2: (arg1 << arg2) & MASK,
    'RSHIFT': operator.rshift,
}


class CyclicDependencyError(RuntimeError):
    """Cycle found in dependency graph (computation cannot complete)."""

    __slots__ = ()

    def __init__(self, name):
        """Creates a new error with the variable that can't be solved for."""
        super.__init__(f"cyclic dependency, can't solve for \"name\"")


thunks = {}

def make_term(name_or_value):
    try:
        value = int(name_or_value)
    except ValueError:
        return lambda: thunks[name_or_value]()
    return lambda: value

def make_unary(unary_symbol, arg):
    unary_op = UNARY_OPERATORS[unary_symbol]
    term = make_term(arg)
    return lambda: unary_op(term())

def make_binary(binary_symbol, arg1, arg2):
    binary_op = BINARY_OPERATORS[binary_symbol]
    term1 = make_term(arg1)
    term2 = make_term(arg2)
    return lambda: binary_op(term1(), term2())

def make_rule(tokens):
    match len(tokens):
        case 1:
            return make_term(tokens[0])
        case 2:
            return make_unary(tokens[0], tokens[1])
        case 3:
            return make_binary(tokens[1], tokens[0], tokens[2])
        case n:
            raise ValueError(f'malformed rule ({n} tokens)')

def make_cycle_canary(name):
    def canary():
        raise CyclicDependencyError(name)

    return canary

def add_rule(name, code):
    def thunk():
        thunks[name] = make_cycle_canary(name)
        value = code()
        thunks[name] = lambda: value
        return value

    thunks[name] = thunk

for rule, name in (map(str.strip, line.split('->'))
                   for line in fileinput.input()):
    add_rule(name, make_rule(rule.split()))

for name in sorted(thunks):
    print(f'{name}: {thunks[name]()}')
