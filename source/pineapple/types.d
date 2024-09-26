module pineapple.types;

enum PType
{
    VOID = "VOID",
    STRING = "STRING",
    INTEGER = "INTEGER",
    FLOAT = "FLOAT",
    BOOLEAN = "BOOLEAN",
    BYTE = "BYTE",
    ARRAY = "ARRAY",
    MA = "MAP",
}

PType createTypeBy(string type)
{
    import std.string;

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
