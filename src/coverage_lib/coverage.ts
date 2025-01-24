import path from "path";
import fs from "fs";
import libCoverage, { CoverageMap } from "istanbul-lib-coverage";
import libReport from "istanbul-lib-report";
import reports from "istanbul-reports";
import v8toIstanbul from "v8-to-istanbul";

//#region Copied from https://github.com/aspect-build/rules_js/blob/v1.34.0/js/private/coverage/bundle/c8.js with some modifications
const include = fs
  .readFileSync(process.env.COVERAGE_MANIFEST!)
  .toString('utf8')
  .split('\n')
  .filter((f) => f != '')
  .map((f) => f.replace(/^bazel-out\/[^/]+\/bin\//, ''));

const pwd = path.join(process.env.RUNFILES, process.env.TEST_WORKSPACE)
process.chdir(pwd)
//#endregion

type V8CoverageJson = {
  result: {
    url: string;
    functions: {
      functionName: string;
      isBlockCoverage: boolean;
      ranges: {
        startOffset: number;
        endOffset: number;
        count: number;
      }[];
    }[];
  }[];
};

const createCoverageMap = async (coveragePath: string) => {
  const map = libCoverage.createCoverageMap();

  const coverageJsonFiles = fs.statSync(coveragePath).isDirectory()
    ? fs.readdirSync(coveragePath)
      .filter((file) => file.startsWith("coverage") && file.endsWith(".json"))
      .map((file) => `${coveragePath}/${file}`)
    : [coveragePath];

  const coverages: V8CoverageJson[] = coverageJsonFiles.map((filePath) => JSON.parse(fs.readFileSync(filePath, 'utf8')));

  const fileResults = coverages.flatMap((coverage) =>
    coverage.result.filter(({ url }) => url.startsWith("file://"))
  );
  const includeMapped = include.map(f => path.join(pwd, f))
  await Promise.all(
    fileResults
      .map((result) => ({
        filePath: result.url.replace("file://", ""),
        result,
      }))
      .filter(({ filePath }) => includeMapped.includes(filePath))
      .map(async ({ filePath, result }) => {
        const converter = v8toIstanbul(filePath);
        try {
          await converter.load();
          converter.applyCoverage(result.functions);
          const istanbul = converter.toIstanbul();
          const filteredIstanbul = Object.fromEntries(
            Object.entries(istanbul).filter(([key]) => key.endsWith(".ts")),
          );
          map.merge(filteredIstanbul);
        } catch (error) {
          console.error(
            `Error processing ${filePath}: ${(error as Error).message}`,
          );
        }
      }),
  );

  return map;
};

const createReport = (
  coverageMap: CoverageMap,
  { outputType, outputDir }: { outputType: string; outputDir: string },
) => {
  const context = libReport.createContext({
    dir: outputDir,
    coverageMap,
  });

  const report = reports.create(outputType as never);
  report.execute(context);
};

const v8ToLcov = async (coverageDir: string, coverageOutputFile: string) => {
  if (!fs.existsSync(coverageDir)) {
    throw new Error(`Coverage directory '${coverageDir}' not found`);
  }
  if (!coverageOutputFile) {
    throw new Error("Coverage output file not provided");
  }
  try {
    const coverageMap = await createCoverageMap(coverageDir);
    createReport(coverageMap, {
      outputType: "lcovonly",
      outputDir: coverageDir
    });
    await fs.promises.cp(
      path.join(coverageDir, 'lcov.info'),
      coverageOutputFile
    );
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
}

void v8ToLcov(process.env.COVERAGE_DIR!, process.env.COVERAGE_OUTPUT_FILE!);

