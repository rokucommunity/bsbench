import { AfterFileAddEvent, AfterProgramCreateEvent, AfterProgramValidateEvent, ArrayLiteralExpression, AssignmentStatement, BeforeBuildProgramEvent, BeforeFileValidateEvent, BrsFile, BscFile, CompilerPlugin, ConstStatement, Editor, ForStatement, FunctionParameterExpression, FunctionStatement, LiteralExpression, NamespaceStatement, ParseMode, Parser, ReturnStatement, TokenKind, TypeExpression, createIdentifier, createToken, createVariableExpression, isArrayLiteralExpression, isBrsFile, isConstStatement, isFunctionStatement, isNamespaceStatement } from "brighterscript";

class BsBenchPlugin implements CompilerPlugin {
    name = 'bsbench';

    afterProgramCreate(event: AfterProgramCreateEvent) {
    }

    afterFileAdd(event: AfterFileAddEvent<BscFile>) {
        //if the function is named `_`, give it an auto-generated name instead to prevent collisions
        if (isBrsFile(event.file)) {
            for (const suite of this.findSuites(event.file)) {
                const tests = this.findTests(suite);
                for (let i = 0; i < tests.length; i++) {
                    const test = tests[i];
                    if (test.functionStatement.tokens.name.text === '_') {
                        test.functionStatement.tokens.name.text = `test${i}`;
                    }
                }
            }
        }
    }

    beforeFileValidate(event: BeforeFileValidateEvent) {
        //add all the setup variables to each method in the suite
        for (const suite of this.findSuites(event.file)) {
            const setupFunction = this.findFunction(suite, 'setup');
            //if there's no setup method, skip this suite
            if (!setupFunction) {
                return;
            }

            for (const test of this.findTests(suite)) {
                //skip adding setup symbols to itself
                if (test.functionStatement === setupFunction) {
                    continue;
                }
                //add every variable from the setup method to this method
                test.functionStatement.func.body.getSymbolTable().addSibling(
                    setupFunction.func.body.getSymbolTable()
                );
            }
        }
    }


    afterProgramValidate(event: AfterProgramValidateEvent) {
        for (const file of Object.values(event.program.files)) {
            for (const suite of this.findSuites(file)) {
                const setupFunction = this.findFunction(suite, 'setup');
                //if there's no setup method, skip this suite
                if (!setupFunction) {
                    return;
                }

                for (const test of this.findTests(suite)) {
                    //skip adding setup symbols to itself
                    if (test.functionStatement === setupFunction) {
                        continue;
                    }
                    //add every variable from the setup method to this method
                    test.functionStatement.func.body.getSymbolTable().addSibling(
                        setupFunction.func.body.getSymbolTable()
                    );
                }
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

        let atOnlySuites = allSuites.filter(x => x.annotations?.find(x => x.name.toLowerCase() === 'only'));
        let suitesToRun = atOnlySuites.length > 0 ? atOnlySuites : allSuites;

        if (allSuitesConstArray) {
            //push suite data to the allSuites array
            event.editor.arrayPush(
                allSuitesConstArray.elements,
                //create an AA for every suite
                ...suitesToRun.map(suite => {
                    const ast = (Parser.parse(`
                        aa = {
                            name: "${suite.getName(ParseMode.BrighterScript)}",
                            tests: [
                                ${this.findTests(suite).map((test) => `{
                                    name: "${test.functionStatement.tokens.name.text}"
                                    func: ${test.name}
                                }`).join(', ')}
                            ]
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

    private findTests(suite: NamespaceStatement) {
        return suite.body
            .findChildren<FunctionStatement>(isFunctionStatement)
            .map(x => {
                const annotation = x.annotations?.find(x => x.name.toLowerCase() === 'test');
                const nameFromAnnotation = (annotation?.call?.args?.[0] as LiteralExpression)?.tokens?.value?.text?.replace(/^"/, '').replace(/"$/, '');
                return {
                    functionStatement: x,
                    annotation: annotation,
                    name: nameFromAnnotation ?? x.getName(ParseMode.BrightScript)
                }
            })
            //discard any functions that don't have a `@test` annotation
            .filter(x => !!x.annotation)
    }

    private prepareSuite(editor: Editor, suite: NamespaceStatement) {
        const setupFunction = this.findFunction(suite, 'setup');
        //get the body of the `setup()` method
        const teardownFunction = this.findFunction(suite, 'teardown');


        //transform every benchmark method
        for (const test of this.findTests(suite)) {
            //skip the setup and teardown methods
            if ([setupFunction, teardownFunction].includes(test.functionStatement)) {
                continue;
            }

            //remove all function parameters and inject the `iterations` param
            editor.arraySplice(
                test.functionStatement.func.parameters,
                0,
                test.functionStatement.func.parameters.length,
                new FunctionParameterExpression({
                    name: createIdentifier('iterations')
                })
            );

            //ensure we have `as dynamic` as the return type for this function
            editor.setProperty(test.functionStatement.func, 'returnTypeExpression', new TypeExpression({
                expression: new TypeExpression({
                    expression: createVariableExpression('dynamic')
                })
            }));

            //wrap the entire body of the function in a for loop
            const forLoop = Parser.parse('for i = 0 to iterations\nend for').ast.statements[0] as ForStatement;
            editor.setProperty(forLoop.body, 'statements', test.functionStatement.func.body.statements);
            editor.setProperty(test.functionStatement.func.body, 'statements', [forLoop]);

            //insert new date before the loop
            const startTimeAssignment = Parser.parse(`__benchmarkStartTime = CreateObject("roDateTime")`).ast.statements[0] as AssignmentStatement;
            editor.arrayUnshift(test.functionStatement.func.body.statements, startTimeAssignment);

            //insert new date after the loop
            const endTimeAssignment = Parser.parse(`__benchmarkEndTime = CreateObject("roDateTime")`).ast.statements[0] as AssignmentStatement;
            editor.arrayPush(test.functionStatement.func.body.statements, endTimeAssignment);

            //prepend the setup body to the top of the function body
            if (setupFunction) {
                editor.arrayUnshift(
                    test.functionStatement.func.body.statements,
                    ...setupFunction.func.body.statements
                );
            }

            //append the setup body to the top of the function body
            if (teardownFunction) {
                editor.arrayPush(
                    test.functionStatement.func.body.statements,
                    ...teardownFunction.func.body.statements
                );
            }

            //append a statement that returns the test results
            const returnStatement = Parser.parse(`return {
                startTime: __benchmarkStartTime
                endTime: __benchmarkEndTime
                iterations: iterations
                name: "${test.functionStatement.tokens.name.text}"
                suiteName: "${suite.getName(ParseMode.BrightScript)}"
            }`).ast.statements[0] as ReturnStatement;
            editor.arrayPush(test.functionStatement.func.body.statements, returnStatement);
        }
    }
}

export default () => {
    return new BsBenchPlugin();
}
