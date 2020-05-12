// Advent of code 2015, day 7, part A
// Via recursion with memoization, with no cycle checking.
// Implemented using bounded (discriminated-union) polymorphism (std::variant).

#include <functional>
#include <iostream>
#include <iterator>
#include <string>
#include <type_traits>
#include <unordered_map>
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

    using Rules = std::unordered_map<std::string, Expression>;

    using Memo = std::unordered_map<std::string, unsigned>;

    class Evaluator {
    public:
        constexpr Evaluator(const Rules &rules, Memo &memo) noexcept
            : rules_{rules}, memo_{memo}
        {
        }

        [[nodiscard]] unsigned
        operator()(const Expression& expression) noexcept
        {
            return std::visit(*this, expression);
        }

        [[nodiscard]] unsigned
        operator()(const Term& constant_or_variable) noexcept
        {
            return std::visit(*this, constant_or_variable);
        }

        // FIXME: Figure out why this can't be declared const.
        [[nodiscard]] constexpr unsigned
        operator()(const Constant constant) noexcept
        {
            return constant.value;
        }

        // Not [[nodiscard]] as it might be called just to trigger memoization.
        unsigned operator()(const Variable& variable) noexcept
        {
            if (auto p = memo_.find(variable.name); p != end(memo_))
                return p->second;

            const auto value = (*this)(rules_.at(variable.name));
            memo_.emplace(variable.name, value);
            return value;
        }

        template<typename UnaryFunction>
        [[nodiscard]] unsigned
        operator()(const UnaryExpression<UnaryFunction>& unary) noexcept
        {
            return unary.operation((*this)(unary.arg));
        }

        template<typename BinaryFunction>
        [[nodiscard]] unsigned
        operator()(const BinaryExpression<BinaryFunction>& binary) noexcept
        {
            return binary.operation((*this)(binary.arg1),
                                    (*this)(binary.arg2));
        }

    private:
        const Rules& rules_;
        Memo& memo_;
    };
}

int main()
{
}
