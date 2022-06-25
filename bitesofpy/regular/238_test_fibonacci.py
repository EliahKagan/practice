import pytest

from fibonacci import fib


@pytest.mark.parametrize('n', [-1, -2, -3, -100])
def test_n_cannot_be_negative(n):
    with pytest.raises(ValueError):
        fib(n)


@pytest.mark.parametrize('n', [0, 1])
def test_base_cases_are_fixed_points(n):
    assert fib(n) == n


@pytest.mark.parametrize('n, fib_n', [
    (2, 1),
    (3, 2),
    (4, 3),
    (5, 5),
    (6, 8),
    (7, 13),
    (8, 21),
    (9, 34),
    (10, 55),
])
def test_recursive_cases_compute_fibonacci_numbers(n, fib_n):
    assert fib(n) == fib_n
