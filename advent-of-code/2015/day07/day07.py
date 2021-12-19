#!/usr/bin/env python

"""Advent of Code 2015, day 7"""

import argparse
import fileinput
import operator
import sys

from typing import (Callable,
                    Iterable,
                    MutableMapping,
                    NamedTuple,
                    NoReturn,
                    Sequence)

from typeguard import typechecked


MASK = 2**16 - 1
"""Bits retained by the unary and binary operators in this program."""

UNARY_OPERATORS: dict[str, Callable[[int], int]] = {
    'NOT': lambda arg: ~arg & MASK,
}
"""Table mapping names to one-parameter (arity 1) operations."""

BINARY_OPERATORS: dict[str, Callable[[int, int], int]] = {
    'AND': operator.and_,
    'OR': operator.or_,
    'LSHIFT': lambda arg1, arg2: (arg1 << arg2) & MASK,
    'RSHIFT': operator.rshift,
}
"""Table mapping names to two-parameter (arity 2) operations."""


Thunk = Callable[[], int]
"""Represents a deferred computation of an integer."""


@typechecked
class CyclicDependencyError(RuntimeError):
    """Cycle found in dependency graph (computation cannot complete)."""

    __slots__ = ()

    def __init__(self, name: str):
        """Creates a new error with the variable that can't be solved for."""
        super().__init__(f'''cyclic dependency, can't solve for "{name}"''')


@typechecked
class Binding(NamedTuple):
    """A "variable" name and the expression that will give it its value."""

    name: str
    """The variable name."""

    expression_tokens: Sequence[str]
    """The expression to eventually be evaluated to assign the variable."""


@typechecked
def build_thunk_table(bindings: Iterable[Binding]) \
        -> MutableMapping[str, Thunk]:
    """Builds a thunk table from the given bindings."""
    thunks = dict[str, Thunk]()

    @typechecked
    def make_term(name_or_value: str) -> Thunk:
        try:
            value = int(name_or_value)
        except ValueError:
            # The thunk table may not have the final (or any) value set yet for
            # this name, so we have to defer the read. But Pylint doesn't know
            # that and wrongly thinks we can just return thunks[name_or_value].
            # pylint: disable=unnecessary-lambda
            return lambda: thunks[name_or_value]()
        return lambda: value

    @typechecked
    def make_unary(unary_symbol: str, arg: str) -> Thunk:
        unary_op = UNARY_OPERATORS[unary_symbol]
        term = make_term(arg)
        return lambda: unary_op(term())

    @typechecked
    def make_binary(binary_symbol: str, arg1: str, arg2: str) -> Thunk:
        binary_op = BINARY_OPERATORS[binary_symbol]
        term1 = make_term(arg1)
        term2 = make_term(arg2)
        return lambda: binary_op(term1(), term2())

    @typechecked
    def make_thunk(tokens: Sequence[str]) -> Thunk:
        match len(tokens):
            case 1:
                return make_term(tokens[0])
            case 2:
                return make_unary(tokens[0], tokens[1])
            case 3:
                return make_binary(tokens[1], tokens[0], tokens[2])
            case _:
                raise ValueError(f'malformed rule ({len(tokens)} tokens)')

        raise AssertionError('unreachable')  # ...but mypy doesn't know it.

    @typechecked
    def make_cycle_canary(name: str) -> Callable[[], NoReturn]:
        def canary() -> NoReturn:
            raise CyclicDependencyError(name)

        return canary

    @typechecked
    def add_rule(name: str, code: Thunk) -> None:
        def thunk():
            thunks[name] = make_cycle_canary(name)
            value = code()
            thunks[name] = lambda: value
            return value

        thunks[name] = thunk

    for name, expression_tokens in bindings:
        add_rule(name, make_thunk(expression_tokens))

    return thunks


@typechecked
def parse_options() -> argparse.Namespace:
    """Parses command-line options."""
    parser = argparse.ArgumentParser()

    parser.add_argument('-t', '--test',
                        help='evaluate and print all variables (for testing)',
                        action='store_true')

    options, remaining_args = parser.parse_known_intermixed_args()
    sys.argv[1:] = remaining_args
    return options


@typechecked
def read_bindings() -> Sequence[Binding]:
    """Reads bindings (names and expression tokens) from stdin or a file."""
    lines: Iterable[str] = fileinput.input()

    return [Binding(name=right.strip(), expression_tokens=left.split())
            for left, right in (line.split('->') for line in lines)]


@typechecked
def run() -> None:
    """Reads bindings from stdin or a file and solves for all variables."""
    options = parse_options()
    bindings = read_bindings()
    thunks = build_thunk_table(bindings)

    if options.test:
        for name in sorted(build_thunk_table(bindings)):
            print(f'{name}: {thunks[name]()}')
    else:
        a_value = thunks['a']()
        print(f'Before rewire:  {a_value}')

        thunks_after = build_thunk_table(bindings)
        thunks_after['b'] = lambda: a_value
        print(f' After rewire:  {thunks_after["a"]()}')


if __name__ == '__main__':
    run()
