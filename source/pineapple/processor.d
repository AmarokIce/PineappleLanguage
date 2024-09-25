module pineapple.processor;

import pineapple.types;

import esstool;

import std.string;

string outOfLineSplit(string og) => og[0 .. $ - 1];
string replaceCommand(string og, string target) =>
    cleanSpace(og.replace(target, "")).outOfLineSplit;

void initialize(string filePath)
{
    string[] lines = filePath.readAllLines;
    string[] commands = new string[0];

    string holder = "";
    for (int i = 1; i < lines.length; i++)
    {
        string line = lines[i];

        string flag;

        if (line == "")
        {
            continue;
        }

        holder ~= line;

        if (!holder.endsWith(";") && !holder.endsWith("{") && !holder.endsWith("}"))
        {
            continue;
        }

        line = holder;
        holder = "";

        if (line.endsWith("}") && len(line) > 1)
        {
            commands ~= scanLine(line[0 .. $ - 1]);

            commands ~= "FN END";
            continue;
        }
        else
        {
            commands ~= "FN END";
            continue;
        }

        commands ~= scanLine(line);
    }

}

string[] scanLine(string line)
{
    string[] commands = new string[0];

    flag = line.checkModule;
    if (flag != "")
    {
        commands ~= flag;
        return commands;
    }

    flag = line.checkImport;
    if (flag != "")
    {
        commands ~= flag;
        return commands;
    }
}

string checkModule(string line)
{
    if (!line.startsWith("module"))
    {
        return "";
    }

    line = line.replaceCommand("module");

    return "MODULE " ~ line;
}

string checkImport(string line)
{
    if (!line.startsWith("import"))
    {
        return "";
    }

    line = line.replaceCommand("import");
    return "IMPORT " ~ line;
}

string checkVariableCommand(string line)
{
    // TODO - Callback with a funaction.

    auto command = "VAR ";
    if (line.startWith("var"))
    {
        line = line.replaceCommand("var");
        auto kv = line.split("=");

        auto tp = kv[0].split(":");

        auto name = cleanSpace(tp[0]);
        auto s_type = cleanSpace(tp[1]);

        command ~= s_type ~ " " ~ name;

        return len(kv) == 1 ? command : command ~ " " ~ kv[1];
    }

    auto index = indexOf(line, "=");
    if (index == -1)
    {
        return "";
    }

}

/* Util Tools */

string cleanSpace(string str)
{
    while (str.startsWith(" "))
    {
        str = str[1 .. $];
    }

    while (str.endsWith(" "))
    {
        str = str[0 .. $ - 1];
    }

    return str;
}

string[] readAllLines(string filePath)
{
    string[] lines = new string[0];

    LineReader reader = new LineReader(filePath);
    while (reader.readly)
    {
        lines ~= cleanSpace(reader.read);
    }

    return lines;
}
