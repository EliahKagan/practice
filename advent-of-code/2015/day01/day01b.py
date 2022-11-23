"""Advent of Code 2015, day 1, part B"""


def first_negative_position(parens):
    """Get the 1-based index of the first ``)`` where ``)`` outnumber ``(``."""
    height = 0

    for pos, ch in enumerate(parens, start=1):
        match ch:
            case '(':
                height += 1
            case ')':
                height -= 1
                if height < 0:
                    return pos

    raise ValueError('height never became negative')
