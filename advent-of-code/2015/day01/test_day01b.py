"""Tests for day01b.py."""

import pytest

from day01b import first_negative_position


@pytest.mark.parametrize('parens, pos', [
    (')', 1),
    ('()())', 5),
])
def test_first_negative_position(parens, pos):
    assert first_negative_position(parens) == pos


def test_first_negative_position_reports_if_no_solution():
    with pytest.raises(ValueError):
        first_negative_position('()()(())')
