#include <algorithm>
#include <iostream>
#include <iterator>
#include <memory>
#include <optional>
#include <sstream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

namespace {
    constexpr auto mask = 65'535u;

    class Expression;

    using Expr = std::unique_ptr<const Expression>;

    using Rules = std::unordered_map<std::string, Expr>;

    using Memo = std::unordered_map<std::string, unsigned>;

    class Expression {
    public:
        Expression(const Expression&) = delete;
        Expression& operator=(const Expression&) = delete;
        virtual ~Expression() = default;

        virtual unsigned evaluate(const Rules& rules, Memo& memo) const = 0;
    };

    class Constant final : public Expression {
    public:
        explicit constexpr Constant(unsigned value) noexcept
            : value_{value}
        {
        }

        unsigned evaluate(const Rules&, Memo&) const noexcept override
        {
            return value_;
        }

    private:
        const unsigned value_;
    };

    class Variable final : public Expression {
    public:
        explicit Variable(std::string name) noexcept
            : name_(std::move(name))
        {
        }

        unsigned
        evaluate(const Rules& rules, Memo& memo) const noexcept override;

    private:
        const std::string name_;
    };

    unsigned Variable::evaluate(const Rules& rules, Memo& memo) const noexcept
    {
        if (auto p = memo.find(name_); p != end(memo))
            return p->second;

        const auto value = rules.at(name_)->evaluate(rules, memo);
        memo.emplace(name_, value);
        return value;
    }

    class UnaryExpression : public Expression {
    public:
        explicit UnaryExpression(Expr arg) noexcept
            : arg_{std::move(arg)}
        {
        }

    protected:
        const Expr arg_;
    };

    class Negation final : public UnaryExpression {
    public:
        using UnaryExpression::UnaryExpression;

        unsigned
        evaluate(const Rules& rules, Memo& memo) const noexcept override
        {
            return ~arg_->evaluate(rules, memo) & mask;
        }
    };

    class BinaryExpression : public Expression {
    public:
        BinaryExpression(Expr arg1, Expr arg2) noexcept
            : arg1_{std::move(arg1)}, arg2_{std::move(arg2)}
        {
        }

    protected:
        const Expr arg1_;
        const Expr arg2_;
    };

    class Conjunction : public BinaryExpression {
    public:
        using BinaryExpression::BinaryExpression;

        unsigned
        evaluate(const Rules &rules, Memo &memo) const noexcept override
        {
            return arg1_->evaluate(rules, memo) & arg2_->evaluate(rules, memo);
        }
    };

    class Alternation : public BinaryExpression { // a.k.a. disjunction
        using BinaryExpression::BinaryExpression;

        unsigned
        evaluate(const Rules &rules, Memo &memo) const noexcept override
        {
            return arg1_->evaluate(rules, memo) | arg2_->evaluate(rules, memo);
        }
    };

    class LeftShift : public BinaryExpression {
        using BinaryExpression::BinaryExpression;

        unsigned
        evaluate(const Rules &rules, Memo &memo) const noexcept override
        {
            return (arg1_->evaluate(rules, memo)
                 << arg2_->evaluate(rules, memo)) & mask;
        }
    };

    class RightShift : public BinaryExpression {
        using BinaryExpression::BinaryExpression;

        unsigned
        evaluate(const Rules &rules, Memo &memo) const noexcept override
        {
            return arg1_->evaluate(rules, memo)
                >> arg2_->evaluate(rules, memo);
        }
    };

    [[nodiscard]] std::optional<std::vector<std::string>>
    read_line_as_tokens(std::istream& in)
    {
        auto line = std::string{};
        in >> line;
        if (!in) return std::nullopt;

        auto in_tokens = std::istringstream{line};
        auto tokens = std::vector<std::string>{};

        std::copy(std::istream_iterator<std::string>(in_tokens),
                  std::istream_iterator<std::string>{},
                  std::back_inserter(tokens));

        return std::make_optional(std::move(tokens));
    }

    Rules read_rules(std::istream& in)
    {
        auto rules = Rules{};

        while (const auto tokens = read_line_as_tokens(in)) {
            switch (size(*tokens)) {
                // FIXME: implement this
            }
        }

        return rules;
    }
}

int main()
{
    std::ios_base::sync_with_stdio(false);
}
