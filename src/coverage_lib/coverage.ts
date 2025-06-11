import fs from 'fs'
import path from 'path'
import { CoverageReport } from 'monocart-coverage-reports'

// Bazel will create the COVERAGE_OUTPUT_FILE whilst setting up the sandbox.
// Therefore, should be doing a file size check rather than presence.
try {
    const stats = fs.statSync(process.env.COVERAGE_OUTPUT_FILE)
    if (stats.size !== 0) {
        // early exit here does not affect the outcome of the tests.
        // bazel will only execute _lcov_merger when tests pass.
        process.exit(0)
    }
} catch {
    // ignore if file doesn't exist or throws
}

// Read coverage manifest
const include = fs
    .readFileSync(process.env.COVERAGE_MANIFEST, 'utf8')
    .split('\n')
    .filter((f) => f !== '')
    .map(f => f.replace(/^bazel-out\/[^/]+\/bin\//, ''));

const pwd = path.join(process.env.RUNFILES, process.env.TEST_WORKSPACE)
process.chdir(pwd)

const coverageDir = process.env.COVERAGE_DIR
const outputFile = process.env.COVERAGE_OUTPUT_FILE

const outputDir = path.dirname(outputFile)
const outputFileName = path.basename(outputFile)

const includeMappedSet = new Set(include.map(f => `file://${path.join(pwd, f)}`));

const report = new CoverageReport({
    dataDir: coverageDir,
    entryFilter: (item) => {
        const itemUrl = typeof item === 'string' ? item : item.url
        return includeMappedSet.has(itemUrl)
    },
    reports: [
        ['lcovonly', { file: outputFileName }], 
    ],
    outputDir,
})
report.cleanCache()
report.generate()
    .then(() => {
        if (!fs.existsSync(outputFile)) {
            console.error(`Coverage report not found in ${outputFile}`)
        }
    })
    .catch((err: unknown) => {
        console.error(err)
        process.exit(1)
    })
