import * as net from 'net';
import { EventEmitter } from 'eventemitter3';
import { logger } from './logging';

export class TelnetMonitor {

    public constructor(
        private options: {
            host: string;
            port?: number;
        }
    ) {
        this.options.port ??= 8085;
    }

    private socket: net.Socket;

    private unhandledText = '';

    public async connect() {
        logger.log(`Establishing telnet connection to ${this.options.host}:${this.options.port}`);
        await this.establishConnection(this.options.host, this.options.port);

        logger.log('Waiting for telnet output to settle');
        await this.settle();

        logger.log('Telnet connection established and settled');
        this.socket.on('data', (data) => {
            this.unhandledText += data.toString();
            this.processUnhandledText();
        });
    }

    /**
     * Wait for the telnet output to stop sending new data
     */
    private settle() {
        return new Promise<void>((resolve) => {
            let timeoutHandle: NodeJS.Timeout;
            this.socket.on('data', () => {
                clearTimeout(timeoutHandle);

                //trash this data
                timeoutHandle = setTimeout(() => {
                    this.socket.removeAllListeners();
                    resolve();
                }, 400);
            });
        });
    }

    private async establishConnection(host: string, port: number) {
        await new Promise<void>((resolve, reject) => {
            this.socket = net.createConnection(port, host);

            this.socket.on('close', () => {
                this.socket.removeAllListeners();
                reject(new Error('Socket unexpectedly closed'));
            });

            this.socket.on('connect', () => {
                this.socket.removeAllListeners();
                resolve();
            });
        });
    }

    private processUnhandledText() {
        //only emit complete lines (those terminated by \r\n or \n)
        const terminator = /\r?\n/;
        if (!terminator.test(this.unhandledText)) {
            //no complete lines yet, keep buffering
            return;
        }

        //split into lines, keeping the incomplete last chunk in the buffer
        let lines = this.unhandledText.split(/\r?\n/);
        this.unhandledText = lines.pop(); //last element is always the incomplete remainder (may be '')

        this.emitter.emit('lines', { lines: lines });
    }

    private emitter = new EventEmitter();

    public on(event: 'lines', handler: (event: { lines: string[] }) => any): () => void;
    public on(event: string, handler: (...args: any[]) => any): () => void {
        this.emitter.on(event, handler);
        return () => {
            this.emitter.off(event, handler);
        }
    }

    public dispose() {
        this.socket.removeAllListeners();
        this.socket.destroy();
    }
}
