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
#include <iterator>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <unordered_map>
#include <utility>
#include <vector>

namespace {
    constexpr auto mask = 65'535u;

    // Function objects that take no arguments and may hold state.
    using NullaryFunction = std::function<unsigned()>;

    // Function objects that take one or two arguments and hold no state.
    using UnaryFunction = unsigned (*)(unsigned) noexcept;
    using BinaryFunction = unsigned (*)(unsigned, unsigned) noexcept;

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

    class MalformedBinding : public std::runtime_error {
    public:
        using runtime_error::runtime_error;
    };

    class MalformedTerm : public MalformedBinding {
    public:
        using MalformedBinding::MalformedBinding;
    };

    class UnrecognizedOperation : public MalformedBinding {
        using MalformedBinding::MalformedBinding;
    };

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
        Scope() noexcept = default;
        Scope(const Scope& other) noexcept = delete;
        Scope(Scope&& other) noexcept = default;
        Scope& operator=(const Scope& other) = delete;
        Scope& operator=(Scope&& other) & noexcept = default;
        ~Scope() = default;

        void add_binding(std::string_view binding) noexcept;

    private:
        [[nodiscard]] NullaryFunction
        make_evaluator(const std::string& expression) noexcept;

        [[nodiscard]] NullaryFunction
        make_nullary_evaluator(std::string simple_expression) noexcept;

        [[nodiscard]] NullaryFunction
        make_variable_evaluator(std::string name) noexcept;

        [[nodiscard]] NullaryFunction
        static make_literal_evaluator(const unsigned value) noexcept
        {
            return [value]() noexcept { return value; };
        }

        [[nodiscard]] NullaryFunction
        make_unary_evaluator(std::string_view unary_function_name,
                             NullaryFunction arg_supplier) noexcept;

        [[nodiscard]] NullaryFunction
        make_binary_evaluator(std::string_view binary_function_name,
                              NullaryFunction arg1_supplier,
                              NullaryFunction arg2_supplier) noexcept;

        std::unordered_map<std::string, NullaryFunction> variables_ {};
    };

    NullaryFunction
    Scope::make_evaluator(const std::string& expression) noexcept
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

    NullaryFunction
    Scope::make_nullary_evaluator(std::string simple_expression) noexcept
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

    inline NullaryFunction
    Scope::make_variable_evaluator(std::string name) noexcept
    {
        return [name = std::move(name),
                &variables = variables_]() noexcept {
            auto &entry = variables.at(name);
            const auto value = entry();
            entry = make_literal_evaluator(value);
            return value;
        };
    }

    inline NullaryFunction
    Scope::make_unary_evaluator(const std::string_view unary_function_name,
                                NullaryFunction arg_supplier) noexcept
    {
        return [operation = unary_functions.at(unary_function_name),
                arg_supplier = std::move(arg_supplier)]() noexcept {
            return operation(arg_supplier());
        };
    }

    inline NullaryFunction
    Scope::make_binary_evaluator(const std::string_view binary_function_name,
                                 NullaryFunction arg1_supplier,
                                 NullaryFunction arg2_supplier) noexcept
    {
        return [operation = binary_functions.at(binary_function_name),
                arg1_supplier = std::move(arg1_supplier),
                arg2_supplier = std::move(arg2_supplier)]() noexcept {
            return operation(arg1_supplier(), arg2_supplier());
        };
    }
}

int main()
{
    //
}
