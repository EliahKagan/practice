// Advent of code 2015, day 7, part A
// Via recursion with memoization, with no cycle checking.
// Implemented with a single table of function objects using type erasure.
// This is like the C# version day07a.linq, but in C++ with std::function.

#include <functional>
#include <string>
#include <string_view>
#include <unordered_map>

namespace {
    constexpr auto mask = 65'535u;

    using NullaryFunction = std::function<unsigned()>;

    using UnaryFunction = std::function<unsigned(unsigned)>;

    using BinaryFunction = std::function<unsigned(unsigned, unsigned)>;

    const auto unary_functions
            = std::unordered_map<std::string_view, UnaryFunction>{
        { "NOT", [](const unsigned arg) noexcept { return ~arg & mask; } }
    };

    const auto binary_functions
            = std::unordered_map<std::string_view, BinaryFunction>{
        { "AND", [](const unsigned arg1, const unsigned arg2) noexcept
                    { return arg1 & arg2; } },
        { "OR", [](const unsigned arg1, const unsigned arg2) noexcept
                    { return arg1 | arg2; } },
        { "LSHIFT", [](const unsigned arg1, const unsigned arg2) noexcept
                    { return (arg1 << arg2) & mask; } },
        { "RSHIFT", [](const unsigned arg1, const unsigned arg2) noexcept
                    { return arg1 >> arg2; } }
    };

    class Scope {
    private:
        std::unordered_map<std::string, NullaryFunction> variables_ {};
    };

    //const auto unary_functions = std::unordered_map<
}

int main()
{
    //
}
