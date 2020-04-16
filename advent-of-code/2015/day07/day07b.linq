<Query Kind="Program" />

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
    
    private static void Main()
    {
        const ushort b = 16076; // Output of day07a.linq.
        
        var variables =
            File.ReadLines("input")
                .Where(line => !line.EndsWith("-> b"))
                .Append($"{b} -> b")
                .GetVariables();
        
        variables["a"]()
            .Dump("full problem, showing the specified variable's new value");
    }
}
