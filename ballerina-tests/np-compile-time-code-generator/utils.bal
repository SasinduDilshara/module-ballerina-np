import ballerina/test;

const ballerinaProgramForSummation = string `
    function sumNPGenerated(int a, int b) returns int {
        return a + b;
    }`;

const INT_SUMMATION_USECASE_PREFIX = "Give the summation of";

final string expectedPromptStringForCompileTimeCodeGenerationWithSummation = 
    string `Give the summation of the given two numbers`;

isolated function getUsecaseForCompileTimePromtAsCode(string usecase) returns string {
    if usecase.includes(INT_SUMMATION_USECASE_PREFIX) {
        return expectedPromptStringForCompileTimeCodeGenerationWithSummation;
    }
    test:assertFail("Unexpected prompt");
}

isolated function getDiagnosticsForCompileTimePromtAsCode(string usecase) returns DiagnosticRequest? {
    if usecase.includes(INT_SUMMATION_USECASE_PREFIX) {
        return ();
    }
    test:assertFail("Unexpected prompt");
}

isolated function getChatHistoryForCompileTimePromtAsCode(string usecase) returns ChatHistory[] {
    if usecase.includes(INT_SUMMATION_USECASE_PREFIX) {
        return [];
    }
    test:assertFail("Unexpected prompt");
}

isolated function getDiagnosticsForCompileTimePromtAsCodeRepair(string usecase) {
    
}

isolated function getChatHistoryForCompileTimePromtAsCodeRepair(string usecase) {
    
}

isolated function getFunctionsForCompileTimePromtAsCodeRepair(string usecase) {
    
}

isolated function getUsecaseForCompileTimePromtAsCodeRepair(string usecase) returns string {
    if usecase.includes(INT_SUMMATION_USECASE_PREFIX) {
        return expectedPromptStringForCompileTimeCodeGenerationWithSummation;
    }
    test:assertFail("Unexpected prompt");
}

isolated function getBallerinaProgramForTheUseCase(string usecase) returns string {
    if usecase.includes(INT_SUMMATION_USECASE_PREFIX) {
        return ballerinaProgramForSummation;
    }

    test:assertFail("Unexpected prompt");
}


isolated function getRepairedBallerinaProgramForTheUseCase(string usecase) returns string {
    test:assertFail("Unexpected prompt");
}
