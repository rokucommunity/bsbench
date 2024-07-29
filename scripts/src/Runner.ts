import * as readline from 'readline';
import { TelnetMonitor } from './TelnetMonitor';
import { logger } from './logging';
import { execSync } from 'child_process';
import { DeviceInfo, rokuDeploy } from 'roku-deploy';
import { standardizePath as s } from 'brighterscript';
import * as fsExtra from 'fs-extra';
import { suiteCatalogPath, SuiteInfo } from './common';

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

export class Runner {
    public constructor(
        public options: {
            host: string;
            password: string;
            cwd?: string;
        }
    ) {
        this.options.cwd = s`${__dirname}/../../`;

        this.telnetMonitor = new TelnetMonitor(options);
        this.telnetMonitor.on('lines', (event) => {
            for (const line of event.lines) {
                let statusJson = /^\s*bsbenchStatus:\s*(.+?)$/.exec(line)?.[1];
                if (statusJson) {
                    const testSample = JSON.parse(statusJson) as RawTestSampleData;
                    logger.log('Found test result', statusJson);
                    this.storeTestSample(testSample);
                }
                console.log(line);
            }
        });
    }

    async run() {
        logger.log('Running');
        await this.telnetMonitor.connect();

        //load the deviceInfo about this roku device
        this.deviceInfo = await rokuDeploy.getDeviceInfo({ host: this.options.host, enhance: true })

        //build the app
        await this.buildApp();

        //sideload the app
        await this.sideload();

        //register a long interval to keep the process alive, resolve a promise when it is finished
        await new Promise((resolve) => {
            setInterval(resolve, 1_000_000_000);
        });
    }

    private buildApp() {
        logger.log('Building app');
        execSync('npm run build', { cwd: `${__dirname}/../../`, stdio: 'inherit' });
        logger.log('App finished building');
    }

    private async sideload() {
        const options = {
            host: this.options.host,
            stagingDir: './dist',
            outDir: './out',
            outFile: 'bsbench.zip',
            cwd: this.options.cwd,
            password: this.options.password,
            logLevel: logger.logLevel
        };
        logger.log('Closing any existing channel');
        await rokuDeploy.closeChannel(options);

        logger.log('Zipping app');
        await rokuDeploy.zip(options);

        logger.log('Sideloading app');
        await rokuDeploy.sideload(options);
    }

    private deviceInfo: DeviceInfo;

    private telnetMonitor: TelnetMonitor;

    /**
     * Loaded on-demand by the first call to `getSuiteInfo`
     */
    private suiteCatalog: Record<string, SuiteInfo>;

    private getSuiteInfo(suiteKey: string): SuiteInfo {
        //load all the suite data
        if (!this.suiteCatalog) {
            this.suiteCatalog = fsExtra.readJsonSync(suiteCatalogPath);
        }
        return this.suiteCatalog[suiteKey];
    }

    private lastSeenRunId = undefined;

    private storeTestSample(sample: RawTestSampleData) {
        //if we got a brand new runId, clear all data and start fresh (we somehow read data from a previous run...)
        if (this.lastSeenRunId !== sample.runId) {
            this.results = {};
            console.error(`Found a new runId. We must have been tracking last run's data. Clearing all data and starting fresh`);
        }
        let suiteInfo = this.getSuiteInfo(sample.suiteKey);

        //create the suite if it doesn't exist
        if (!this.results[sample.suiteKey]) {
            this.results[sample.suiteKey] = {
                date: Date.now(),
                modelNumber: this.deviceInfo.modelNumber,
                softwareVersion: this.deviceInfo.softwareVersion,
                softwareBuild: this.deviceInfo.softwareBuild?.toString(),
                suiteKey: sample.suiteKey,
                tests: [],
                title: suiteInfo.name,
                description: suiteInfo.description,
                setupCode: suiteInfo.setupCode,
                teardownCode: suiteInfo.teardownCode
            };
        }
        const suite = this.results[sample.suiteKey];

        let test = suite.tests.find(x => x.testKey === sample.testKey);
        //create the test if it doesn't exist
        if (!test) {
            const testInfo = suiteInfo.tests.find(x => x.key === sample.testKey);
            test = {
                testKey: sample.testKey,
                name: testInfo.name,
                setupCode: testInfo.setupCode,
                teardownCode: testInfo.teardownCode,
                code: testInfo.code,
                description: testInfo.description,
                samples: []
            };
            suite.tests.push(test);
        }

        //add the sample
        test.samples.push({
            startTime: sample.startTime,
            endTime: sample.endTime,
            iterations: sample.iterations,
            targetDuration: sample.targetDuration
        });
    }

    /**
     * Dictionary of all suite results. The key is the suiteKey, the results is the full object for that suite
     */
    private results = {} as Record<string, BenchmarkSuiteResult>;


    public dispose() {
        rl.close();
        this.telnetMonitor.dispose();
    }
}

interface RawTestSampleData {
    /**
     * Unique ID for this run. This is the same for all tests in a single run.
     */
    runId: string;
    suiteKey: string;
    testKey: string;
    iterations: number;
    targetDuration: number;
    startTime: number;
    endTime: number;
}

interface BenchmarkSuiteResult {
    /**
     * The date the suite result was generated (in unix epoch milliseconds).
     * This equates to the time we received the first benchmark result from this suite's first test.
     */
    date: number;
    /**
     * Key for this suite (derived from the title, also same as one of the folder names)
     */
    suiteKey: string;
    /**
     * The title of the suite.
     */
    title: string;
    /**
     * The description of the benchmark. May be empty, and can contain markdown.
     */
    description?: string;
    /**
     * The body of any `setup` function for this suite, which is not included in the benchmark timings
     */
    setupCode?: string;
    /**
     * The body of any `teardown` function for this suite, which is not included in the benchmark timings
     */
    teardownCode?: string;
    /**
     * Model number of the device this suite was run on
     */
    modelNumber: string;
    /**
     * The version of the RokuOS this suite was run on
     */
    softwareVersion: string;
    /**
     * The build number of the OS this suite was run on.
     */
    softwareBuild: string;
    /**
     * The list of tests
     */
    tests: Array<{
        /**
         * Key for this test
         */
        testKey: string;
        /**
         * The name of this test
         */
        name: string;
        /**
         * The description of this test. Can contain markdown
         */
        description?: string;
        /**
         * Setup code defined just for this test, which is not included in the benchmark timings
         */
        setupCode?: string;
        /**
         * The code for this test. This is what is timed
         */
        code: string;
        /**
         * Teardown code defined just for this test, which is not included in the benchmark timings
         */
        teardownCode?: string;
        /**
         * The list of samples run for this suite
         */
        samples: Array<{
            /**
             * The number of iterations that will be run for the testing loop
             */
            iterations: number;
            /**
             * The number of milliseconds this sample was supposed to run for
             */
            targetDuration: number;
            /**
             * Time the test start (in unix epoch milliseconds)
             */
            startTime: number;
            /**
             * Time the test start (in unix epoch milliseconds)
             */
            endTime: number;
        }>
    }>;
}
