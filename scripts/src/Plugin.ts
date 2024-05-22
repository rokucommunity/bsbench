import { AfterFileAddEvent, AfterProgramCreateEvent, AfterProgramValidateEvent, AnnotationExpression, ArrayLiteralExpression, AssignmentStatement, BeforeBuildProgramEvent, BeforeFileValidateEvent, BrsFile, BrsTranspileState, BscFile, CompilerPlugin, ConstStatement, DynamicType, Editor, ForStatement, FunctionParameterExpression, FunctionStatement, InterfaceType, LiteralExpression, NamespaceStatement, ParseMode, Parser, ReturnStatement, SymbolTypeFlag, TokenKind, TypeExpression, createIdentifier, createToken, createVariableExpression, isArrayLiteralExpression, isBrsFile, isConstStatement, isFunctionStatement, isLiteralString, isNamespaceStatement, isTemplateStringExpression } from "brighterscript";

class BsBenchPlugin implements CompilerPlugin {
    name = 'bsbench';

    afterProgramCreate(event: AfterProgramCreateEvent) {
    }

    afterFileAdd(event: AfterFileAddEvent<BscFile>) {
        if (isBrsFile(event.file)) {
            for (const suite of this.findSuites(event.file)) {
                //inject a `variant` parameter
                this.findFunction(suite, 'setup')?.func.parameters.push(new FunctionParameterExpression({
                    name: createIdentifier('variant')
                }));
                //inject a `variant` parameter
                this.findFunction(suite, 'teardown')?.func.parameters.push(new FunctionParameterExpression({
                    name: createIdentifier('variant')
                }));

                const tests = this.findTests(suite);
                for (let i = 0; i < tests.length; i++) {
                    const test = tests[i];
                    //if the function is named `_`, give it an auto-generated name instead to prevent collisions
                    if (test.functionStatement.tokens.name.text === '_') {
                        test.functionStatement.tokens.name.text = `test${i}`;
                    }
                    //inject a `variant` parameter
                    test.functionStatement.func.parameters.push(new FunctionParameterExpression({
                        name: createIdentifier('variant')
                    }));
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
        const allSuites: Suite[] = [];
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

    private injectSuiteData(event: BeforeBuildProgramEvent, allSuites: Suite[]) {
        //add every suite constructor to the bsbench.allSuites array
        const bsbenchFile = event.program.getFile<BrsFile>('source/bsbench.bs');

        //find the allSuites array
        const allSuitesConstArray = bsbenchFile.ast.findChild<ConstStatement>((x) => {
            return isConstStatement(x) && x.name.toLowerCase() === 'allsuites';
        })?.findChild(isArrayLiteralExpression) as ArrayLiteralExpression;

        let atOnlySuites = allSuites.filter(x => x.namespaceStatement.annotations?.find(x => x.name.toLowerCase() === 'only'));
        let suitesToRun = atOnlySuites.length > 0 ? atOnlySuites : allSuites;

        if (allSuitesConstArray) {
            //create an AA for every variation of every suite
            const suitesAst = suitesToRun.map(suite => {
                const variants = this.getVariants(suite);
                let statements = [];
                for (const variant of variants) {
                    const variantText = Object.keys(variant).length > 0
                        ? ' (' + Object.keys(variant).map(x => `${x}: ${JSON.stringify(variant[x])}`).join(', ') + ')'
                        : '';
                    const code = `
                        aa = {
                            name: "${suite.name}${variantText}",
                            variant: ${JSON.stringify(variant)},
                            tests: [
                                ${this.findTests(suite).map((test) => `{
                                    name: "${test.name}"
                                    func: ${test.functionName}
                                }`).join(', ')}
                            ]
                        }
                    `;
                    const parser = Parser.parse(code);
                    if (parser.diagnostics.length > 0) {
                        throw new Error('Failed to parse suite data: \n' + parser.diagnostics.map(x => x.message).join('\n') + '\nRaw code: \n' + code);
                    }
                    const ast = (parser.ast.statements[0] as AssignmentStatement).value;
                    statements.push(ast);
                }
                return statements;
            }).flat();

            //push suite data to the allSuites array
            event.editor.arrayPush(allSuitesConstArray.elements, ...suitesAst);
        }
    }

    /**
     * Build a unique list of all variant combinations. If no variants were provided,
     * return a single empty object so we at least have one entry
     * @param suite
     */
    private getVariants(suite: Suite) {
        // Start with an initial list containing an empty object
        let currentCombinations = [{}];

        // Process each key in the variant map
        for (const key of Object.keys(suite.config.variants)) {
            const newCombinations: any[] = [];

            // For each existing combination, expand it with each value from the current key's array
            for (const combination of currentCombinations) {
                for (const value of suite.config.variants[key]) {
                    // Create a new combination by copying the existing one and adding the new key-value pair
                    const newCombination = { ...combination, [key]: value };
                    newCombinations.push(newCombination);
                }
            }

            // Replace the current combinations with the newly expanded list
            currentCombinations = newCombinations;
        }

        //return a single empty object if we have no variants
        if (currentCombinations === undefined) {
            return [{}];
        }
        return currentCombinations;
    }

    /**
     * Find all suite classes in the file
     * @param file
     * @returns
     */
    private findSuites(file: BscFile): Suite[] {
        if (!isBrsFile(file)) {
            return []
        }
        return file.ast.findChildren<NamespaceStatement>((node) => {
            return isNamespaceStatement(node) && !!node.annotations?.find(x => x.name.toLowerCase() === 'suite');
        }).map(x => {
            try {
                let config = {} as any;
                const arg0 = x.annotations?.find(x => x.name.toLowerCase() === 'suite').getArguments()[0];
                if (typeof arg0 === 'string') {
                    config.name = arg0;
                } else if (typeof arg0 === 'object') {
                    config = arg0;
                }
                config.variants ??= {};

                const suite: Suite = {
                    namespaceStatement: x,
                    config: config,
                    name: this.getNameFromAnnotation(x),
                    file: file
                };

                suite.config.variants ??= {};
                return suite;
            } catch (e) {
                console.log(e);
            }
        });
    }

    //find the `setup` method in the suite (if there is one)
    private findFunction(suite: Suite, name: string) {
        return suite.namespaceStatement.findChild<FunctionStatement>(x => isFunctionStatement(x) && x.tokens.name.text.toLowerCase() === name.toLowerCase());
    }

    private getNameFromAnnotation(node: FunctionStatement | NamespaceStatement) {
        const annotation = node.annotations?.find(x => x.name.toLowerCase() === 'test');
        const arg0 = annotation?.getArguments()[0] as string | Record<string, any> | undefined;
        //get the name of the test (either the string from the `@test` annotation or the function name)
        if (typeof arg0 === 'string') {
            return arg0;
        } else if (typeof arg0?.name === 'string') {
            return arg0.name;
        } else {
            return node.getName(ParseMode.BrightScript);
        }
    }

    private findTests(suite: Suite) {
        return suite.namespaceStatement.body
            .findChildren<FunctionStatement>(isFunctionStatement)
            .map(func => {
                const annotation = func.annotations?.find(x => x.name.toLowerCase() === 'test');

                return {
                    functionStatement: func,
                    annotation: annotation,
                    name: this.getNameFromAnnotation(func),
                    functionName: func.getName(ParseMode.BrightScript)
                }
            })
            //discard any functions that don't have a `@test` annotation
            .filter(x => !!x.annotation);
    }

    private prepareSuite(editor: Editor, suite: Suite) {
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
                //add the `iterations` parameter
                new FunctionParameterExpression({
                    name: createIdentifier('iterations')
                }),
                //add the `variant` parameter
                new FunctionParameterExpression({
                    name: createIdentifier('variant')
                }),
            );

            //ensure we have `as dynamic` as the return type for this function
            editor.setProperty(test.functionStatement.func, 'returnTypeExpression', new TypeExpression({
                expression: new TypeExpression({
                    expression: createVariableExpression('dynamic')
                })
            }));

            //wrap the entire body of the function in a for loop
            const forLoop = Parser.parse('for __bsbench_i = 0 to iterations\nend for').ast.statements[0] as ForStatement;
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
                name: "${test.name}"
                suiteName: "${suite.name}"
            }`).ast.statements[0] as ReturnStatement;
            editor.arrayPush(test.functionStatement.func.body.statements, returnStatement);
        }
    }
}

interface Suite {
    name: string;
    namespaceStatement: NamespaceStatement;
    /**
     * The configuration for this suite
     */
    config?: {
        /**
         * Every entry is the name of a local variable, with an array of values (each value is one variant of the benchmark suite)
         */
        variants: Record<string, any[]>
    };
    file: BrsFile;
}

export default () => {
    return new BsBenchPlugin();
}
