// Advent of code 2015, day 7, part A
// Via recursion with memoization, with no cycle checking.
// Implemented with a single table of function objects using type erasure.
// This is like the C# version day07a.linq, but in C++ with std::function.

#include <algorithm>
#include <cassert>
#include <cerrno>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <functional>
#include <iostream>
#include <iterator>
#include <memory>
#include <regex>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <unordered_map>
#include <utility>
#include <vector>

namespace {
    using namespace std::literals;

    constexpr auto mask = 65'535u;

    // Function objects that take no arguments and may hold state.
    using Thunk = std::function<unsigned()>;

    // Function objects that take one or two arguments and hold no state.
    using UnaryOperation = unsigned (*)(unsigned) noexcept;
    using BinaryOperation = unsigned (*)(unsigned, unsigned) noexcept;

    class MalformedBinding : public std::runtime_error {
    public:
        using runtime_error::runtime_error;
    };

    class MalformedTerm : public MalformedBinding {
    public:
        using MalformedBinding::MalformedBinding;
    };

    template<typename Function>
    class UnrecognizedOperation : public MalformedBinding {
    public:
        explicit
        UnrecognizedOperation(const std::string_view operation_name) noexcept
            : MalformedBinding{build_message(operation_name)} { }

    private:
        [[nodiscard]] static std::string
        build_message(std::string_view operation_name) noexcept;

        [[nodiscard]] static constexpr std::string_view
        arity_adjective() noexcept;
    };

    template<typename Function>
    std::string UnrecognizedOperation<Function>::build_message(
            const std::string_view operation_name) noexcept
    {
        auto out = std::ostringstream{};

        out << "unrecognized " << arity_adjective() << " operation \""
            << operation_name << '"';

        return out.str();
    }

    template<>
    [[nodiscard]] constexpr std::string_view
    UnrecognizedOperation<UnaryOperation>::arity_adjective() noexcept
    {
        return "unary"sv;
    }

    template<>
    [[nodiscard]] constexpr std::string_view
    UnrecognizedOperation<BinaryOperation>::arity_adjective() noexcept
    {
        return "binary"sv;
    }

    template<typename Function,
             typename Map = std::unordered_map<std::string_view, Function>>
    class Operations {
    public:
        Operations(const std::initializer_list<typename Map::value_type> ilist)
                noexcept
            : table_(ilist) { }

        [[nodiscard]] Function
        operator[](const std::string_view operation_name) const
        {
            try {
                return table_.at(operation_name);
            } catch (const std::out_of_range&) {
                throw UnrecognizedOperation<Function>{operation_name};
            }
        }

    private:
        Map table_ {};
    };

    Operations<UnaryOperation> get_unary_operations() noexcept
    {
        return {
            { "NOT"sv, [](const unsigned arg) noexcept
                        { return ~arg & mask; } }
        };
    }

    Operations<BinaryOperation> get_binary_operations() noexcept
    {
        return {
            { "AND"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                            { return arg1 & arg2; } },
            { "OR"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                            { return arg1 | arg2; } },
            { "LSHIFT"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                            { return (arg1 << arg2) & mask; } },
            { "RSHIFT"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                            { return arg1 >> arg2; } }
        };
    }

    [[nodiscard]] std::vector<std::string>
    lex(const std::string& expression) noexcept
    {
        auto tokens = std::vector<std::string>{};
        auto in = std::istringstream{expression};

        std::copy(std::istream_iterator<std::string>{in},
                  std::istream_iterator<std::string>{},
                  std::back_inserter(tokens));

        return tokens;
    }

    class Scope {
    public:
        Scope() noexcept
            : Scope{get_unary_operations(), get_binary_operations()} { }

        Scope(Operations<UnaryOperation> unary_operations,
              Operations<BinaryOperation> binary_operations) noexcept
            : unary_operations_(std::move(unary_operations)),
              binary_operations_(std::move(binary_operations)) { }

        Scope(const Scope&) = delete;
        Scope(Scope&&) = default;
        Scope& operator=(const Scope&) = delete;
        [[maybe_unused]] Scope& operator=(Scope&&) & = default;
        ~Scope() = default;

        void add_binding(std::string name, const std::string& expression)
        {
            variables_->emplace(std::move(name), make_evaluator(expression));
        }

        // Evaluates the given variable. Throws std::out_of_range on failure.
        unsigned evaluate(const std::string& variable_name)
        {
            return variables_->at(variable_name)();
        }

    private:
        using Variables = std::unordered_map<std::string, Thunk>;

        [[nodiscard]] Thunk make_evaluator(const std::string &expression);

        [[nodiscard]] Thunk
        make_nullary_evaluator(std::string simple_expression);

        [[nodiscard]] Thunk make_variable_evaluator(std::string name) noexcept;

        [[nodiscard]] Thunk
        static make_literal_evaluator(const unsigned value) noexcept
        {
            return [value]() noexcept { return value; };
        }

        [[nodiscard]] Thunk
        make_unary_evaluator(std::string_view unary_operation_name,
                             Thunk arg_supplier);

        [[nodiscard]] Thunk
        make_binary_evaluator(std::string_view binary_operation_name,
                              Thunk arg1_supplier,
                              Thunk arg2_supplier);

        Operations<UnaryOperation> unary_operations_;
        Operations<BinaryOperation> binary_operations_;
        std::unique_ptr<Variables> variables_ = std::make_unique<Variables>();
    };

    Thunk Scope::make_evaluator(const std::string& expression)
    {
        const auto tokens = lex(expression);
        assert(!empty(tokens));

        switch (size(tokens)) {
        case 1:
            return make_nullary_evaluator(tokens[0]);

        case 2:
            return make_unary_evaluator(tokens[0],
                                        make_nullary_evaluator(tokens[1]));

        case 3:
            return make_binary_evaluator(tokens[1], // infix
                                         make_nullary_evaluator(tokens[0]),
                                         make_nullary_evaluator(tokens[2]));

        default:
            throw MalformedBinding{"too many tokens in expression"};
        }
    }

    Thunk Scope::make_nullary_evaluator(std::string simple_expression)
    {
        assert(!empty(simple_expression));

        auto in = std::istringstream{simple_expression};
        auto literal_value = unsigned{};

        if (!(in >> literal_value))
            return make_variable_evaluator(std::move(simple_expression));

        if ((in >> std::ws).eof())
            return make_literal_evaluator(literal_value);

        throw MalformedTerm{"term is neither a variable nor a constant"};
    }

    inline Thunk Scope::make_variable_evaluator(std::string name) noexcept
    {
        return [name = std::move(name), &variables = *variables_]() {
            auto &entry = variables.at(name);
            const auto value = entry();
            entry = make_literal_evaluator(value);
            return value;
        };
    }

    inline Thunk
    Scope::make_unary_evaluator(const std::string_view unary_operation_name,
                                Thunk arg_supplier)
    {
        return [operation = unary_operations_[unary_operation_name],
                arg_supplier = std::move(arg_supplier)]() {
            return operation(arg_supplier());
        };
    }

    inline Thunk
    Scope::make_binary_evaluator(const std::string_view binary_operation_name,
                                 Thunk arg1_supplier, Thunk arg2_supplier)
    {
        return [operation = binary_operations_[binary_operation_name],
                arg1_supplier = std::move(arg1_supplier),
                arg2_supplier = std::move(arg2_supplier)]() {
            return operation(arg1_supplier(), arg2_supplier());
        };
    }

    [[nodiscard]] Scope build_scope_from_bindings(std::istream& in)
    {
        const auto pattern = std::regex{R"((.+)\s->\s+(.*\S)\s*)"};

        auto scope = Scope{};

        for (auto line = std::string{}; std::getline(in >> std::ws, line); ) {
            if (empty(line)) continue;

            auto match = std::smatch{};

            if (!std::regex_match(line, match, pattern))
                throw MalformedBinding{"binding not in expected format"};

            scope.add_binding(match.str(2), match.str(1));
        }

        return scope;
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

        auto scope = build_scope_from_bindings(in);

        for (const auto name : {"d", "e", "f", "g", "h", "i", "x", "y"})
            std::cout << name << ": " << scope.evaluate(name) << '\n';
    }

    void solve_from_file(const std::string path,
                         const std::string variable_name)
    {
        auto scope = [&path]() {
            std::ifstream in;
            in.exceptions(std::ios_base::badbit | std::ios_base::failbit);
            in.open(path);
            in.exceptions(std::ios_base::badbit);

            return build_scope_from_bindings(in);
        }();

        std::cout << scope.evaluate(variable_name) << '\n';
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
            solve_from_file(argv[1], "a");
            break;

        default:
            die("too many arguments");
        }
    } catch (const std::ios_base::failure&) {
        die(std::strerror(errno));
    } catch (const MalformedBinding& e) {
        die(e.what());
    } catch (const std::out_of_range&) {
        // TODO: Print a detailed message.
        die("target variable unreachable or absent");
    }
}
