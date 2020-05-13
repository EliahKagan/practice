// Advent of code 2015, day 7, part A
// Via recursion with memoization, with no cycle checking.
// Implemented with a single table of function objects using type erasure.
// This is like the C# version day07a.linq, but in C++ with std::function.

#include <algorithm>
#include <cassert>
#include <cerrno>
#include <cstdlib>
#include <cstring>
#include <functional>
#include <iostream>
#include <iterator>
#include <regex>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <unordered_map>
#include <utility>
#include <vector>

namespace {
    using namespace std::string_view_literals;

    constexpr auto mask = 65'535u;

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
        using MalformedBinding::MalformedBinding; // Pass unrecognized name.
    };

    // Function objects that take no arguments and may hold state.
    using Thunk = std::function<unsigned()>;

    // Function objects that take one or two arguments and hold no state.
    using UnaryOperation = unsigned (*)(unsigned) noexcept;
    using BinaryOperation = unsigned (*)(unsigned, unsigned) noexcept;

    template<typename Function>
    using Operations = std::unordered_map<std::string_view, Function>;

    template<typename Function>
    constexpr auto operations = 0;

    template<>
    const auto operations<UnaryOperation> = Operations<UnaryOperation> {
        { "NOT"sv, [](const unsigned arg) noexcept { return ~arg & mask; } }
    };

    template<>
    const auto operations<BinaryOperation> = Operations<BinaryOperation> {
        { "AND"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                        { return arg1 & arg2; } },
        { "OR"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                        { return arg1 | arg2; } },
        { "LSHIFT"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                        { return (arg1 << arg2) & mask; } },
        { "RSHIFT"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                        { return arg1 >> arg2; } }
    };

    template<typename Function>
    Function get_operation(const std::string_view operation_name)
    {
        try {
            return operations<Function>.at(operation_name);
        } catch (const std::out_of_range&) {
            throw UnrecognizedOperation<Function>{std::string{operation_name}};
        }
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

    // FIXME: Is it really worth the confusion of taking some std::string
    //        parameters by value and others by reference?
    class Scope {
    public:
        Scope() = default;
        Scope(const Scope&) = delete;
        Scope(Scope&&) = default;
        Scope& operator=(const Scope&) = delete;
        Scope& operator=(Scope&&) & = default;
        ~Scope() = default;

        void add_binding(std::string name, const std::string& expression)
        {
            variables_.emplace(std::move(name), make_evaluator(expression));
        }

        unsigned evaluate(const std::string& variable_name) noexcept
        {
            return variables_.at(variable_name)();
        }

    private:
        [[nodiscard]] Thunk make_evaluator(const std::string& expression);

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

        std::unordered_map<std::string, Thunk> variables_ {};
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
        return [name = std::move(name),
                &variables = variables_]() noexcept {
            auto &entry = variables.at(name);
            const auto value = entry();
            entry = make_literal_evaluator(value);
            // const auto value = variables.at(name)();
            // variables.at(name) = make_literal_evaluator(value);
            return value;
        };
    }

    inline Thunk
    Scope::make_unary_evaluator(const std::string_view unary_operation_name,
                                Thunk arg_supplier)
    {
        return [operation =
                    get_operation<UnaryOperation>(unary_operation_name),
                arg_supplier = std::move(arg_supplier)]() noexcept {
            return operation(arg_supplier());
        };
    }

    inline Thunk
    Scope::make_binary_evaluator(const std::string_view binary_operation_name,
                                 Thunk arg1_supplier, Thunk arg2_supplier)
    {
        return [operation =
                    get_operation<BinaryOperation>(binary_operation_name),
                arg1_supplier = std::move(arg1_supplier),
                arg2_supplier = std::move(arg2_supplier)]() noexcept {
            return operation(arg1_supplier(), arg2_supplier());
        };
    }

    Scope build_scope_from_bindings(std::istream& in)
    {
        static const auto pattern = std::regex{R"((.+)\s->\s+(.*\S)\s*)"};

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
}

int main()
{
    solve_example();
}
