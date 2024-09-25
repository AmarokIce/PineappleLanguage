module pineapple.types;

import std.string;

struct PFunction
{
    string name;
    PFunctionArgs*[] args;
    PType typeReturn;
    int startLines = 0;

    string[] commands;
}

struct PFunctionArgs
{
    string name;
    PType type;
}

struct PField
{
    string name;
    void* value;
    PType type;
}

enum PType
{
    VOID,
    STRING,
    INTEGER,
    FLOAT,
    BOOLEAN,
    BYTE,
    ARRAY,
    MAP
}

PType createTypeBy(string type)
{
    final switch (type)
    {
    case "string":
        return PType.STRING;
    case "int":
        return PType.INTEGER;
    case "float":
        return PType.FLOAT;
    case "boolean":
        return PType.BOOLEAN;
    case "byte":
        return PType.BYTE;
    }

    if (type.startsWith("array"))
    {
        return PType.ARRAY;
    }

    if (type.startsWith("map"))
    {
        return PType.MAP;
    }

    return PType.VOID;
}
