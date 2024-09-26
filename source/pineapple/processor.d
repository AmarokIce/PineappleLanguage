module pineapple.processor;

import pineapple;
import esstool;
import std.string;

void initialize(string filePath)
{
    string[] lines = filePath.readAllLines;
    string[] commands = new string[0];

    foreach (string l; lines)
    {
        clearSpace(l);
    }

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

    string[] kv = line.split(" ");
    string path = kv[1].replace(";", "");

    return "MODULE " ~ path;
}

string checkImport(string line)
{
    if (!line.startsWith("import"))
    {
        return "";
    }

    string[] kv = line.split(" ");
    string path = kv[1].replace(";", "");

    return "IMPORT " ~ path;
}

string[] checkVariableCommand(string line)
{
    // TODO - Callback with a funaction.

    string[] commands = new string[0];

    bool flag = line.startsWith("var") ? true : false;

    string name;
    string value;
    string type;

    if (indexOf(line, "=") != -1)
    {
        auto kv = line.split("=")[0];
        name = clearSpace(kv[0].split(" ")[1]);
        value = clearSpace(kv[1]);
    }
    else if (!flag)
    {
        return commands;
    }
    else
    {

        name = clearSpace(line.split(" ")[1]);
    }

    if (value.startsWith("do"))
    {
        // TODO - Call funaction;
    }

    if (flag)
    {
        commands ~= "VAR CREATE " ~ createTypeBy(type) ~ " " ~ name;
    }

    commands ~= "VAR SET " ~ name ~ " " ~ value;

}

string[] checkFunctionCommand(string line)
{
    auto commands = new string[0];

    if (!line.startsWith("fn"))
    {
        return commands;
    }

    line = clearSpace(line[2 .. $ - 1]);
    string[] nv = line.split(":");

    string type;
    string name;
    string[] args;

    type = nv.length > 1 ? createTypeBy(clearSpace(nv[1])) : PType.VOID;
    name = clearSpace(nv[0].split("(")[0]);

    string s_args = clearSpace(nv[0].split("(")[1])[0 .. $ - 1];
    foreach (string agr; s_args.split(","))
    {
        string arg_name;
        string arg_type;

        string[] kv = arg.split(":");
        arg_name = clearSpace(kv[0]);
        arg_type = createTypeBy(clearSpace(kv[1]));

        args ~= "ARG " ~ arg_name ~ " " ~ arg_name;
    }

    commands ~= "FN " ~ name;
    comamnds ~= "FN RETURN " ~ type;
    commands ~= args;
    commands ~= "ARG END";
}

// TODO - Script

/* Util Tools */

string clearSpace(string str)
{
    StringBuilder sb = new StringBuilder(str);
    while (sb.indexOf("  "))
    {
        sb.clear().append(sb.substring(sb.asString.replace("  ", " ")));
    }

    str = sb.asString;

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
        lines ~= clearSpace(reader.read);
    }

    return lines;
}
