import { AssignmentStatement, BeforeBuildProgramEvent, CallExpression, ClassStatement, CommentStatement, CompilerPlugin, Editor, ForStatement, FunctionParameterExpression, LiteralExpression, MethodStatement, Parser, ReturnStatement, Statement, TokenKind, VariableExpression, WalkMode, createIdentifier, createToken, isBrsFile, isClassStatement, isMethodStatement } from "brighterscript";

class BsBenchPlugin implements CompilerPlugin {
    name = 'bsbench';

    beforeBuildProgram(event: BeforeBuildProgramEvent) {
        const allSuites = [];
        //find every suite class
        for (const file of Object.values(event.program.files)) {
            if (!isBrsFile(file)) {
                continue;
            }
            const suites = file.ast.findChildren<ClassStatement>((node) => {
                return isClassStatement(node) && !!node.annotations?.find(x => x.name.toLowerCase() === 'suite');
            });
            for (const suite of suites) {
                this.prepareSuite(event.editor, suite);
                allSuites.push(suite);
            }
        }

    }

    private prepareSuite(editor: Editor, suite: ClassStatement) {
        const methods = suite.body.filter(x => isMethodStatement(x)) as MethodStatement[];

        //get the body of the `setup()` method
        const setupMethod = methods.find(x => x.tokens.name.text.toLowerCase() === 'setup')!;
        const teardownMethod = methods.find(x => x.tokens.name.text.toLowerCase() === 'teardown')!;

        //transform every benchmark method
        for (const method of methods) {
            //remove all function parameters and inject the `iterations` param
            editor.arraySplice(
                method.func.parameters,
                0,
                method.func.parameters.length,
                new FunctionParameterExpression({
                    name: createIdentifier('iterations')
                })
            );

            //skip the setup and teardown methods
            if ([setupMethod, teardownMethod].includes(method)) {
                continue;
            }

            //wrap the entire body of the method in a for loop
            const forLoop = Parser.parse('for i = 0 to iterations\nend for').ast.statements[0] as ForStatement;
            editor.setProperty(forLoop.body, 'statements', method.func.body.statements);
            editor.setProperty(method.func.body, 'statements', [forLoop]);

            //insert a new roku date object right before the loop
            const startTimeAssignment = Parser.parse(`__benchmarkStartTime = CreateObject("roDateTime")`).ast.statements[0] as AssignmentStatement;
            editor.arrayUnshift(method.func.body.statements, startTimeAssignment);

            //insert a new roku date object right after the loop
            const endTimeAssignment = Parser.parse(`__benchmarkEndTime = CreateObject("roDateTime")`).ast.statements[0] as AssignmentStatement;
            editor.arrayPush(method.func.body.statements, endTimeAssignment);

            //prepend setup to the top of the method
            if (setupMethod) {
                editor.arrayUnshift(
                    method.func.body.statements,
                    ...setupMethod.func.body.statements
                );
            }

            //append the teardown method to the bottom of the method
            if (teardownMethod) {
                editor.arrayPush(
                    method.func.body.statements,
                    ...teardownMethod.func.body.statements
                );
            }

            //append a statement that returns the test results
            const returnStatement = Parser.parse(`return {
                startTime: __benchmarkStartTime,
                endTime: __benchmarkEndTime,
                iterations: iterations,
                name: "${method.tokens.name.text}"
            }`).ast.statements[0] as ReturnStatement;
            editor.arrayPush(method.func.body.statements, returnStatement);
        }
    }
}
export default () => {
    return new BsBenchPlugin();
}

function createComment(text: string) {
    return new CommentStatement({
        comments: [createToken(TokenKind.Comment, `'${text}`)]
    });
}
