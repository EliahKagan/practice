// Advent of code 2015, day 7, part A
// Via recursion with memoization, with no cycle checking.
// Implemented using bounded (discriminated-union) polymorphism (std::variant).

#include <functional>
#include <iostream>
#include <string>
#include <variant>

namespace {
    constexpr auto mask = 65'535u;

    class Constant {
    public:
        explicit constexpr Constant(const unsigned given_value) noexcept
            : value{given_value}
        {
        }

        unsigned value;
    };

    class Variable {
    public:
        explicit Variable(std::string given_name) noexcept
            : name(std::move(given_name))
        {
        }

        std::string name;
    };

    using Term = std::variant<Constant, Variable>;

    template<typename UnaryFunction>
    class UnaryExpression {
    public:
        explicit UnaryExpression(Term given_arg) noexcept
            : arg{std::move(given_arg)}
        {
        }

        UnaryFunction operation {};
        Term arg;
    };

    class Not {
    public:
        constexpr unsigned operator()(const unsigned arg) const noexcept
        {
            return ~arg & mask;
        }
    };

    using Negation = UnaryExpression<Not>;

    template<typename BinaryFunction>
    struct BinaryExpression {
        BinaryFunction operation;
        Term arg1;
        Term arg2;
    };

    class DoLeftShift {
    public:
        constexpr unsigned
        operator()(const unsigned arg1, const unsigned arg2) const noexcept
        {
            return (arg1 << arg2) & mask;
        }
    };

    class DoRightShift {
    public:
        constexpr unsigned
        operator()(const unsigned arg1, const unsigned arg2) const noexcept
        {
            return arg1 >> arg2;
        }
    };

    using Conjunction = BinaryExpression<std::bit_and<>>;

    using Alternation = BinaryExpression<std::bit_or<>>; // a.k.a. disjunction

    using LeftShift = BinaryExpression<DoLeftShift>;

    using RightShift = BinaryExpression<DoRightShift>;

    using Expression = std::variant<Term,
                                    Negation,
                                    Conjunction,
                                    Alternation,
                                    LeftShift,
                                    RightShift>;
}

int main()
{
    //
}
