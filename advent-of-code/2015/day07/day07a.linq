<Query Kind="Program" />

// Advent of code 2015, day 7, part A

internal static class Program {
    private static IReadOnlyDictionary<string, Func<ushort, ushort>>
    UnaryFunctions = new Dictionary<string, Func<ushort, ushort>> {
        { "NOT", arg => (ushort)~arg }
    };
    
    private static IReadOnlyDictionary<string, Func<ushort, ushort, ushort>>
    BinaryFunctions = new Dictionary<string, Func<ushort, ushort, ushort>> {
        { "AND", (arg1, arg2) => (ushort)(arg1 & arg2) },
        { "OR", (arg1, arg2) => (ushort)(arg1 | arg2) },
        { "LSHIFT", (arg1, arg2) => (ushort)(arg1 << arg2) },
        { "RSHIFT", (arg1, arg2) => (ushort)(arg1 >> arg2) }
    };
    
    private static string[] Lex(string record)
        => record.Split(default(char[]?),
                        StringSplitOptions.RemoveEmptyEntries);
    
    private static IDictionary<string, Func<ushort>>
    GetVariables(this IEnumerable<string> lines)
    {
        var variables = default(Dictionary<string, Func<ushort>>)!; // ugly :(
    
        variables =
            lines.Select(line => line.Trim())
                 .Where(line => line.Length != 0)
                 .Select(line => line.Split(" -> "))
                 .Select(tokens => (variable: tokens[1],
                                    expression: tokens[0]))
                 .ToDictionary(binding => binding.variable,
                               binding => GetEvaluator(binding.expression));
        
        Func<ushort> GetNullaryEvaluator(string simpleExpression)
        {
            if (ushort.TryParse(simpleExpression, out var value))
                return () => value;
            
            return () => {
                var value = variables[simpleExpression]();
                variables[simpleExpression] = () => value;
                return value;
            };
        }
        
        Func<ushort> GetUnaryEvaluator(string unaryFunctionName,
                                       Func<ushort> arg)
        {
            var function = UnaryFunctions[unaryFunctionName];
            return () => function(arg());
        }
        
        Func<ushort> GetBinaryEvaluator(string binaryFunctionName,
                                        Func<ushort> arg1, Func<ushort> arg2)
        {
            var function = BinaryFunctions[binaryFunctionName];
            return () => function(arg1(), arg2());
        }
        
        Func<ushort> GetEvaluator(string expression)
        {
            var tokens = Lex(expression);
            
            return tokens.Length switch {
                1 => GetNullaryEvaluator(tokens[0]),
                
                2 => GetUnaryEvaluator(tokens[0],
                                       GetNullaryEvaluator(tokens[1])),
                
                3 => GetBinaryEvaluator(tokens[1],
                                        GetNullaryEvaluator(tokens[0]),
                                        GetNullaryEvaluator(tokens[2])),
                
                _ => throw new InvalidOperationException("malformed expression")
            };
        }
        
        return variables;
    }
    
    private static void SolveTinyExample()
    {
        var example = @"
            123 -> x
            456 -> y
            x AND y -> d
            x OR y -> e
            x LSHIFT 2 -> f
            y RSHIFT 2 -> g
            NOT x -> h
            NOT y -> i
        ";
        
        var variables = example.Split('\n').GetVariables();
        
        new[] { "d", "e", "f", "g", "h", "i", "x", "y" }
            .Select(Variable => new {
                    Variable,
                    Value = variables[Variable]()
                })
            .Dump("tiny example, showing all variables", noTotals: true);
    }
    
    private static void SolveFullProblem()
    {
        var variables = File.ReadLines("input").GetVariables();
        variables["a"]().Dump("full problem, showing the specified variable");
    }
    
    private static void Main()
    {
        SolveTinyExample();
        SolveFullProblem();
    }
}
