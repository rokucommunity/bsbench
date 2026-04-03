import * as readline from 'readline';
import { TelnetMonitor } from './TelnetMonitor';
import { logger } from './logging';
import { rokuDeploy } from 'roku-deploy';
import { ProgramBuilder, standardizePath as s } from 'brighterscript';

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

export class Runner {
    public constructor(
        public options: {
            host: string;
            password: string;
            only?: string[];
            cwd?: string;
        }
    ) {
        this.options.cwd = s`${__dirname}/../../`;

        this.telnetMonitor = new TelnetMonitor(options);
        this.telnetMonitor.on('lines', (event) => {
            for (const line of event.lines) {
                let statusJson = /^\s*bsbenchStatus:\s*(.+?)$/.exec(line)?.[1];
                if (statusJson) {
                    const status = JSON.parse(statusJson);
                    logger.log('Found test result', status);
                    this.results.push(status);
                }
                console.log(line);
            }
        });
    }

    private results = [] as TestResult[];

    async run() {
        logger.log('Running');
        await this.telnetMonitor.connect();

        //build the app
        await this.buildApp();

        //sideload the app
        await this.sideload();

        //register a long interval to keep the process alive, resolve a promise when it is finished
        await new Promise((resolve) => {
            setInterval(resolve, 1_000_000_000);
        });
    }

    private async buildApp() {
        logger.log('Building app');
        const builder = new ProgramBuilder();
        await builder.run({
            project: s`${__dirname}/../../bsconfig.json`,
            ...(this.options.only?.length ? { bsbenchOptions: { only: this.options.only } } as any : {})
        });
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

    private telnetMonitor: TelnetMonitor;

    public dispose() {
        rl.close();
        this.telnetMonitor.dispose();
    }
}

interface TestResult {
    /**
     * The name of the suite that this test belongs to
     */
    suiteName: string;
    /**
     * The name of the test
     */
    testName: string;
    /**
     * The operations per second this test was able to achieve
     */
    operationsPerSecond: number;
}
