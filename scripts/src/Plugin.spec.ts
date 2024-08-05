import { Program, standardizePath as s } from "brighterscript";
import pluginFactory from './Plugin';
import * as fsExtra from 'fs-extra';
import { expect } from "chai";
import { Formatter } from 'brighterscript-formatter';
import { undent } from 'undent';

const tempDir = s`${__dirname}/../../.tmp`;
const rootDir = s`${tempDir}/rootDir`;
const stagingDir = s`${tempDir}/stagingDir`;

describe('Plugin', () => {
    let program: Program;

    beforeEach(() => {
        fsExtra.emptydirSync(tempDir);
        program = new Program({
            rootDir: rootDir,
            stagingDir: stagingDir
        });
        //add our plugin
        program.plugins.add(pluginFactory());
    });

    afterEach(() => {
        fsExtra.removeSync(tempDir);
    });

    function expectDiagnostics(expectedDiagnosticMessages: string[]) {
        expect(
            program.getDiagnostics().map(x => {
                return [
                    x.location.range.start.line,
                    ':',
                    x.location.range.start.character,
                    '-',
                    x.location.range.end.line,
                    ':',
                    x.location.range.end.character,
                    ' ',
                    x.message
                ].join('');
            })
        ).to.eql(
            expectedDiagnosticMessages
        );
    }

    describe('injectSuiteData', () => {
        async function doTest(expectedAAText: string) {
            program.setFile('source/bsbench.bs', `
                namespace bsbench
                    const allSuites = []
                    function runSync(options)
                        suites = allSuites
                    end function
                end namespace
            `);
            await program.validate();
            expect(program.getDiagnostics()).to.eql([]);
            await program.build();
            const formatter = new Formatter();
            const text = formatter.format(
                fsExtra.readFileSync(s`${stagingDir}/source/bsbench.brs`).toString()
            );
            const expectedText = formatter.format(`
                function bsbench_runSync(options)
                    suites = (${expectedAAText.trim()})
                end function
            `);

            expect(
                undent(text)
            ).to.eql(
                undent(expectedText)
            );
        }

        it('handles simple names', async () => {
            program.setFile('source/benchmarks/simple.bs', `
                @suite()
                namespace AlphaSuite
                    @test()
                    function TestOne()
                    end function
                end namespace
            `);
            await doTest(`
                [
                    {
                        name: "AlphaSuite"
                        key: "alpha-suite"
                        variant: {}
                        tests: [
                            {
                                name: "TestOne"
                                key: "test-one"
                                func: AlphaSuite_TestOne
                            }
                        ]
                    }
                ]
            `);
        });

        it('handles string suite and test names', async () => {
            program.setFile('source/benchmarks/simple.bs', `
                @suite("alpha")
                namespace AlphaSuite
                    @test("test1")
                    function TestOne()
                    end function
                end namespace
            `);
            await doTest(`
                [
                    {
                        name: "alpha"
                        key: "alpha"
                        variant: {}
                        tests: [
                            {
                                name: "test1"
                                key: "test1"
                                func: AlphaSuite_TestOne
                            }
                        ]
                    }
                ]
            `);
        });

        it('handles template string suite and test names', async () => {
            program.setFile('source/benchmarks/simple.bs', `
                @suite(\`alpha\`)
                namespace AlphaSuite
                    @test(\`test1\`)
                    function TestOne()
                    end function
                end namespace
            `);
            await doTest(`
                [
                    {
                        name: "alpha"
                        key: "alpha"
                        variant: {}
                        tests: [
                            {
                                name: "test1"
                                key: "test1"
                                func: AlphaSuite_TestOne
                            }
                        ]
                    }
                ]
            `);
        });

        it('handles template string suite and test names in objects', async () => {
            program.setFile('source/benchmarks/simple.bs', `
                @suite({ name: \`alpha\` })
                namespace AlphaSuite
                    @test({ name: \`test1\` })
                    function TestOne()
                    end function
                end namespace
            `);
            await doTest(`
                [
                    {
                        name: "alpha"
                        key: "alpha"
                        variant: {}
                        tests: [
                            {
                                name: "test1"
                                key: "test1"
                                func: AlphaSuite_TestOne
                            }
                        ]
                    }
                ]
            `);
        });
    });

    it('flags using quotes or newlines inside template strings', async () => {
        program.setFile('source/benchmarks/simple.bs', `
            @suite(\`CreateObject("roSGNode", "Group").update(...)\`)
            namespace AlphaSuite
                @test(\`CreateObject("roSGNode", "Group").update(...)\`)
                function TestOne()
                end function
            end namespace
        `);
        program.validate();
        expectDiagnostics([
            '1:19-1:66 Name cannot contain quotes or newlines',
            '3:22-3:69 Name cannot contain quotes or newlines'
        ]);
    });
});
