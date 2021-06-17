<Query Kind="Program" />

// LeetCode #1896 - Minimum Cost to Change the Final Value of Expression scratchwork
// https://leetcode.com/problems/minimum-cost-to-change-the-final-value-of-expression/

#nullable disable

public class Solution {
    public int MinOperationsToFlip(string expression)
    {
        var rpn = ToReversePolish(expression);

        return EvaluateBoolean(rpn) switch {
            0 => EvaluateDistanceToTrue(rpn),

            1 => EvaluateDistanceToFalse(rpn),

            _ => throw new ArgumentException(
                    paramName: nameof(expression),
                    message: "truth value not 0 or 1 (this is a bug)"),
        };
    }

    /// <summary>
    /// Converts a sequence of infix notation tokens to postfix notation.
    /// </summary>
    /// <remarks>
    /// Informally speaking, this is "reverse Polish notation," but I'm not
    /// using Łukasiewicz's letter symbols (e.g. "K" for "&").
    /// </remarks>
    private static string ToReversePolish(IEnumerable<char> infixTokens)
    {
        static void Throw(string message)
            => throw new ArgumentException(nameof(infixTokens), message);

        IEnumerable<char> ShuntingYard()
        {
            var stack = new Stack<char>(); // operators/punctuators

            foreach (var token in infixTokens) {
                if (IsValue(token)) {
                    yield return token;
                } else if (IsOperator(token)) {
                    while (stack.Count != 0 && IsOperator(stack.Peek()))
                        yield return stack.Pop();

                    stack.Push(token);
                } else if (token == '(') {
                    stack.Push(token);
                } else if (token == ')') {
                    while (stack.Count != 0 && stack.Peek() != '(')
                        yield return stack.Pop();

                    if (stack.Count == 0) Throw("Unmatched \")\"");
                    stack.Pop();
                } else {
                    Throw($"Unrecognized infix token \"{token}\"");
                }
            }

            while (stack.Count != 0) {
                if (stack.Peek() == '(') Throw("Unmatched \"(\"");
                yield return stack.Pop();
            }
        }

        return string.Join(string.Empty, ShuntingYard());
    }

    private static bool IsValue(char token) => token == '0' || token == '1';

    private static bool IsOperator(char token) => token == '&' || token == '|';

    private static int EvaluateBoolean(IEnumerable<char> rpn)
        => Evaluate(rpn, conj: (p, q) => p & q, disj: (p, q) => p | q);

    private static int EvaluateDistanceToTrue(IEnumerable<char> rpn)
        => EvaluateDistanceToFalse(GetDual(rpn));

    private static int EvaluateDistanceToFalse(IEnumerable<char> rpn)
        => Evaluate(rpn,
                    conj: (p, q) => Math.Min(p, q),
                    disj: (p, q) => Math.Min(p + q, Math.Min(p, q) + 1));

    private static int Evaluate(IEnumerable<char> rpn,
                                Func<int, int, int> conj,
                                Func<int, int, int> disj)
    {
        static void Throw(string message)
            => throw new ArgumentException(nameof(rpn), message);

        int? TryGetOperand(char token) => token switch {
            '0' => 0,
            '1' => 1,
            _   => null,
        };

        Func<int, int, int> TryGetOperator(char token) => token switch {
            '&' => conj,
            '|' => disj,
            _   => null,
        };

        var stack = new Stack<int>(); // operands

        foreach (var token in rpn) {
            if (TryGetOperand(token) is int operand) {
                stack.Push(operand);
            } else if (TryGetOperator(token) is Func<int, int, int> func) {
                if (stack.Count < 2) Throw("Too few operands");

                var second = stack.Pop();
                var first = stack.Pop();
                stack.Push(func(first, second));
            } else {
                Throw($"Unrecognized RPN token\"{token}\"");
            }
        }

        if (stack.Count != 1) Throw("Too few operators");
        return stack.Pop();
    }

    private static IEnumerable<char> GetDual(IEnumerable<char> rpn)
        => from token in rpn select token switch {
            '0' => '1',
            '1' => '0',
            '&' => '|',
            '|' => '&',
            _   => throw new ArgumentException(
                    paramName: nameof(rpn),
                    message: $"Unrecognized RPN token \"{token}\""),
        };

    /// <summary>Entry point for testing.</summary>
    private static void Main()
    {
        var s = new Solution();

        void Test(string expression)
            => new {
                Infix = expression,
                PRN = ToReversePolish(expression),
                Result = s.MinOperationsToFlip(expression),
            }.Dump();

        Test("1&(0|1)");
        Test("(0&0)&(0&0&0)");
        Test("(0|(1|0&1))");
        Test("0&0|0&0|0");
        Test("0|0&0|0&0");
    }
}
