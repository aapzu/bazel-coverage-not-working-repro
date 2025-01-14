#!/usr/bin/env bash

INPUT=${1:-"bazel-out/_coverage/_coverage_report.dat"}
OUTPUT=${2:-"coverage-report"}

#if no htmlgen
if ! command -v genhtml 2>&1 >/dev/null; then
    echo "\
Run \`
  brew install lcov
\` to install lcov"
    exit 1
fi

genhtml "$INPUT" --output-directory "$OUTPUT"

echo "Coverage report generated at $OUTPUT/index.html"

echo "\
Run \`
  open \"$OUTPUT/index.html\"
\` to view the report"