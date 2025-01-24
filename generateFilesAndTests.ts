/**
 * This script generates a large number of .ts files and corresponding test files.
 * The .ts files contain a function that returns a message and a large amount of filler content.
 * The purpose of this is to simulate a large codebase with many files and tests, as differences
 * in build performance don't become apparent until the codebase reaches a certain size.
 * 
 * The generated files are placed in the src/__generated__ directory.
 * 
 * Usage:
 *      N=1000 FILE_SIZE=10 pnpm tsx generateFilesAndTests.ts
 */

import * as fs from 'fs';
import * as path from 'path';

// Configuration
const n = parseInt(process.env.N || '') || 1000; // Number of files to create
const outputDir = path.resolve(__dirname, 'src/__generated__'); // Directory for .ts files
const fileSizeInKB = parseInt(process.env.FILE_SIZE || '') || 10; // Approximate size of each .ts file in KB

// Utilities
function createLargeContent(sizeInKB: number): string {
    const fillerLine = (i: number) => `export const filler${i} = "${'a'.repeat(100)}";\n`;
    const linesNeeded = (sizeInKB * 1000) / fillerLine(Math.sqrt(n)).length;
    return Array.from({ length: Math.ceil(linesNeeded) }, (_, i) => fillerLine(i)).join('');
}

function createFile(filePath: string, content: string) {
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Created: ${filePath}`);
}

// Create directories if they don't exist
function ensureDirectory(dir: string) {
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
        console.log(`Created directory: ${dir}`);
    }
}

// Generate .ts and test files
function generateFilesAndTests() {
    ensureDirectory(outputDir);

    for (let i = 1; i <= n; i++) {
        const fileName = `file${i}.ts`;
        const testFileName = `file${i}.test.ts`;

        // Create .ts file
        const fileContent = `
export function getFile${i}Message(): string {
    return "Hello from file${i}!";
}

${createLargeContent(fileSizeInKB)}
`;
        createFile(path.join(outputDir, fileName), fileContent);

        // Create Mocha test file
        const testContent = `
import { getFile${i}Message } from "./file${i}";
import { expect } from "chai";

describe("file${i} Tests", () => {
    it("should return the correct message", () => {
        const message = getFile${i}Message();
        expect(message).to.equal("Hello from file${i}!");
    });
});
`;
        createFile(path.join(outputDir, testFileName), testContent);
    }
}

generateFilesAndTests();
