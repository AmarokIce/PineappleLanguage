module pineapple.calculator;

import std.string;
import std.regex;
import std.conv : to;
import esstool.errors;

double operator(string formula)
{
    string[] factors = new string[0];

    formula = formula.replace(" ", "");

    string buffer = "";

    void push()
    {
        if (buffer.length > 0)
        {
            factors ~= buffer;
            buffer = "";
        }
    }

    for (int i = 0; i < formula.length; i++)
    {
        char c = formula[i];

        if (matchFirst(to!string(c), r"[+]|[-]|[*]|[/]|[%]"))
        {
            push();
            buffer ~= c;
            continue;
        }

        if (c == '(')
        {
            int end = rangeOfEnd(formula, i);
            if (end == -1)
            {
                throw new RuntimeError("The precedence operator has a beginning and no end!");
            }
            buffer ~= to!string(operator(formula[i + 1 .. end]));
            i = end;
            continue;
        }

        if (c == ')')
        {
            throw new RuntimeError("No precedence operator but not in beginning!");
        }

        buffer ~= c;
    }

    push();

    return calculator(factors);
}

private double calculator(string[] factors)
{
    double[] finalFacto = new double[0];

    double factorLast = 0;

    for (int i = 0; i < factors.length; i++)
    {
        string factor = factors[i];

        if (factor.startsWith("*"))
        {
            factorLast = factorLast * to!double(factor[1 .. $]);
            continue;
        }

        if (factor.startsWith("/"))
        {
            factorLast = factorLast / to!double(factor[1 .. $]);
            continue;
        }

        if (factor.startsWith("%"))
        {
            factorLast = factorLast % to!double(factor[1 .. $]);
            continue;
        }

        finalFacto ~= factorLast;
        factorLast = to!double(factor);
    }

    finalFacto ~= factorLast;

    double value = 0;

    foreach (double f; finalFacto)
    {
        value += f;
    }

    return value;
}

private int rangeOfEnd(string formula, int start)
{
    int include = 0;

    for (int i = start + 1; i < formula.length; i++)
    {
        char c = formula[i];
        if (c == '(')
        {
            include++;
        }

        if (c != ')')
        {
            continue;
        }

        if (include > 0)
        {
            include--;
        }
        else
        {
            return i;
            break;
        }
    }

    return -1;
}
