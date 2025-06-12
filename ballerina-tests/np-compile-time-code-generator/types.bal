public type PathParameter record {
    string name;
    string 'type;
};

type MinifiedResourceFunction record {
    *MiniFunction;
    string accessor;
    (PathParameter|string)[] paths;
};

public type MinifiedClient record {
    string name;
    string description?;
    (MinifiedRemoteFunction|MinifiedResourceFunction)[] functions = [];
};

type MiniFunction record {
    string[] parameters?;
    string returnType?;
};

public type MinifiedRemoteFunction record {
    *MiniFunction;
    string name;
};
public type GetFunctionResponse record {
    string name;
    MinifiedClient[] clients?;
    MinifiedRemoteFunction[] functions?;
};

public type ChatHistory record {
    "user"|"assistant" actor;
    string message;
};

public enum OperationInfo {
    CODE_FOR_USER_REQUIREMENT,
    TESTS_FOR_USER_REQUIREMENT,
    CODE_GENERATION
};

public type CodeRequest record {
    string usecase;
    GetFunctionResponse[]? functions?;
    ChatHistory[] chatHistory = [];
    SourceFle[] sourceFiles = [];
    DiagnosticRequest diagnosticRequest?;
    string|AttatchmentFile[] fileAttachmentContents?;
    OperationInfo operationType = CODE_GENERATION;
    string packageName = "";
};

type RepairResponse record {
    string repairResponse;
};

public type SourceFle record {
    string filePath;
    string content;
};

public type AttatchmentFile record {
    string fileName;
    string content;
};

public type DiagnosticRequest record {
    string response;
    Diagnostic[] diagnostics;
};

public type Diagnostic record {
    string message;
};
