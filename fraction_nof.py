"""
fraction_nof.py

Fractional calculations. Even though fractions.Fraction exists.

This is like fraction.py, except that functools is not used, since Skulpt
doesn't support it, so the code in fraction.py cannot be used in pythonds
(at https://runestone.academy/runestone/books/published/pythonds/Introduction/ObjectOrientedProgramminginPythonDefiningClasses.html).
"""

__all__ = ['Fraction']


def _gcd(a, b):
    while b != 0:
        a, b = b, a % b

    return a


class Fraction:
    """
    A fraction type, even though fractions.Fraction exists and is good.

    NOTE: This class does NOT make use of NotImplemented for arithmetic
    operations. It assumes the second operand of an arithmetic operation is
    always of a compatible type. This behavior is wrong. See nimpl.md for why
    it is wrong, even here, and why I've nonetheless done it in this code. Note
    that it's not *justified* here. This code should not be used in production.
    """

    __slots__ = ('_numerator', '_denominator')

    def __init__(self, numerator, denominator=1):
        """Creates a fraction with the specified numerator and denominator."""
        if denominator == 0:
            raise ZeroDivisionError('denominator cannot be zero')

        gcd = _gcd(numerator, denominator)
        self._numerator = numerator // gcd
        self._denominator = denominator // gcd

        if self._denominator < 0:
            self._numerator = -self._numerator
            self._denominator = -self._denominator

    def __eq__(self, other):
        """Checks if two fractions are equal."""
        if not isinstance(other, Fraction):
            return NotImplemented

        return (self._numerator == other.numerator
                and self._denominator == other.denominator)

    def __lt__(self, other):
        """Checks if this fraction is smaller than another."""
        if not isinstance(other, Fraction):
            return NotImplemented

        lhs = self._numerator * other.denominator
        rhs = other.numerator * self._denominator
        return lhs < rhs

    def __gt__(self, other):
        """Checks if this fraction is larger than another."""
        return other.__lt__(self)

    def __le__(self, other):
        """Checks if this fraction is no larger than another."""
        lt_result = self.__lt__(other)
        if lt_result is NotImplemented or lt_result:
            return lt_result
        return self.__eq__(other)

    def __ge__(self, other):
        """Checks if this fraction is no smaller than another."""
        gt_result = self.__gt__(other)
        if gt_result is NotImplemented or gt_result:
            return gt_result
        return self.__eq__(other)

    def __hash__(self):
        """Computes a prehash to store this fraction in a dict or set."""
        return hash((self._numerator, self._denominator))

    def __repr__(self):
        """Representation of a fraction that can be passed to eval()."""
        return f'Fraction({self._numerator!r}, {self._denominator!r})'

    def __str__(self):
        """Representation of a fraction suitable for user interfaces."""
        return f'{self._numerator}/{self._denominator}'

    def __neg__(self):
        """Computes the additive inverse (unary minus)."""
        return Fraction(-self._numerator, self._denominator)

    def __pos__(self):
        """Returns the same value (unary plus)."""
        return self

    def __abs__(self):
        """Returns the absolute value."""
        return Fraction(abs(self._numerator), self._denominator)

    def __add__(self, other):
        """Computes the sum of this and another fraction."""
        return Fraction(self._numerator * other.denominator
                            + other.numerator * self._denominator,
                        self._denominator * other.denominator)

    def __sub__(self, other):
        """Computes the difference of this and another fraction."""
        return self + -other

    def __mul__(self, other):
        """Computes the the product of this and another fraction."""
        return Fraction(self._numerator * other.numerator,
                        self._denominator * other.denominator)

    def __truediv__(self, other):
        """Computes the quotient of this and another fraction."""
        if other.numerator == 0:
            raise ZeroDivisionError('cannot divide by the zero fraction')

        return self * other.reciprocal

    def __pow__(self, exponent):
        """Raises this fraction to a particular integer exponent."""
        if exponent >= 0:
            return self._do_pow(exponent)

        if self._numerator == 0:
            raise ZeroDivisionError(
                    'cannot raise the zero fraction to a negative power')

        return self._do_pow(-exponent).reciprocal

    @property
    def numerator(self):
        """The fraction's numerator (dividend)."""
        return self._numerator

    @property
    def denominator(self):
        """The fraction's denominator (divisor)."""
        return self._denominator

    @property
    def reciprocal(self):
        """The fraction's multiplicative inverse (reciprocal)."""
        return Fraction(self._denominator, self._numerator)

    def _do_pow(self, exponent):
        if exponent == 0:
            return Fraction.ONE

        ret = self._do_pow(exponent // 2)
        return ret * ret if exponent % 2 == 0 else ret * ret * self


Fraction.ZERO = Fraction(0)

Fraction.ONE = Fraction(1)
