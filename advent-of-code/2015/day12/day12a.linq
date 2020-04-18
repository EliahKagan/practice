<Query Kind="Statements">
  <Namespace>System.Text.Json</Namespace>
</Query>

// Advent of Code 2015, day 12, part A

static IEnumerable<int> EnumerateAllNumbers(JsonElement parent)
{
    switch (parent.ValueKind) {
    case JsonValueKind.Array:
        foreach (var element in parent.EnumerateArray()) {
            foreach (var number in EnumerateAllNumbers(element))
                yield return number;
        }
        break;
    
    case JsonValueKind.Object:
        foreach (var property in parent.EnumerateObject()) {
            foreach (var number in EnumerateAllNumbers(property.Value))
                yield return number;
        }
        break;
    
    case JsonValueKind.Number:
        yield return parent.GetInt32();
        break;
    
    default:
        break; // Ignore other kinds of elements.
    }
}

static void Solve(string label, string json)
{
    using var doc = JsonDocument.Parse(json);
    
    EnumerateAllNumbers(doc.RootElement)
        .Sum()
        .Dump(label);
}

var tests = new[] {
    "[1,2,3]",
    "{\"a\":2,\"b\":4}",
    "[[[3]]]",
    "{\"a\":{\"b\":4},\"c\":-1}",
    "{\"a\":[-1,1]}",
    "[-1,{\"a\":1}]",
    "[]",
    "{}"
};

foreach (var test in tests)
    Solve(label: $"Test: {test}", json: test);

Console.WriteLine();

foreach (var input in new[] {
            new { Path = "input", Comment = "minified" },
            new { Path = "input.json", Comment = "de-minified" }
        }) {
    Solve(label: $"PROBLEM INPUT ({input.Comment})",
           json: File.ReadAllText(input.Path));
}
