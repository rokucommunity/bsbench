#!/usr/bin/env node
import * as yargs from 'yargs';
import { Runner } from './Runner';

let options = yargs
    .usage('$0', 'bsbench, a benchmarking tool for Roku\'s BrightScript language')
    .help('help', 'View help information about this tool.')
    .option('host', { type: 'string', description: 'The hostname for the roku to test against', demandOption: true })
    .option('password', { type: 'string', description: 'The password for the roku to test against', demandOption: true })
    .argv;

const runner = new Runner(options);
runner.run().catch(e => {
    console.error(e);
    process.exit(1);
}).finally(() => {
    runner.dispose();
});
