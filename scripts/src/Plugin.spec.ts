import { Program, standardizePath as s } from "brighterscript";
import pluginFactory from './Plugin';
import * as fsExtra from 'fs-extra';
import { expect } from "chai";
import { Formatter } from 'brighterscript-formatter';

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

            expect(text).to.eql(expectedText);
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
    });
});
