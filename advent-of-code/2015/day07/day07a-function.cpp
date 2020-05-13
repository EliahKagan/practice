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

    // Function objects that take no arguments and may hold state.
    using NullaryFunction = std::function<unsigned()>;

    // Function objects that take one or two arguments and hold no state.
    using UnaryFunction = unsigned (*)(unsigned) noexcept;
    using BinaryFunction = unsigned (*)(unsigned, unsigned) noexcept;

    const auto unary_functions
            = std::unordered_map<std::string_view, UnaryFunction>{
        { "NOT"sv, [](const unsigned arg) noexcept { return ~arg & mask; } }
    };

    const auto binary_functions
            = std::unordered_map<std::string_view, BinaryFunction>{
        { "AND"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                        { return arg1 & arg2; } },
        { "OR"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                        { return arg1 | arg2; } },
        { "LSHIFT"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                        { return (arg1 << arg2) & mask; } },
        { "RSHIFT"sv, [](const unsigned arg1, const unsigned arg2) noexcept
                        { return arg1 >> arg2; } }
    };

    // FIXME: When an unrecognized operation (not one of the keys in the above
    // maps) is supplied, throw a custom exception type that wraps its name and
    // arity. Have the calling code catch it and generate a useful message.
    // Also "backport" this change to the other day07 implementations.

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
        Scope() = default;
        Scope(const Scope&) = delete;
        Scope(Scope&&) = default;
        Scope& operator=(const Scope&) = delete;
        Scope& operator=(Scope&&) & = default;
        ~Scope() = default;

        void add_binding(std::string name, const std::string& expression);

    private:
        [[nodiscard]] NullaryFunction
        make_evaluator(const std::string& expression);

        [[nodiscard]] NullaryFunction
        make_nullary_evaluator(std::string simple_expression);

        [[nodiscard]] NullaryFunction
        make_variable_evaluator(std::string name) noexcept;

        [[nodiscard]] NullaryFunction
        static make_literal_evaluator(const unsigned value) noexcept
        {
            return [value]() noexcept { return value; };
        }

        [[nodiscard]] NullaryFunction
        make_unary_evaluator(std::string_view unary_function_name,
                             NullaryFunction arg_supplier);

        [[nodiscard]] NullaryFunction
        make_binary_evaluator(std::string_view binary_function_name,
                              NullaryFunction arg1_supplier,
                              NullaryFunction arg2_supplier);

        std::unordered_map<std::string, NullaryFunction> variables_ {};
    };

    void Scope::add_binding(std::string name, const std::string &expression)
    {
        variables_.emplace(std::move(name), make_evaluator(expression));
    }

    NullaryFunction
    Scope::make_evaluator(const std::string& expression)
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
    Scope::make_nullary_evaluator(std::string simple_expression)
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
                                NullaryFunction arg_supplier)
    {
        return [operation = unary_functions.at(unary_function_name),
                arg_supplier = std::move(arg_supplier)]() noexcept {
            return operation(arg_supplier());
        };
    }

    inline NullaryFunction
    Scope::make_binary_evaluator(const std::string_view binary_function_name,
                                 NullaryFunction arg1_supplier,
                                 NullaryFunction arg2_supplier)
    {
        return [operation = binary_functions.at(binary_function_name),
                arg1_supplier = std::move(arg1_supplier),
                arg2_supplier = std::move(arg2_supplier)]() noexcept {
            return operation(arg1_supplier(), arg2_supplier());
        };
    }

    Scope build_scope_from_bindings(std::istream& in)
    {
        static const auto pattern = std::regex{R"((.+)\s->\s(.+))"};

        auto scope = Scope{};

        for (auto line = std::string{}; std::getline(in >> std::ws, line); ) {
            if (empty(line)) continue;


        }

        return scope;
    }
}

int main()
{
    //
}
