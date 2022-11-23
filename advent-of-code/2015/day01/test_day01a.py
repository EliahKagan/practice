"""Tests for day01a.py."""

import pytest

from day01a import what_floor


@pytest.mark.parametrize('parens, floor', [
    ('(())', 0),
    ('()()', 0),
    ('(((', 3),
    ('(()(()(', 3),
    ('))(((((', 3),
    ('())', -1),
    ('))(', -1),
    (')))', -3),
    (')())())', -3),
])
def test_what_floor(parens, floor):
    assert what_floor(parens) == floor
