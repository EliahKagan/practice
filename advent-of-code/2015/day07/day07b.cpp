// Advent of code 2015, day 7, part B
// Via recursion with memoization, with no cycle checking.
// Implemented using object-oriented polymorphism.

#include <algorithm>
#include <cassert>
#include <cerrno>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <iterator>
#include <memory>
#include <optional>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
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

        // Not [[nodiscard]] as, in the case of Variable, it might be called
        // just to trigger memoization.
        virtual unsigned
        evaluate(const Rules& rules, Memo& memo) const noexcept = 0;

    protected:
        constexpr Expression() noexcept = default;
    };

    class Constant final : public Expression {
    public:
        explicit constexpr Constant(const unsigned value) noexcept
            : value_{value}
        {
        }

        [[nodiscard]] unsigned
        evaluate(const Rules&, Memo&) const noexcept override
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

        // Not [[nodiscard]] as it might be called just to trigger memoization.
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

        [[nodiscard]] unsigned
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

        [[nodiscard]] unsigned
        evaluate(const Rules &rules, Memo &memo) const noexcept override
        {
            return arg1_->evaluate(rules, memo) & arg2_->evaluate(rules, memo);
        }
    };

    class Alternation : public BinaryExpression { // a.k.a. disjunction
        using BinaryExpression::BinaryExpression;

        [[nodiscard]] unsigned
        evaluate(const Rules &rules, Memo &memo) const noexcept override
        {
            return arg1_->evaluate(rules, memo) | arg2_->evaluate(rules, memo);
        }
    };

    class LeftShift : public BinaryExpression {
        using BinaryExpression::BinaryExpression;

        [[nodiscard]] unsigned
        evaluate(const Rules &rules, Memo &memo) const noexcept override
        {
            return (arg1_->evaluate(rules, memo)
                 << arg2_->evaluate(rules, memo)) & mask;
        }
    };

    class RightShift : public BinaryExpression {
        using BinaryExpression::BinaryExpression;

        [[nodiscard]] unsigned
        evaluate(const Rules &rules, Memo &memo) const noexcept override
        {
            return arg1_->evaluate(rules, memo)
                >> arg2_->evaluate(rules, memo);
        }
    };

    class MalformedRule : public std::runtime_error {
    public:
        using runtime_error::runtime_error;
    };

    class MalformedTerm : public MalformedRule {
    public:
        using MalformedRule::MalformedRule;
    };

    class UnrecognizedOperation : public MalformedRule {
        using MalformedRule::MalformedRule;
    };

    // Converts text to a variable or constant.
    [[nodiscard]] Expr make_nullary(std::string term)
    {
        auto in_term = std::istringstream{term};
        auto value = unsigned{};

        if (!(in_term >> value))
            return std::make_unique<const Variable>(std::move(term));

        if ((in_term >> std::ws).eof())
            return std::make_unique<const Constant>(value);

        throw MalformedTerm{"term is neither a variable nor a constant"};
    }

    [[nodiscard]] Expr
    make_unary(const std::string operation, const std::string term)
    {
        auto arg = make_nullary(term);

        if (operation == "NOT")
            return std::make_unique<const Negation>(std::move(arg));

        throw UnrecognizedOperation{"unrecognized unary operation"};
    }

    [[nodiscard]] Expr
    make_binary(const std::string operation,
                const std::string term1, const std::string term2)
    {
        auto arg1 = make_nullary(term1);
        auto arg2 = make_nullary(term2);

        if (operation == "AND") {
            return std::make_unique<const Conjunction>(std::move(arg1),
                                                       std::move(arg2));
        }

        if (operation == "OR") {
            return std::make_unique<const Alternation>(std::move(arg1),
                                                       std::move(arg2));
        }

        if (operation == "LSHIFT") {
            return std::make_unique<const LeftShift>(std::move(arg1),
                                                     std::move(arg2));
        }

        if (operation == "RSHIFT") {
            return std::make_unique<const RightShift>(std::move(arg1),
                                                      std::move(arg2));
        }

        throw UnrecognizedOperation{"unrecognized binary operation"};
    }

    [[nodiscard]] Expr
    extract_expression(const std::vector<std::string>& tokens)
    {
        if (size(tokens) < 3)
            throw MalformedRule{"record too small to specify rule"};

        if (tokens[size(tokens) - 2] != "->")
            throw MalformedRule{"rule does not have the expected \"->\""};

        switch (size(tokens) - 2) {
        case 1:
            return make_nullary(tokens[0]);

        case 2:
            return make_unary(tokens[0], tokens[1]);

        case 3:
            return make_binary(tokens[1], tokens[0], tokens[2]); // infix

        default:
            throw MalformedRule{"record too big to specify rule"};
        }
    }

    [[nodiscard]] std::optional<std::vector<std::string>>
    read_line_as_tokens(std::istream& in)
    {
        auto line = std::string{};
        if (!getline(in, line)) return std::nullopt;

        auto in_tokens = std::istringstream{line};
        auto tokens = std::vector<std::string>{};

        std::copy(std::istream_iterator<std::string>(in_tokens),
                  std::istream_iterator<std::string>{},
                  std::back_inserter(tokens));

        return std::make_optional(std::move(tokens));
    }

    void add_rule(Rules& rules, const std::vector<std::string>& tokens)
    {
        auto expr = extract_expression(tokens);
        assert(!empty(tokens)); // Or extract_expression() would have thrown.
        rules.emplace(tokens.back(), std::move(expr));
    }

    [[nodiscard]] Rules read_rules(std::istream& in)
    {
        auto rules = Rules{};

        while (const auto maybe_tokens = read_line_as_tokens(in)) {
            if (!empty(*maybe_tokens))
                add_rule(rules, *maybe_tokens);
        }

        return rules;
    }

    class Solver {
    public:
        explicit Solver(Rules rules) noexcept : rules_(std::move(rules)) { }

        explicit Solver(std::istream& in) : Solver{read_rules(in)} { }

        [[nodiscard]] unsigned operator()(std::string name)
        {
            return Variable{std::move(name)}.evaluate(rules_, memo_);
        }

        void override_rule(const std::string name, const unsigned value)
        {
            assert(empty(memo_)); // Rule changes must precede any evaluations.
            rules_.at(name) = std::make_unique<const Constant>(value);
        }

    private:
        Rules rules_;
        Memo memo_ {};
    };

    void solve_example()
    {
        auto in = std::istringstream{R"(
            123 -> x
            456 -> y
            x AND y -> d
            x OR y -> e
            x LSHIFT 2 -> f
            y RSHIFT 2 -> g
            NOT x -> h
            NOT y -> i
        )"};

        auto solver = Solver{in};

        for (const auto name : {"d", "e", "f", "g", "h", "i", "x", "y"})
            std::cout << name << ": " << solver(name) << '\n';
    }

    void solve_from_file_with_rewire(const std::string path,
                                     const std::string target_variable,
                                     const std::string rewrite_variable,
                                     const unsigned rewrite_value)
    {
        auto solver = [&path]() {
            std::ifstream in;
            in.exceptions(std::ios_base::badbit | std::ios_base::failbit);
            in.open(path);
            in.exceptions(std::ios_base::badbit);

            return Solver{in};
        }();

        solver.override_rule(rewrite_variable, rewrite_value);
        std::cout << solver(target_variable) << '\n';
    }

    std::string_view program_name;

    [[noreturn]] void die(const std::string_view message) noexcept
    {
        std::cerr << program_name << ": error: " << message << '\n';
        std::exit(EXIT_FAILURE);
    }
}

int main(int argc, char **argv)
{
    std::ios_base::sync_with_stdio(false);
    assert(argc > 0);
    program_name = argv[0];

    try {
        switch (argc) {
        case 1:
            std::cout << "No filenames given. Solving example.\n";
            solve_example();
            break;

        case 2:
            {
                static constexpr auto b_value = 16'076u; // Output from day07a.
                solve_from_file_with_rewire(argv[1], "a", "b", b_value);
            }
            break;

        default:
            die("too many arguments");
        }
    } catch (const MalformedRule& e) {
        die(e.what());
    } catch (const std::ios_base::failure&) {
        die(std::strerror(errno));
    }
}
