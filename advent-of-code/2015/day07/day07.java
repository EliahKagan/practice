// Advent of code 2015, day 7, both parts
// Via recursion with memoization, with cycle checking.
// Using a single table of thunk objects that implement a functional interface.

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Scanner;
import java.util.function.IntBinaryOperator;
import java.util.function.IntSupplier;
import java.util.function.IntUnaryOperator;

final class UnrecognizedUnaryOperator extends RuntimeException {
    UnrecognizedUnaryOperator(String unary) {
        super(String.format("Unrecognized unary operator \"%s\"", unary));
    }
}

final class UnrecognizedBinaryOperator extends RuntimeException {
    UnrecognizedBinaryOperator(String binary) {
        super(String.format("Unrecognized binary operator \"%s\"", binary));
    }
}

final class MalformedBindingException extends RuntimeException {
    MalformedBindingException() {
        super("Malformed binding, not of form: RULE -> NAME");
    }
}

final class MalformedRuleException extends RuntimeException {
    MalformedRuleException(String rule) {
        super(String.format("Malformed rule: %s", rule));
    }
}

final class CyclicDefinitionException extends RuntimeException {
    CyclicDefinitionException(String name) {
        super(String.format("Cycle encountered while evaluating \"%s\"",
                            name));
    }
}

final class Scope {
    void bind(String name, String expr) {
        defer(name, compile(expr));
    }

    void bind(String name, IntUnaryOperator unary, String expr) {
        var arg = compile(expr);
        defer(name, () -> unary.applyAsInt(arg.getAsInt()));
    }

    void bind(String name, IntBinaryOperator binary,
              String expr1, String expr2) {
        var arg1 = compile(expr1);
        var arg2 = compile(expr2);
        defer(name, () -> binary.applyAsInt(arg1.getAsInt(), arg2.getAsInt()));
    }

    Runnable snapshot() {
        var variables = new HashMap<>(_variables);
        return () -> _variables = variables;
    }

    int evaluateVariable(String variable) {
        return _variables.get(variable).getAsInt();
    }

    private IntSupplier compile(String expr) {
        if (expr.matches("\\d+")) {
            var value = Integer.parseInt(expr);
            return () -> value;
        }

        return () -> evaluateVariable(expr);
    }

    private void defer(String name, IntSupplier implementation) {
        _variables.put(name, () -> {
            _variables.put(name, () -> {
                throw new CyclicDefinitionException(name);
            });

            var value = implementation.getAsInt();
            _variables.put(name, () -> value);
            return value;
        });
    }

    private Map<String, IntSupplier> _variables = new HashMap<>();
}

final class Translator {
    Translator(Scope scope) {
        _scope = scope;
    }

    void addRule(String name, String rule) {
        var tokens = rule.split("\\s+");

        switch (tokens.length) {
        case 1:
            _scope.bind(name, tokens[0]);
            break;

        case 2:
            _scope.bind(name, getUnaryOperator(tokens[0]), tokens[1]);
            break;

        case 3:
            _scope.bind(name,
                        getBinaryOperator(tokens[1]),
                        tokens[0],
                        tokens[2]);
            break;

        default:
            throw new MalformedRuleException(rule);
        }
    }

    private static IntUnaryOperator getUnaryOperator(String unary) {
        var operator = s_unaries.get(unary);
        if (operator == null) throw new UnrecognizedUnaryOperator(unary);
        return operator;
    }

    private static IntBinaryOperator getBinaryOperator(String binary) {
        var operator = s_binaries.get(binary);
        if (operator == null) throw new UnrecognizedBinaryOperator(binary);
        return operator;
    }

    private static final int MASK = 65535;

    private static final Map<String, IntUnaryOperator> s_unaries =
        new HashMap<>();

    private static final Map<String, IntBinaryOperator> s_binaries =
        new HashMap<>();

    static {
        s_unaries.put("NOT", arg -> ~arg & MASK);

        s_binaries.put("AND", (arg1, arg2) -> arg1 & arg2);
        s_binaries.put("OR", (arg1, arg2) -> arg1 | arg2);
        s_binaries.put("LSHIFT", (arg1, arg2) -> (arg1 << arg2) & MASK);
        s_binaries.put("RSHIFT", (arg1, arg2) -> arg1 >>> arg2);
    }

    private final Scope _scope;
}

enum Program {
    ;

    public static void main(String[] args) throws IOException {
        if (args.length == 0)
            runSimpleExample();
        else
            runOnInput(args);
    }

    private static void runSimpleExample() {
        var scope = new Scope();

        readRules(new Translator(scope),
                  new Scanner("123 -> x\n"
                            + "456 -> y\n"
                            + "x AND y -> d\n"
                            + "x OR y -> e\n"
                            + "x LSHIFT 2 -> f\n"
                            + "y RSHIFT 2 -> g\n"
                            + "NOT x -> h\n"
                            + "NOT y -> i\n"));

        var vars =  new String[] {"d", "e", "f", "g", "h", "i", "x", "y" };

        for (var name : vars)
            System.out.format("%s: %d%n", name, scope.evaluateVariable(name));
    }

    private static void runOnInput(String[] paths) throws IOException {
        var scope = new Scope();

        var translator = new Translator(scope);
        for (var path : paths)
            readRules(translator, new Scanner(Paths.get(path)));

        var restorer = scope.snapshot();
        var aValue = scope.evaluateVariable("a");
        System.out.format("Before rewire: %d%n", aValue);

        restorer.run();
        scope.bind("b", Integer.toString(aValue));
        System.out.format("After rewire: %d%n", scope.evaluateVariable("a"));
    }

    private static void readRules(Translator translator, Scanner sc) {
        while (sc.hasNextLine()) {
            var line = sc.nextLine().strip();
            if (line.isEmpty()) continue;

            var sides = line.split("->");
            if (sides.length != 2) throw new MalformedBindingException();

            var rule = sides[0].strip();
            var name = sides[1].strip();
            translator.addRule(name, rule);
        }
    }
}
