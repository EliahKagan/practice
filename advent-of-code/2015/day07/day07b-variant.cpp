// Advent of code 2015, day 7, part B
// Via recursion with memoization, with no cycle checking.
// Implemented using bounded (discriminated-union) polymorphism (std::variant).

#include <cassert>
#include <cerrno>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <functional>
#include <iostream>
#include <iterator>
#include <optional>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <type_traits>
#include <unordered_map>
#include <utility>
#include <variant>
#include <vector>

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
    class BinaryExpression {
    public:
        explicit BinaryExpression(Term given_arg1, Term given_arg2)
            : arg1{std::move(given_arg1)}, arg2{std::move(given_arg2)}
        {
        }

        BinaryFunction operation {};
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
        operator()(const Expression& expression) const noexcept
        {
            return std::visit(*this, expression);
        }

        [[nodiscard]] unsigned
        operator()(const Term& constant_or_variable) const noexcept
        {
            return std::visit(*this, constant_or_variable);
        }

        [[nodiscard]] constexpr unsigned
        operator()(const Constant constant) const noexcept
        {
            return constant.value;
        }

        // Not [[nodiscard]] as it might be called just to trigger memoization.
        unsigned operator()(const Variable& variable) const noexcept;

        template<typename UnaryFunction>
        [[nodiscard]] unsigned
        operator()(const UnaryExpression<UnaryFunction>& unary) const noexcept
        {
            return unary.operation((*this)(unary.arg));
        }

        template<typename BinaryFunction>
        [[nodiscard]] unsigned
        operator()(const BinaryExpression<BinaryFunction>& binary)
                const noexcept
        {
            return binary.operation((*this)(binary.arg1),
                                    (*this)(binary.arg2));
        }

    private:
        const Rules& rules_;
        Memo& memo_;
    };

    unsigned Evaluator::operator()(const Variable &variable) const noexcept
    {
        if (auto p = memo_.find(variable.name); p != end(memo_))
            return p->second;

        const auto value = (*this)(rules_.at(variable.name));
        memo_.emplace(variable.name, value);
        return value;
    }

    // Like Evaluator, but owning instead of non-owning.
    class Solver {
    public:
        explicit Solver(Rules rules) noexcept
            : rules_(std::move(rules)), evaluator_{rules_, memo_} { }

        [[nodiscard]] unsigned operator()(std::string name) noexcept
        {
            return evaluator_(Variable{std::move(name)});
        }

    private:
        Rules rules_;
        Memo memo_ {};
        Evaluator evaluator_;
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
    [[nodiscard]] Term make_term(std::string term)
    {
        auto in_term = std::istringstream{term};
        auto value = unsigned{};

        if (!(in_term >> value))
            return Variable{std::move(term)};

        if ((in_term >> std::ws).eof())
            return Constant{value};

        throw MalformedTerm{"term is neither a variable nor a constant"};
    }

    [[nodiscard]] Expression
    make_unary(const std::string operation, const std::string term)
    {
        auto arg = make_term(term);

        if (operation == "NOT")
            return Negation{std::move(arg)};

        throw UnrecognizedOperation{"unrecognized unary operation"};
    }

    [[nodiscard]] Expression
    make_binary(const std::string operation,
                const std::string term1, const std::string term2)
    {
        auto arg1 = make_term(term1);
        auto arg2 = make_term(term2);

        if (operation == "AND")
            return Conjunction{std::move(arg1), std::move(arg2)};

        if (operation == "OR")
            return Alternation{std::move(arg1), std::move(arg2)};

        if (operation == "LSHIFT")
            return LeftShift{std::move(arg1), std::move(arg2)};

        if (operation == "RSHIFT")
            return RightShift{std::move(arg1), std::move(arg2)};

        throw UnrecognizedOperation{"unrecognized binary operation"};
    }

    [[nodiscard]] Expression
    extract_expression(const std::vector<std::string>& tokens)
    {
        if (size(tokens) < 3)
            throw MalformedRule{"record too small to specify rule"};

        if (tokens[size(tokens) - 2] != "->")
            throw MalformedRule{"rule does not have the expected \"->\""};

        switch (size(tokens) - 2) {
        case 1:
            return make_term(tokens[0]);

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

        auto solver = Solver{read_rules(in)};

        for (const auto name : {"d", "e", "f", "g", "h", "i", "x", "y"})
            std::cout << name << ": " << solver(name) << '\n';
    }

    void solve_from_file_with_rewire(const std::string path,
                                     const std::string target_variable,
                                     const std::string rewrite_variable,
                                     const unsigned rewrite_value)
    {
        const auto get_rules = [=, &path]() {
            std::ifstream in;
            in.exceptions(std::ios_base::badbit | std::ios_base::failbit);
            in.open(path);
            in.exceptions(std::ios_base::badbit);

            auto rules = read_rules(in);
            rules.at(rewrite_variable) = Constant{rewrite_value};
            return rules;
        };

        std::cout << Solver{get_rules()}(target_variable) << '\n';
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
