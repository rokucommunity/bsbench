# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Is

**bsbench** is a benchmarking suite for Roku's BrightScript/SceneGraph runtime, written in BrighterScript (a typed superset of BrightScript). It measures operations-per-second for various BrightScript language constructs so developers can compare the relative cost of different coding patterns on real Roku hardware.

## Commands

```bash
npm install            # Install deps (postinstall runs: ropm copy)
npm run build          # Compile BrighterScript → BrightScript (output: ./dist/)
npm run benchmark -- --host ROKU_IP --password ROKU_DEV_PASSWORD  # Build + sideload + run
npm run package        # Package ./dist/ → ./out/bsbench.zip (no sideload)
npm run build-complib  # Build component library → ./dist/componentLibraries/complib.zip
```

To run a single benchmark suite, add `@only` annotation to the target namespace, then run normally. Remove before committing.

## Architecture

The system has four layers that work together at build-time and runtime:

### 1. Benchmark Source Files (`src/source/benchmarks/*.bs`)
Each file declares one suite via BrighterScript annotations:
- `@suite()` on a `namespace` — declares a suite; accepts optional config with `variants` map for parameterized runs
- `@test("name")` on a `sub`/`function` — declares a benchmark case
- `setup()` / `teardown()` inside the namespace — bodies get injected into every test by the plugin

### 2. BrighterScript Compiler Plugin (`scripts/src/Plugin.ts`)
The core build-time transformation engine, registered in `bsconfig.json`. It:
- Wraps each `@test` body in a `for __bsbench_i = 0 to iterations` loop
- Injects `setup()` and `teardown()` body statements into each test
- Sandwiches `roDateTime` calls around the loop for timing
- Expands `variants` configs into multiple suite entries
- Injects an `allSuites` const array into `bsbench.bs` — no runtime reflection needed

### 3. BrightScript Runtime (`src/source/bsbench.bs`)
Runs on the Roku device:
- Auto-calibrates iteration count: starts at 1, triples until run exceeds 50 ms, then scales to hit ~500 ms per sample
- Runs 5 samples per benchmark
- Emits `bsbenchStatus: <JSON>` lines to stdout (consumed by the Node.js orchestrator); disabled during debug sessions via `launch.json` `bsConst` override
- `bs_const=PRINT_STATUS=true` in `src/manifest` enables telnet output in benchmark runs

### 4. Node.js Orchestrator (`scripts/src/`)
- `cli.ts` — parses `--host`/`--password` args, runs `Runner`
- `Runner.ts` — builds, zips, sideloads via `roku-deploy`, listens on telnet, parses `bsbenchStatus:` JSON lines
- `TelnetMonitor.ts` — wraps a Node.js socket connecting to Roku's debug port 8085, emits buffered lines

### Component Library (`complib/`)
A separate Roku component library (`BrsComponent`, `XmlComponent`) used by the `ComponentCreation` benchmark. Has its own `complib/bsconfig.json`.

## Key Config Files

| File | Purpose |
|---|---|
| `bsconfig.json` | BSC config: `rootDir=./src`, `stagingDir=./dist`, registers `scripts/src/Plugin.ts` as compiler plugin |
| `src/manifest` | Roku manifest; `bs_const=PRINT_STATUS=true` enables telnet status output |
| `.vscode/launch.json` | Debug config; overrides `PRINT_STATUS=false` to silence telnet JSON during interactive debugging |
