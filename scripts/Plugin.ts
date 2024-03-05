import { AfterFileAddEvent, AfterProgramCreateEvent, ArrayLiteralExpression, AssignmentStatement, BeforeBuildProgramEvent, BeforeFileValidateEvent, BrsFile, BscFile, CallExpression, ClassStatement, CommentStatement, CompilerPlugin, ConstStatement, Editor, ForStatement, FunctionParameterExpression, LiteralExpression, MethodStatement, ParseMode, Parser, ReturnStatement, Statement, TokenKind, TypeCastExpression, TypeExpression, VariableExpression, WalkMode, createIdentifier, createToken, createVariableExpression, isArrayLiteralExpression, isBrsFile, isClassStatement, isConstStatement, isMethodStatement } from "brighterscript";

class BsBenchPlugin implements CompilerPlugin {
    name = 'bsbench';

    beforeFileValidate(event: BeforeFileValidateEvent) {
        //add all the setup variables to each method in the suite
        for (const suite of this.findSuites(event.file)) {
            const setupMethod = this.findSetupMethod(suite);
            //if there's no setup method, skip this suite
            if (!setupMethod) {
                return;
            }
            for (const method of suite.methods) {
                //skip adding setup symbols to itself
                if (method === setupMethod) {
                    continue;
                }
                //add every variable from the setup method to this method
                method.func.body.getSymbolTable().addSibling(setupMethod.func.body.getSymbolTable());
            }
        }
    }

    beforeBuildProgram(event: BeforeBuildProgramEvent) {
        const allSuites: ClassStatement[] = [];
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

        //add every suite constructor to the bsbench.allSuites array
        const bsbenchFile = event.program.getFile<BrsFile>('source/bsbench.bs');

        //find the allSuites array
        const allSuitesConstArray = bsbenchFile.ast.findChild<ConstStatement>((x) => {
            return isConstStatement(x) && x.name.toLowerCase() === 'allsuites';
        })?.findChild(isArrayLiteralExpression) as ArrayLiteralExpression;

        if (allSuitesConstArray) {
            event.editor.arrayPush(
                allSuitesConstArray.elements,
                ...allSuites.map(suite => {
                    return new VariableExpression({
                        name: createIdentifier(suite.getName(ParseMode.BrightScript))
                    })
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
        return file.ast.findChildren<ClassStatement>((node) => {
            return isClassStatement(node) && !!node.annotations?.find(x => x.name.toLowerCase() === 'suite');
        });
    }

    //find the `setup` method in the suite (if there is one)
    private findSetupMethod(suite: ClassStatement) {
        const setupMethod = suite.methods.find(x => x.tokens.name.text.toLowerCase() === 'setup');
        return setupMethod;
    }

    private prepareSuite(editor: Editor, suite: ClassStatement) {
        const setupMethod = this.findSetupMethod(suite);
        //get the body of the `setup()` method
        const teardownMethod = suite.methods.find(x => x.tokens.name.text.toLowerCase() === 'teardown')!;
        //remove the setup and teardown methods from the suite
        if (setupMethod) {
            editor.arraySplice(suite.body, suite.body.indexOf(setupMethod), 1);
        }
        if (teardownMethod) {
            editor.arraySplice(suite.body, suite.body.indexOf(teardownMethod), 1);
        }

        //transform every benchmark method
        for (const method of suite.methods) {
            //remove all function parameters and inject the `iterations` param
            editor.arraySplice(
                method.func.parameters,
                0,
                method.func.parameters.length,
                new FunctionParameterExpression({
                    name: createIdentifier('iterations')
                })
            );

            //ensure we have `as dynamic` as the return type for this function
            editor.setProperty(method.func, 'returnTypeExpression', new TypeExpression({
                expression: new TypeExpression({
                    expression: createVariableExpression('dynamic')
                })
            }));

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
