import ballerina/test;
import ballerina/file;

const suffix = "np_generated";

@test:Config
function testSchemaGeneratedForComplexTypeAtCompileTime() returns error? {
    string testFunctionName = "sum";
    (file:MetaData & readonly)[]|file:Error dirs = file:readDir("./generated");
    if dirs is file:Error {
        test:assertFail("Failed to read the generated directory: " + dirs.message());
    }

    file:MetaData[] files = dirs.filter(function(file:MetaData file) returns boolean {
        return file.absPath.endsWith(testFunctionName + suffix + ".bal");
    });

    if files.length() == 0 {
        test:assertFail("No generated file found for the function: " + testFunctionName);
    } else if files.length() > 1 {
        test:assertFail("Multiple generated files found for the function: " + testFunctionName);
    }                                      
}
