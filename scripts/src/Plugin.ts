import { AfterProgramCreateEvent, ArrayLiteralExpression, AssignmentStatement, BeforeBuildProgramEvent, BeforeFileValidateEvent, BrsFile, BscFile, CallExpression, ClassStatement, CommentStatement, CompilerPlugin, ConstStatement, Editor, ForStatement, FunctionParameterExpression, FunctionStatement, LiteralExpression, MethodStatement, NamespaceStatement, ParseMode, Parser, ReturnStatement, Statement, TokenKind, TypeCastExpression, TypeExpression, VariableExpression, WalkMode, createIdentifier, createToken, createVariableExpression, isArrayLiteralExpression, isBrsFile, isClassStatement, isConstStatement, isFunctionStatement, isMethodStatement, isNamespaceStatement } from "brighterscript";

class BsBenchPlugin implements CompilerPlugin {
    name = 'bsbench';

    afterProgramCreate(event: AfterProgramCreateEvent) {
    }

    beforeFileValidate(event: BeforeFileValidateEvent) {
        //add all the setup variables to each method in the suite
        for (const suite of this.findSuites(event.file)) {
            const setupFunction = this.findFunction(suite, 'setup');
            //if there's no setup method, skip this suite
            if (!setupFunction) {
                return;
            }

            for (const testFunction of this.findTestFunctions(suite)) {
                //skip adding setup symbols to itself
                if (testFunction === setupFunction) {
                    continue;
                }
                //add every variable from the setup method to this method
                testFunction.func.body.getSymbolTable().addSibling(setupFunction.func.body.getSymbolTable());
            }
        }
    }

    beforeBuildProgram(event: BeforeBuildProgramEvent) {
        const allSuites: NamespaceStatement[] = [];
        //find every suite class
        for (const file of Object.values(event.program.files)) {
            if (!isBrsFile(file)) {
                continue;
            }

            for (const suite of this.findSuites(file)) {
                this.prepareSuite(event.editor, suite);
                allSuites.push(suite);
            }
        }

        this.injectSuiteData(event, allSuites);
    }

    private injectSuiteData(event: BeforeBuildProgramEvent, allSuites: NamespaceStatement[]) {
        //add every suite constructor to the bsbench.allSuites array
        const bsbenchFile = event.program.getFile<BrsFile>('source/bsbench.bs');

        //find the allSuites array
        const allSuitesConstArray = bsbenchFile.ast.findChild<ConstStatement>((x) => {
            return isConstStatement(x) && x.name.toLowerCase() === 'allsuites';
        })?.findChild(isArrayLiteralExpression) as ArrayLiteralExpression;

        if (allSuitesConstArray) {
            //push suite data to the allSuites array
            event.editor.arrayPush(
                allSuitesConstArray.elements,
                //create an AA for every suite
                ...allSuites.map(suite => {
                    const ast = (Parser.parse(`aa = {
                        name: "${suite.getName(ParseMode.BrighterScript)}",
                        tests: {
                            ${this.findTestFunctions(suite).map((test) => `"${test.tokens.name.text}": ${test.getName(ParseMode.BrighterScript)}`).join(', ')}
                        }
                    `).ast.statements[0] as AssignmentStatement).value;
                    return ast;
                })
            )
        }
    }

    /**
     * Find all suite classes in the file
     * @param file
     * @returns
     */
    private findSuites(file: BscFile) {
        if (!isBrsFile(file)) {
            return []
        }
        return file.ast.findChildren<NamespaceStatement>((node) => {
            return isNamespaceStatement(node) && !!node.annotations?.find(x => x.name.toLowerCase() === 'suite');
        });
    }

    //find the `setup` method in the suite (if there is one)
    private findFunction(suite: NamespaceStatement, name: string) {
        return suite.findChild<FunctionStatement>(x => isFunctionStatement(x) && x.tokens.name.text.toLowerCase() === name.toLowerCase());
    }

    private findTestFunctions(suite: NamespaceStatement) {
        return suite.body
            .findChildren<FunctionStatement>(isFunctionStatement)
            .filter(x => x.annotations?.find(x => x.name.toLowerCase() === 'test'));
    }

    private prepareSuite(editor: Editor, suite: NamespaceStatement) {
        const setupFunction = this.findFunction(suite, 'setup');
        //get the body of the `setup()` method
        const teardownFunction = this.findFunction(suite, 'teardown');


        //transform every benchmark method
        for (const testFunction of this.findTestFunctions(suite)) {
            //skip the setup and teardown methods
            if ([setupFunction, teardownFunction].includes(testFunction)) {
                continue;
            }

            //remove all function parameters and inject the `iterations` param
            editor.arraySplice(
                testFunction.func.parameters,
                0,
                testFunction.func.parameters.length,
                new FunctionParameterExpression({
                    name: createIdentifier('iterations')
                })
            );

            //ensure we have `as dynamic` as the return type for this function
            editor.setProperty(testFunction.func, 'returnTypeExpression', new TypeExpression({
                expression: new TypeExpression({
                    expression: createVariableExpression('dynamic')
                })
            }));

            //wrap the entire body of the function in a for loop
            const forLoop = Parser.parse('for i = 0 to iterations\nend for').ast.statements[0] as ForStatement;
            editor.setProperty(forLoop.body, 'statements', testFunction.func.body.statements);
            editor.setProperty(testFunction.func.body, 'statements', [forLoop]);

            //insert new date before the loop
            const startTimeAssignment = Parser.parse(`__benchmarkStartTime = CreateObject("roDateTime")`).ast.statements[0] as AssignmentStatement;
            editor.arrayUnshift(testFunction.func.body.statements, startTimeAssignment);

            //insert new date after the loop
            const endTimeAssignment = Parser.parse(`__benchmarkEndTime = CreateObject("roDateTime")`).ast.statements[0] as AssignmentStatement;
            editor.arrayPush(testFunction.func.body.statements, endTimeAssignment);

            //prepend the setup body to the top of the function body
            if (setupFunction) {
                editor.arrayUnshift(
                    testFunction.func.body.statements,
                    ...setupFunction.func.body.statements
                );
            }

            //append the setup body to the top of the function body
            if (teardownFunction) {
                editor.arrayPush(
                    testFunction.func.body.statements,
                    ...teardownFunction.func.body.statements
                );
            }

            //append a statement that returns the test results
            const returnStatement = Parser.parse(`return {
                startTime: __benchmarkStartTime
                endTime: __benchmarkEndTime
                iterations: iterations
                name: "${testFunction.tokens.name.text}"
                suiteName: "${suite.getName(ParseMode.BrightScript)}"
            }`).ast.statements[0] as ReturnStatement;
            editor.arrayPush(testFunction.func.body.statements, returnStatement);
        }
    }
}


function createComment(text: string) {
    return new CommentStatement({
        comments: [createToken(TokenKind.Comment, `'${text}`)]
    });
}

export default () => {
    return new BsBenchPlugin();
}
