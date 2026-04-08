#!/usr/bin/env node
import * as yargs from 'yargs';
import * as prompts from 'prompts';
import * as fs from 'fs';
import * as path from 'path';
import { Runner } from './Runner';

let argv = yargs
    .usage('$0', 'bsbench, a benchmarking tool for Roku\'s BrightScript language')
    .help('help', 'View help information about this tool.')
    .option('host', { type: 'string', description: 'The hostname for the roku to test against', demandOption: true })
    .option('password', { type: 'string', description: 'The password for the roku to test against', demandOption: true })
    .option('only', { type: 'array', alias: ['grep'], string: true, description: 'Run only suites whose names match one of the given patterns (regex)' })
    .option('threads', { type: 'array', string: true, description: 'Run only the specified thread(s): main, render, task' })
    .argv;

async function main() {
    let only = argv.only as string[] | undefined;

    if (!only?.length) {
        const suiteNames = discoverSuiteNames();
        const response = await prompts({
            type: 'autocompleteMultiselect',
            name: 'suites',
            message: 'Which suites do you want to run? (type to filter, space to select)',
            choices: suiteNames.map(name => ({ title: name, value: name })),
            min: 0,
            instructions: false,
            hint: '- Space to select. Return to submit. Leave empty to run all.'
        });

        if (response.suites === undefined) {
            // user cancelled (ctrl+c)
            process.exit(0);
        }

        const selected = response.suites as string[];
        only = selected.length ? [`^(${selected.join('|')})$`] : undefined;
    }

    const options = { ...argv, only: only?.length ? only : undefined };
    const runner = new Runner(options);
    runner.run().catch(e => {
        console.error(e);
        process.exit(1);
    }).finally(() => {
        runner.dispose();
    });
}

function discoverSuiteNames(): string[] {
    const srcDir = path.resolve(__dirname, '../../src');
    const names: string[] = [];

    function walk(dir: string) {
        for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
            const fullPath = path.join(dir, entry.name);
            if (entry.isDirectory()) {
                walk(fullPath);
            } else if (entry.isFile() && entry.name.endsWith('.bs')) {
                const content = fs.readFileSync(fullPath, 'utf8');
                const match = content.match(/@suite\s*\(.*?\)\s*\n\s*namespace\s+(\S+)/);
                if (match) {
                    names.push(match[1]);
                }
            }
        }
    }

    walk(srcDir);
    return names.sort((a, b) => a.localeCompare(b));
}

main();
