import { standardizePath as s } from 'brighterscript';

export interface SuiteInfo {
    key: string;
    name: string;
    description: string;
    setupCode: string;
    teardownCode: string;
    tests: Array<{
        key: string;
        name: string;
        description: string;
        setupCode: string;
        code: string;
        teardownCode: string;
    }>
};

export const suiteCatalogPath = s`${__dirname}/../../dist/suiteCatalog.json`;
