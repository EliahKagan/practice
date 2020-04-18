<Query Kind="Statements">
  <Namespace>System.Text.Json</Namespace>
</Query>

// Advent of Code 2015, day 12, part B

static IEnumerable<JsonElement> ObjectValues(JsonElement parent)
    => parent.EnumerateObject().Select(property => property.Value);

static bool HasRedValue(JsonElement parent)
    => ObjectValues(parent)
        .Where(child => child.ValueKind == JsonValueKind.String)
        .Select(child => child.GetString())
        .Contains("red");

static IEnumerable<int> AllNumbers(JsonElement parent)
{
    switch (parent.ValueKind) {
    case JsonValueKind.Array:
        foreach (var element in parent.EnumerateArray()) {
            foreach (var number in AllNumbers(element))
                yield return number;
        }
        break;
    
    case JsonValueKind.Object when !HasRedValue(parent):
        foreach (var element in ObjectValues(parent)) {
            foreach (var number in AllNumbers(element))
                yield return number;
        }
        break;
    
    case JsonValueKind.Number:
        yield return parent.GetInt32();
        break;
    
    default:
        break; // Ignore objects with red values, and other kinds of elements.
    }
}

static void Solve(string label, string json)
{
    using var doc = JsonDocument.Parse(json);
    
    AllNumbers(doc.RootElement)
        .Sum()
        .Dump(label);
}

var tests = new[] {
    "[1,2,3]",
    "[1,{\"c\":\"red\",\"b\":2},3]",
    "{\"d\":\"red\",\"e\":[1,2,3,4],\"f\":5}",
    "[1,\"red\",5]"
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
