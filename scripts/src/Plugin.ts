import { AALiteralExpression, AAMemberExpression, AfterFileAddEvent, AfterProgramCreateEvent, AfterProgramValidateEvent, AnnotationExpression, ArrayLiteralExpression, AssignmentStatement, BeforeBuildProgramEvent, BeforeFileValidateEvent, BrsFile, BrsTranspileState, BscFile, CompilerPlugin, ConstStatement, DiagnosticSeverity, Editor, Expression, ForStatement, FunctionParameterExpression, FunctionStatement, NamespaceStatement, ParseMode, Parser, Program, ReturnStatement, TokenKind, TypeExpression, WalkMode, XmlFile, createIdentifier, createSGScript, createToken, createVariableExpression, createVisitor, isAALiteralExpression, isArrayLiteralExpression, isBrsFile, isConstStatement, isFunctionStatement, isNamespaceStatement, isTemplateStringExpression, isVariableExpression, isXmlFile } from "brighterscript";
import { SourceNode } from 'source-map';

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
        for (const suite of this.findSuites(event.file)) {
            for (const test of this.findTests(suite)) {
                const userParams = test.functionStatement.func.parameters.filter(p => !!p.location?.uri);
                if (userParams.length > 0) {
                    event.program.diagnostics.register({
                        location: userParams[0].location,
                        severity: DiagnosticSeverity.Error,
                        code: 'bsbench-test-params',
                        message: `@test functions may not define parameters`
                    });
                }
            }
        }

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
        this.injectSuiteImports(event, allSuites);
    }

    private injectSuiteImports(event: BeforeBuildProgramEvent, allSuites: Suite[]) {
        for (const xmlPath of ['components/MainScene.xml', 'components/TestTask.xml']) {
            const xmlFile = event.program.getFile<XmlFile>(xmlPath);
            if (!isXmlFile(xmlFile)) {
                continue;
            }
            const elements = xmlFile.ast.componentElement.elements;
            const alreadyImported = new Set(
                xmlFile.ast.componentElement.scriptElements.map(s => s.getAttribute('uri')?.value)
            );
            let lastScriptIdx = -1;
            for (let i = 0; i < elements.length; i++) {
                if ((elements[i] as any).tokens?.startTagName?.text?.toLowerCase() === 'script') {
                    lastScriptIdx = i;
                }
            }
            let insertIndex = lastScriptIdx + 1;
            for (const suite of allSuites) {
                const uri = 'pkg:/' + suite.file.destPath.replace(/\.bs$/, '.brs');
                if (alreadyImported.has(uri)) {
                    continue;
                }
                const script = createSGScript({ type: 'text/brightscript', uri });
                event.editor.arraySplice(elements, insertIndex++, 0, script);
                alreadyImported.add(uri);
            }
        }
    }

    private injectSuiteData(event: BeforeBuildProgramEvent, allSuites: Suite[]) {
        //add every suite constructor to the bsbench.allSuites array
        const bsbenchFile = event.program.getFile<BrsFile>('source/bsbench.bs');

        //find the allSuites array
        const allSuitesConstArray = bsbenchFile.ast.findChild<ConstStatement>((x) => {
            return isConstStatement(x) && x.name.toLowerCase() === 'allsuites';
        })?.findChild(isArrayLiteralExpression) as ArrayLiteralExpression;

        const filterPatterns: string[] = (event.program.options as any)?.bsbenchOptions?.only ?? [];
        const threadFilter: string[] = (event.program.options as any)?.bsbenchOptions?.threads ?? [];
        let atOnlySuites = allSuites.filter(x => x.namespaceStatement.annotations?.find(x => x.name.toLowerCase() === 'only'));
        let suitesToRun = atOnlySuites.length > 0 ? atOnlySuites
            : filterPatterns.length > 0 ? allSuites.filter(x => filterPatterns.some(p => new RegExp(p, 'i').test(x.name)))
            : allSuites;

        if (atOnlySuites.length > 0) {
            console.log(`[bsbench] Running ${suitesToRun.length} of ${allSuites.length} suites (@only):\n${suitesToRun.map(x => `  - ${x.name}`).join('\n')}`);
        } else if (filterPatterns.length > 0) {
            console.log(`[bsbench] Running ${suitesToRun.length} of ${allSuites.length} suites (--only: ${filterPatterns.map(p => `/${p}/i`).join(', ')}):\n${suitesToRun.map(x => `  - ${x.name}`).join('\n')}`);
        }
        if (suitesToRun.length === 0) {
            throw new Error('[bsbench] No suites matched — nothing to run');
        }
        if (allSuitesConstArray) {
            const suitesAst = suitesToRun.map(suite => {
                const variants = this.getVariants(suite);
                const threads = threadFilter.length > 0
                    ? suite.config.supportedThreads.filter(t => threadFilter.includes(t))
                    : suite.config.supportedThreads;

                // build the variants array entries: one AA per variant combination
                const variantEntries = variants.map(variant => {
                    const variantValues = Object.fromEntries(
                        Object.entries(variant).map(([key, value]) => {
                            return [
                                key,
                                new SourceNode(
                                    null,
                                    null,
                                    suite.file.srcPath,
                                    value.transpile(new BrsTranspileState(suite.file)) as any,
                                ).toString().replace(/^"/, "'").replace(/"$/, "'")
                            ];
                        })
                    );

                    const variantText = Object.keys(variant).length > 0
                        ? ' (' + Object.keys(variant).map(k => `${k}: ${variantValues[k]}`).join(', ') + ')'
                        : '';

                    // parse a placeholder AA, then replace its elements with the real expressions
                    const variantCode = `v = { __name: "${variantText}" }`;
                    const variantParser = Parser.parse(variantCode);
                    const variantAA = variantParser.ast.findChild<AALiteralExpression>(isAALiteralExpression);
                    (variantAA.elements[0].value as any) = new AALiteralExpression({ elements: [] }); // clear placeholder
                    (variantAA as any).elements = [
                        new AAMemberExpression({ key: createToken(TokenKind.StringLiteral, '__name'), value: Parser.parse(`s = "${variantText}"`).ast.statements[0]['value'] }),
                        ...Object.keys(variant).map(key => new AAMemberExpression({
                            key: createToken(TokenKind.StringLiteral, key),
                            value: variant[key]
                        }))
                    ];
                    return (variantParser.ast.statements[0] as AssignmentStatement).value;
                });

                const code = `
                    aa = {
                        name: "${suite.name}",
                        allowedThreads: [${threads.map(t => `"${t}"`).join(', ')}],
                        variants: [],
                        tests: [
                            ${this.findTests(suite).map((test) => `{
                                name: ${this.toBrsString(test.name)}
                                func: ${test.functionName}
                            }`).join(', ')}
                        ]
                    }
                `;
                const parser = Parser.parse(code);
                if (parser.diagnostics.length > 0) {
                    throw new Error('Failed to parse suite data: \n' + parser.diagnostics.map(x => x.message).join('\n') + '\nRaw code: \n' + code);
                }
                // replace the empty variants array with the real variant expressions
                const suiteAA = parser.ast.findChild<AALiteralExpression>(isAALiteralExpression);
                const variantsElement = suiteAA.elements.find(e => e.tokens?.key?.text === 'variants');
                event.editor.arrayPush((variantsElement.value as ArrayLiteralExpression).elements, ...variantEntries);

                return (parser.ast.statements[0] as AssignmentStatement).value;
            });

            //push suite data to the allSuites array
            event.editor.arrayPush(allSuitesConstArray.elements, ...suitesAst);
        }
    }

    /**
     * Convert a string to a brightscript-safe string (including the leading and trailing quotemarks).
     * This will escape quotes, encode newline chars, etc
     */
    private toBrsString(text: string) {
        const parser = Parser.parse(`s = \`${text}\``);
        const chunks = parser.ast.findChild(isTemplateStringExpression).transpile(
            new BrsTranspileState(
                new BrsFile({ srcPath: '', destPath: '', program: new Program({}) })
            )
        );
        const result = new SourceNode(null, null, null, chunks as any).toString();
        return result;
    }

    /**
     * Build a unique list of all variant combinations. If no variants were provided,
     * return a single empty object so we at least have one entry
     * @param suite
     */
    private getVariants(suite: Suite) {
        // Start with an initial list containing an empty object
        let currentCombinations: Array<Record<string, Expression>> = [{}];

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
                const suiteAnnotation = x.annotations?.find(x => x.name.toLowerCase() === 'suite');
                const arg0 = suiteAnnotation.getArguments()[0];
                if (typeof arg0 === 'string') {
                    config.name = arg0;
                } else if (typeof arg0 === 'object') {
                    config = arg0;
                }

                const suite: Suite = {
                    namespaceStatement: x,
                    config: config,
                    name: this.getNameFromAnnotation(x),
                    file: file
                };

                //transform the variants object to contain the original expressions for each variant
                const variants = (suiteAnnotation.call.args[0] as AALiteralExpression)?.elements?.find(x => x?.tokens?.key?.text === 'variants')?.value;
                if (isAALiteralExpression(variants)) {
                    suite.config.variants = {};
                    for (const element of variants.elements) {
                        const key = element.tokens.key.text;
                        const value = element.value;

                        suite.config.variants[key] = [];

                        if (isArrayLiteralExpression(value)) {
                            for (const item of value.elements) {
                                suite.config.variants[key].push(item);
                            }
                        } else {
                            console.error('Unsupported variant type');
                        }
                    }
                }

                suite.config.variants ??= {};

                //parse supportedThreads from annotation, default to all three
                const supportedThreadsArg = (suiteAnnotation.call.args[0] as AALiteralExpression)?.elements?.find(x => x?.tokens?.key?.text === 'supportedThreads')?.value;
                if (isArrayLiteralExpression(supportedThreadsArg)) {
                    suite.config.supportedThreads = supportedThreadsArg.elements.map(e => {
                        return new SourceNode(null, null, suite.file.srcPath, e.transpile(new BrsTranspileState(suite.file)) as any).toString().replace(/^["']|["']$/g, '');
                    });
                } else {
                    suite.config.supportedThreads = ['main', 'render', 'task'];
                }

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
        let result = '';
        //get the name of the test (either the string from the `@test` annotation or the function name)
        if (typeof arg0 === 'string') {
            result = arg0;
        } else if (typeof arg0?.name === 'string') {
            result = arg0.name;
        } else {
            result = node.getName(ParseMode.BrightScript);
        }
        return result;
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
            const forLoop = Parser.parse('for __bsbench_i = 0 to iterations - 1\nend for').ast.statements[0] as ForStatement;
            editor.setProperty(forLoop.body, 'statements', test.functionStatement.func.body.statements);
            editor.setProperty(test.functionStatement.func.body, 'statements', [forLoop]);

            //insert timespan immediately before the loop; Mark() is called automatically on creation
            const startTimeAssignment = Parser.parse(`__benchmarkTimeSpan = CreateObject("roTimeSpan")`).ast.statements[0] as AssignmentStatement;
            editor.arrayUnshift(test.functionStatement.func.body.statements, startTimeAssignment);

            //capture elapsed microseconds after the loop
            const endTimeAssignment = Parser.parse(`__benchmarkElapsedMicroseconds = __benchmarkTimeSpan.TotalMicroseconds()`).ast.statements[0] as AssignmentStatement;
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

            //suppress unused variable warnings for all locals and parameters in this function.
            //collect every variable name assigned anywhere in the function body, plus all parameters
            const assignedNames = new Set<string>();
            test.functionStatement.func.body.walk(createVisitor({
                AssignmentStatement: (node) => { assignedNames.add(node.tokens.name.text); },
                CatchStatement: (node) => {
                    if (isVariableExpression(node.exceptionVariableExpression)) {
                        assignedNames.add(node.exceptionVariableExpression.tokens.name.text);
                    }
                }
            }), { walkMode: WalkMode.visitStatements });
            for (const param of test.functionStatement.func.parameters) {
                assignedNames.add(param.tokens.name.text);
            }
            //remove bsbench-internal vars that don't need suppression
            assignedNames.delete('__bsbench_i');
            assignedNames.delete('__benchmarkTimeSpan');
            assignedNames.delete('__benchmarkElapsedMicroseconds');
            if (assignedNames.size > 0) {
                const suppressStatement = Parser.parse(
                    `__bsbench_suppressVarWarnings = [${[...assignedNames].join(', ')}]`
                ).ast.statements[0] as AssignmentStatement;
                editor.arrayPush(test.functionStatement.func.body.statements, suppressStatement);
            }

            //append a statement that returns the test results
            const returnStatement = Parser.parse(`return {
                elapsedMicroseconds: __benchmarkElapsedMicroseconds
                iterations: iterations
                name: "${test.name}"
                suiteName: "${suite.name}"
            }`).ast.statements[0] as ReturnStatement;
            editor.arrayPush(test.functionStatement.func.body.statements, returnStatement);
        }

        //remove setup/teardown from the output — they've been inlined into each test
        //and emitting them standalone only produces unused variable warnings
        const stmts = suite.namespaceStatement.body.statements;
        if (setupFunction) {
            const idx = stmts.indexOf(setupFunction);
            if (idx >= 0) { editor.arraySplice(stmts, idx, 1); }
        }
        if (teardownFunction) {
            const idx = stmts.indexOf(teardownFunction);
            if (idx >= 0) { editor.arraySplice(stmts, idx, 1); }
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
        variants: Record<string, Expression[]>;
        /**
         * The threads this suite should run on. Defaults to ["main", "render", "task"]
         */
        supportedThreads: string[];
    };
    file: BrsFile;
}

export default () => {
    return new BsBenchPlugin();
}
