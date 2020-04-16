<Query Kind="Statements" />

var unaryFunctions = new Dictionary<string, Func<ushort, ushort>> {
    { "NOT", arg => (ushort)~arg }
};

var binaryFunctions = new Dictionary<string, Func<ushort, ushort, ushort>> {
    { "AND", (arg1, arg2) => (ushort)(arg1 & arg2) },
    { "OR", (arg1, arg2) => (ushort)(arg1 | arg2) },
    { "LSHIFT", (arg1, arg2) => (ushort)(arg1 << arg2) },
    { "RSHIFT", (arg1, arg2) => (ushort)(arg1 >> arg2) }
};

var variables = new Dictionary<string, Func<ushort>>();

static string[] Lex(string record)
    => record.Split(default(char[]?),
                    StringSplitOptions.RemoveEmptyEntries);


Func<ushort> GetNullaryEvaluator(string simpleExpression)
{
    if (ushort.TryParse(simpleExpression, out var value)) return () => value;
    return () => variables[simpleExpression](); // no memoization
}

Func<ushort> GetUnaryEvaluator(string unaryFunctionName, Func<ushort> arg)
{
    var function = unaryFunctions[unaryFunctionName];
    return () => function(arg());
}

Func<ushort> GetBinaryEvaluator(string binaryFunctionName,
                                Func<ushort> arg1, Func<ushort> arg2)
{
    var function = binaryFunctions[binaryFunctionName];
    return () => function(arg1(), arg2());
}

Func<ushort> GetEvaluator(string expression)
{
    var tokens = Lex(expression);
    
    return tokens.Length switch {
        1 => GetNullaryEvaluator(tokens[0]),
        
        2 => GetUnaryEvaluator(tokens[0], GetNullaryEvaluator(tokens[1])),
        
        3 => GetBinaryEvaluator(tokens[1], GetNullaryEvaluator(tokens[0]),
                                           GetNullaryEvaluator(tokens[2])),
        
        _ => throw new InvalidOperationException("malformed expression")
    };
}

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

variables =
    example.Split('\n')
           .Select(line => line.Trim())
           .Where(line => line.Length != 0)
           .Select(line => line.Split(" -> "))
           .Select(tokens => (variable: tokens[1], expression: tokens[0]))
           .ToDictionary(binding => binding.variable,
                         binding => GetEvaluator(binding.expression));

//variables.Dump(nameof(variables));

new[] { "d", "e", "f", "g", "h", "i", "x", "y" }
    .Select(Variable => new { Variable, Value = variables[Variable]() })
    .Dump("tiny example", noTotals: true);
