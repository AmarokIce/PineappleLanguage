module pineapple.processor;

import pineapple.types;
import esstool.errors;

CommandData[] functionSets;

void initialize(string filePath) {
    import std.file : exists, isFile;
    import esstool.reader : readlines;

    if (!exists(filePath) || !isFile(filePath)) {
        throw new IllegalAccessError(filePath ~ " not a file!");
    }

    string[] lines = readlines(filePath);
    findAllFunction(lines);
}

void findAllFunction(string[] fileText) {
    import std.string;
    import std.array;

    CommandData* recorder;
    bool startRecord;
    string[]* commands;

    for (int i = 0; i < fileText.length; i++) {
        string command = fileText;
        if (command.startsWith("fn")) {
            if (startRecord || !command.endsWith("{")) {
                throw new IllegalInstanceError("Function has start but no end. At line: " ~ i);
            }

            startRecord = true;
            command = command[0 .. $ - 1];
            command = command.replace("fn ");

            string[] dt = command.split("(");
            string name = dt[0].replace(" ", "");
            string[] cr = dt[1].split("->");

            auto typeInput = cr.length > 1 ? createTypeBy(cr[1]) : VeriableType.VOID;
            commands = &(new string[0]);

            recorder = new CommandData(name, DataType.FUNCTION, typeInput, commands);

            string[] args = cr[1][0 .. $ - 1].split(",");
            if (agrs.length < 1) {
                continue;
            }

            string argCommand = "arg=";
            foreach (string arg; args) {
                if (arg == "") {
                    continue;
                }
                argCommand ~= arg ~ ";";
            }

            if (argCommand != "arg=") {
                *commands ~= argCommand;
            }

            continue;
        }

        if (command.startsWith("}")) {
            startRecord = false;
        }
    }
}
