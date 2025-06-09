import ballerina/test;

isolated function getExpectedPrompt(string prompt) returns string {
    string trimmedPrompt = prompt.trim();

    if trimmedPrompt.startsWith("Which country") {
        return  string `Which country is known as the pearl of the Indian Ocean?
        ---

        The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```json"} and ${"```"}
        
        Schema:
        {"type":"string"}`;
    }

    if trimmedPrompt.startsWith("For each string value ") {
        return string `For each string value in the given array if the value can be parsed
    as an integer give an integer, if not give the same string value. Please preserve the order.
    Array value: ["foo","1","bar","2.3","4"]
        ---

        The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```json"} and ${"```"}
        
        Schema:
        {"type":"array", "items":{"type":"object", "anyOf":[{"type":"string"}, {"type":"integer"}]}}`;
    }

    if trimmedPrompt.startsWith("Who is a popular sportsperson") {
        return string `Who is a popular sportsperson that was born in the decade starting
    from 1990 with Simone in their name?
        ---

        The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```json"} and ${"```"}
        
        Schema:
        {"type":"object", "anyOf":[{"required":["firstName", "lastName", "sport", "yearOfBirth"], "type":"object", "properties":{"firstName":{"type":"string", "description":"First name of the person"}, "lastName":{"type":"string", "description":"Last name of the person"}, "yearOfBirth":{"type":"integer", "description":"Year the person was born", "format":"int64"}, "sport":{"type":"string", "description":"Sport that the person plays"}}}, {"type":null}]}`;
    }

    if trimmedPrompt.includes("Tell me about places in the specified country") && trimmedPrompt.includes("Sri Lanka") {
        return string `You have been given the following input:

country: 
${"```"}
Sri Lanka
${"```"}

interest: 
${"```"}
beach
${"```"}

count: 
${"```"}
3
${"```"}

    Tell me about places in the specified country that could be a good destination 
    to someone who has the specified interest.

    Include only the number of places specified by the count parameter.
        ---

        The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```"}json and ${"```"}
        
        Schema:
        {"type":"array", "items":{"required":["city", "country", "description", "name"], "type":"object", "properties":{"name":{"type":"string", "description":"Name of the place."}, "city":{"type":"string", "description":"City in which the place is located."}, "country":{"type":"string", "description":"Country in which the place is located."}, "description":{"type":"string", "description":"One-liner description of the place."}}}}`;
    }

    if trimmedPrompt.includes("Tell me about places in the specified country") && trimmedPrompt.includes("UAE") {
        return string `You have been given the following input:

country: 
${"```"}
UAE
${"```"}

interest: 
${"```"}
skyscrapers
${"```"}

count: 
${"```"}
2
${"```"}

    Tell me about places in the specified country that could be a good destination 
    to someone who has the specified interest.

    Include only the number of places specified by the count parameter.
        ---

        The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```"}json and ${"```"}
        
        Schema:
        {"type":"array", "items":{"required":["city", "country", "description", "name"], "type":"object", "properties":{"name":{"type":"string", "description":"Name of the place."}, "city":{"type":"string", "description":"City in which the place is located."}, "country":{"type":"string", "description":"Country in which the place is located."}, "description":{"type":"string", "description":"One-liner description of the place."}}}}`;
    }

    if trimmedPrompt.startsWith("What's the output of the Ballerina code below") {
        return string `What's the output of the Ballerina code below?

    ${"```"}ballerina
    import ballerina/io;

    public function main() {
        int x = 10;
        int y = 20;
        io:println(x + y);
    }
    ${"```"}
        ---

        The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```json"} and ${"```"}
        
        Schema:
        {"type":"integer"}`;
    }

    if trimmedPrompt.includes("What's the sum of these") {
        if trimmedPrompt.includes("[]") {
            return string `You have been given the following input:

a: 
${"```"}
1
${"```"}

b: 
${"```"}
2
${"```"}

c: 
${"```"}
[]
${"```"}

    What's the sum of these values?
        ---

        The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```"}json and ${"```"}
        
        Schema:
        {"type":"integer"}`;
        }

        if trimmedPrompt.includes("[40,50]") {
            return string `You have been given the following input:

a: 
${"```"}
20
${"```"}

b: 
${"```"}
30
${"```"}

c: 
${"```"}
[40,50]
${"```"}

    What's the sum of these values?
        ---

        The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```"}json and ${"```"}
        
        Schema:
        {"type":"integer"}`;
        }
    }

    if trimmedPrompt.includes("Give me the sum of these values") {
        if trimmedPrompt.includes("[]") {
            return string `You have been given the following input:

d: 
${"```"}
100
${"```"}

e: 
${"```"}
{"val":200}
${"```"}

f: 
${"```"}
[]
${"```"}

    Give me the sum of these values
        ---

        The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```"}json and ${"```"}
        
        Schema:
        {"type":"integer"}`;
        }

        if trimmedPrompt.includes("[500]") {
            return string `You have been given the following input:

d: 
${"```"}
300
${"```"}

e: 
${"```"}
{"val":400}
${"```"}

f: 
${"```"}
[500]
${"```"}

    Give me the sum of these values
        ---

        The output should be a JSON value that satisfies the following JSON schema, 
        returned within a markdown snippet enclosed within ${"```"}json and ${"```"}
        
        Schema:
        {"type":"integer"}`;
        }
    }

    test:assertFail("Unexpected prompt: " + trimmedPrompt);
}

isolated function getMockLLMResponse(string message) returns string? {
    if message.startsWith("Which country") {
        return "```\n\"Sri Lanka\"\n```";
    }

    if message.startsWith("For each string value ") {
        return "```\n[\"foo\", 1, \"bar\", \"2.3\", 4]\n```";
    }

    if message.startsWith("Who is a popular sportsperson") {
        return "```\n{\"firstName\":\"Simone\",\"lastName\":\"Biles\",\"yearOfBirth\":1997,\"sport\":\"Gymnastics\"}\n```";
    }

    if message.includes("Tell me about places in the specified country") && message.includes("Sri Lanka") {
        return "```\n[{\"name\":\"Unawatuna Beach\",\"city\":\"Galle\",\"country\":\"Sri Lanka\",\"description\":\"A popular beach known for its golden sands and vibrant nightlife.\"},{\"name\":\"Mirissa Beach\",\"city\":\"Mirissa\",\"country\":\"Sri Lanka\",\"description\":\"Famous for its stunning sunsets and opportunities for whale watching.\"},{\"name\":\"Hikkaduwa Beach\",\"city\":\"Hikkaduwa\",\"country\":\"Sri Lanka\",\"description\":\"A great destination for snorkeling and surfing, lined with lively restaurants.\"}]\n```";
    }

    if message.includes("Tell me about places in the specified country") && message.includes("UAE") {
        return "```\n[{\"name\":\"Burj Khalifa\",\"city\":\"Dubai\",\"country\":\"UAE\",\"description\":\"The tallest building in the world, offering panoramic views of the city.\"},{\"name\":\"Ain Dubai\",\"city\":\"Dubai\",\"country\":\"UAE\",\"description\":\"The world's tallest observation wheel, providing breathtaking views of the Dubai skyline.\"}]\n```";
    }

    if message.startsWith("What's the output of the Ballerina code below?") {
        return string `The output of the provided Ballerina code calculates the sum of ${"`"}x${"`"} and ${"`"}y${"`"}, which is ${"`"}10 + 20${"`"}. Therefore, the result will be ${"`"}30${"`"}. \n\nHere is the output formatted as a JSON value that satisfies your specified schema:${"\n\n```"}json${"\n"}30${"\n```"}`;
    }

    if message.includes("What's the sum of these") {
        if message.includes("[]") {
            return "```\n3\n```";
        }

        if message.includes("[40,50]") {
            return "```\n140\n```";
        }
    }

    if message.includes("Give me the sum of these values") {
        if message.includes("[]") {
            return "```\n300\n```";
        }

        if message.includes("[500]") {
            return "```\n1200\n```";
        }
    }

    test:assertFail("Unexpected prompt");
}

final string expectedPromptStringForCompileTimeCodeGenerationWithEmployeeCount = string `
        Give me a list of 5 employees where some employees are in the same department also.
        Make sure to reflect real-world data. For example, make sure the data is proportionate to 
        the department sizes and IDs of employees from the same department aren't always contiguous.`;

final string expectedPromptStringForCompileTimeCodeGenerationWithPrintEmployeeDetails = string `
        Print the employee data grouped by department, in the following format.
        
        Department: <Department Name>
        =================================================
        Employee ID: <Employee 1 ID>, Name: <Employee 1 Name>, Salary: <Employee 1 Salary>
        ...
        Employee ID: <Employee n ID>, Name: <Employee n Name>, Salary: <Employee n Salary>`;

isolated function getUsecaseForCompileTimePromtAsCode(string usecase) returns string {
    if usecase.startsWith("Give me a list of ") {
        return expectedPromptStringForCompileTimeCodeGenerationWithEmployeeCount;
    }

    if usecase.startsWith("Print the employee data grouped by department") {
        return expectedPromptStringForCompileTimeCodeGenerationWithPrintEmployeeDetails;
    }

    return "";
}

isolated function getPackagenameForCompileTimePromtAsCode(string usecase) returns string {
    return "ballerina/np";
}

isolated function getFileAttachmentsForCompileTimePromtAsCode(string usecase) {
    
}

isolated function getDiagnosticsForCompileTimePromtAsCode(string usecase) {
    
}

isolated function getSourceFilesForCompileTimePromtAsCode(string usecase) {
    
}

isolated function getChatHistoryForCompileTimePromtAsCode(string usecase) {
    
}

isolated function getFunctionsForCompileTimePromtAsCode(string usecase) {
    
}

isolated function getPackagenameForCompileTimePromtAsCodeRepair(string usecase) {
    
}

isolated function getFileAttachmentsForCompileTimePromtAsCodeRepair(string usecase) {
    
}

isolated function getDiagnosticsForCompileTimePromtAsCodeRepair(string usecase) {
    
}

isolated function getSourceFilesForCompileTimePromtAsCodeRepair(string usecase) {
    
}

isolated function getChatHistoryForCompileTimePromtAsCodeRepair(string usecase) {
    
}

isolated function getFunctionsForCompileTimePromtAsCodeRepair(string usecase) {
    
}

isolated function getUsecaseForCompileTimePromtAsCodeRepair(string usecase) {
    
}

isolated function getBallerinaProgramForTheUseCase(string usecase) returns string {
    if usecase.startsWith("Print the employee data grouped by department") {
        return printEmployeeDataByDepartmentProgram;
    }

    return "";
}


isolated function getRepairedBallerinaProgramForTheUseCase(string usecase) returns string {
    if usecase.startsWith("Print the employee data grouped by department") {
        return printEmployeeDataByDepartmentProgram;
    }

    return "";
}

const printEmployeeDataByDepartmentProgram = string `
import ballerina/io;

function printEmployeeDataByDepartmentNPGenerated(Employee[] employees) {
    map<Employee[]> departmentGroups = {};

    foreach Employee employee in employees {
        string departmentName = employee.department.name;
        if !departmentGroups.hasKey(departmentName) {
            departmentGroups[departmentName] = [];
        }
        Employee[] existingEmployees = departmentGroups.get(departmentName);
        departmentGroups[departmentName] = [...existingEmployees, employee];
    }

    string[] departmentNames = departmentGroups.keys();
    foreach string departmentName in departmentNames {
        io:println("Department: " + departmentName);
        io:println("=================================================");

        Employee[] departmentEmployees = departmentGroups.get(departmentName);
        foreach Employee employee in departmentEmployees {
            string employeeDetails = string:concat(
                    "Employee ID: ", employee.id.toString(),
                    ", Name: ", employee.name,
                    ", Salary: ", employee.salary.toString()
            );
            io:println(employeeDetails);
        }
        io:println("");
    }
}`;
