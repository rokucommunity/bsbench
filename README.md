# bsbench
A benchmarking suite for Roku's BrightScript runtime (written in brighterscript)

## Steps to install:
```bash
git clone https://github.com/rokucommunity/bsbench
cd bsbench
npm install
```

## Running
### Through VSCode (recommended)
Open vscode, and start a new debug session to watch it run.
![Image](https://github.com/user-attachments/assets/47b651b2-2347-45dd-8822-9f88dd904e96)

![Image](https://github.com/user-attachments/assets/b2204179-d681-40fd-95a8-6ecd986bc5f5)


### Through the CLI
You can run the benchmark library from the cli as well. From within the project directory, run the following command (yes, the extra `--` is intentional):
```bash
npm run benchmark -- --host ROKU_IP_ADDRESS --password ROKU_DEV_PASSWORD
```

![Image](https://github.com/user-attachments/assets/b2204179-d681-40fd-95a8-6ecd986bc5f5)
