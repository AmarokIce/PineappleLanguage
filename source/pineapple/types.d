module pineapple.types;

/* Command struct */

struct CommandData {
    string name;
    DataType data;
    VeriableType type;
    void* command;
}

/* Data types */

enum DataType {
    VERIABLE,
    FUNCTION
}

enum VeriableType {
    VOID = "VOID",
    STRING = "STRING",
    INTEGER = "INTEGER",
    FLOAT = "FLOAT",
    BOOLEAN = "BOOLEAN",
    BYTE = "BYTE",
    ARRAY = "ARRAY",
    MAP = "MAP",
}

VeriableType createTypeBy(string type) {
    import std.string;

    final switch (type) {
    case "string":
        return VeriableType.STRING;
    case "int":
        return VeriableType.INTEGER;
    case "float":
        return VeriableType.FLOAT;
    case "boolean":
        return VeriableType.BOOLEAN;
    case "byte":
        return VeriableType.BYTE;
    }

    if (type.startsWith("array")) {
        return VeriableType.ARRAY;
    }

    if (type.startsWith("map")) {
        return VeriableType.MAP;
    }

    return VeriableType.VOID;
}
