// Copyright (c) 2025 WSO2 LLC. (http://www.wso2.org).
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/test;
import ballerina/log;

service /llm on new http:Listener(8080) {
    resource function post openai/chat/completions(OpenAICreateChatCompletionRequest payload)
            returns json|error {
        OpenAIChatCompletionRequestUserMessage message = payload.messages[0];
        anydata content = message["content"];
        string contentStr = content.toString();
        test:assertEquals(message.role, "user");
        test:assertEquals(content, getExpectedPrompt(content.toString()));

        test:assertEquals(payload.model, "gpt-4o-mini");
        return {
            'object: "chat.completion",
            created: 0,
            model: "",
            id: "",
            choices: [
                {
                    finish_reason: "stop",
                    index: 0,
                    logprobs: (),
                    message: {
                        role: "assistant",
                        content: getMockLLMResponse(contentStr),
                        refusal: ()
                    }
                }
            ]
        };
    }

    resource function post 'default/chat/complete(@http:Payload string contentStr)
            returns json|error {
        test:assertEquals(contentStr, getExpectedPrompt(contentStr.toString()));
        return {
            content: [getMockLLMResponse(contentStr)]
        };
    }


    isolated resource function post code(CodeRequest request, http:Caller caller, @http:Header {name: "x-jwt-assertion"} string? jwtAssertion) {
        string usecase = request.usecase;
        log:printInfo("Received request for usecase: " + usecase);
        test:assertEquals(request.operationType, CODE_GENERATION);
        test:assertEquals(usecase, getUsecaseForCompileTimePromtAsCode(usecase));
        test:assertEquals(request.functions, getFunctionsForCompileTimePromtAsCode(usecase));
        test:assertEquals(request.chatHistory, getChatHistoryForCompileTimePromtAsCode(usecase));
        test:assertEquals(request.sourceFiles, getSourceFilesForCompileTimePromtAsCode(usecase));
        test:assertEquals(request.diagnosticRequest, getDiagnosticsForCompileTimePromtAsCode(usecase));
        test:assertEquals(request.fileAttachmentContents, getFileAttachmentsForCompileTimePromtAsCode(usecase));
        test:assertEquals(request.packageName, getPackagenameForCompileTimePromtAsCode(usecase));

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
        log:printInfo("Received request for code repair usecase: " + usecase);
        test:assertEquals(request.operationType, CODE_GENERATION);
        test:assertEquals(usecase, getUsecaseForCompileTimePromtAsCodeRepair(usecase));
        test:assertEquals(request?.functions, getFunctionsForCompileTimePromtAsCodeRepair(usecase));
        test:assertEquals(request.chatHistory, getChatHistoryForCompileTimePromtAsCodeRepair(usecase));
        test:assertEquals(request.sourceFiles, getSourceFilesForCompileTimePromtAsCodeRepair(usecase));
        test:assertEquals(request.diagnosticRequest, getDiagnosticsForCompileTimePromtAsCodeRepair(usecase));
        test:assertEquals(request.fileAttachmentContents, getFileAttachmentsForCompileTimePromtAsCodeRepair(usecase));
        test:assertEquals(request.packageName, getPackagenameForCompileTimePromtAsCodeRepair(usecase));

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
        http:SseEvent event = {event: "content_block_delta", data: string `{"text": "${"```"}ballerina ${program}${"```"}"}`};
        return {value: event};
    }
}
