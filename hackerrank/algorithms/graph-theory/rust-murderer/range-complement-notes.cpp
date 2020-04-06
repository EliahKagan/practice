// I don't plan to use code like this. A RangeComplement type would be better.

// The iterators [first, last) must, when deferenced, yield monotone
// increasing values in the range [lower, upper).
template<typename InputIt, typename Value, typename UnaryFunction>
void foreach_complement(InputIt first, const InputIt last,
                        Value lower, const Value upper, UnaryFunction f)
{
    for (; lower != upper; ++lower) {
        if (first != last && *first == lower) {
            while (++first != last && *first == lower) { }
        }
        else f(lower);
    }
}
