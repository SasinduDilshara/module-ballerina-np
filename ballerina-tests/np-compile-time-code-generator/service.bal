import ballerina/http;
import ballerina/test;
import ballerina/log;

service /llm on new http:Listener(8081) {
    isolated resource function post code(CodeRequest request, http:Caller caller, 
            @http:Header {name: "x-jwt-assertion"} string? jwtAssertion) {
        string usecase = request.usecase;
        test:assertEquals(request.operationType, CODE_GENERATION);
        test:assertTrue(usecase.includes(getUsecaseForCompileTimePromtAsCode(usecase)));
        test:assertEquals(request.chatHistory, getChatHistoryForCompileTimePromtAsCode(usecase));
        test:assertEquals(request.diagnosticRequest, getDiagnosticsForCompileTimePromtAsCode(usecase));

        CodeGenerator generator = new (request.usecase);
        stream<http:SseEvent, error?> streamResult = new stream<http:SseEvent, error?>(generator);
        http:Response res = new;
        res.setSseEventStream(streamResult);
        res.addHeader("Cache-Control", "no-cache");
        res.addHeader("X-Accel-Buffering", "no");
        http:ListenerError? respond = caller->respond(res);
        if respond is http:ListenerError {
            log:printError("Failed to send response", err = respond.message() + " " + respond.detail().toBalString());
        }
        log:printInfo("Response sent successfully for usecase: ");
    }

    isolated resource function post code/repair(CodeRequest request, @http:Header {name: "x-jwt-assertion"} string? jwtAssertion) returns RepairResponse{
        string usecase = request.usecase;
        test:assertEquals(request.operationType, CODE_GENERATION);
        test:assertTrue(usecase.includes(getUsecaseForCompileTimePromtAsCodeRepair(usecase)));
        test:assertEquals(request?.functions, getFunctionsForCompileTimePromtAsCodeRepair(usecase));
        test:assertEquals(request.chatHistory, getChatHistoryForCompileTimePromtAsCodeRepair(usecase));
        test:assertEquals(request.diagnosticRequest, getDiagnosticsForCompileTimePromtAsCodeRepair(usecase));

        string program = getRepairedBallerinaProgramForTheUseCase(request.usecase);
        return {repairResponse: string `${"```"}ballerina ${program} ${"```"}`};
    }
}

class CodeGenerator {
    int eventCounter = 0;
    string usecase;
    int count = 0;

    isolated function init(string usecase) {
        self.usecase = usecase;
    }

    public isolated function next() returns record {|http:SseEvent value;|}|error? {
        if self.count >= 1 {
            return ();
        }

        self.count = self.count + 1;
        string program = getBallerinaProgramForTheUseCase(self.usecase);
        http:SseEvent event = {
            event: "content_block_delta", 
            data: {text: string `${"```"}ballerina ${program} ${"```"}`}.toJsonString()
        };
        return {value: event};
    }
}
