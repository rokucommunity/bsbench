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

    describe('injectSuiteData', () => {
        async function doTest(expectedAAText: string) {
            program.setFile('source/bsbench.bs', `
                namespace bsbench
                    const allSuites = [] as BenchmarkSuite[]
                    function runSync(options as RunOptions)
                        suites = allSuites
                    end function
                end namespace
            `);
            await program.build();
            const formatter = new Formatter();
            const text = formatter.format(
                fsExtra.readFileSync(s`${stagingDir}/source/bsbench.brs`).toString()
            );
            const expectedText = formatter.format(`
                function bsbench_runSync(options as dynamic)
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
                        variant: {}
                        tests: [
                            {
                                name: "TestOne"
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
                        variant: {}
                        tests: [
                            {
                                name: "test1"
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
                        variant: {}
                        tests: [
                            {
                                name: "test1"
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
                        variant: {}
                        tests: [
                            {
                                name: "test1"
                                func: AlphaSuite_TestOne
                            }
                        ]
                    }
                ]
            `);
        });
    });
});
