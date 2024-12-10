# bazel-coverage-not-working-repro

A repro repo to demonstrate coverage collection not working with aspect_rules_ts

## An example that DOES work

Collecting coverage from a js target works nicely

```shell
bazelisk clean --expunge
bazelisk coverage --combined_report=lcov --instrument_test_targets //examples/coverage:coverage_js
genhtml --output genhtml "$(bazel info output_path)/_coverage/_coverage_report.dat"
```

This produces a bunch of HTML files in `genhtml`

## An example that DOES NOT work

When using `ts_project` from `rules_ts` to build a typescript project, coverage collection does not work

```shell
bazelisk clean --expunge
bazelisk coverage --combined_report=lcov --instrument_test_targets //examples/coverage:coverage_ts
genhtml --output genhtml "$(bazel info output_path)/_coverage/_coverage_report.dat"
```

This produces the following error:

```shell
Reading tracefile /private/var/tmp/_bazel_fullname/abcdef0123456789abcdef0123456789/execroot/_main/bazel-out/_coverage/_coverage_report.dat.
genhtml: ERROR: (empty) trace file '/private/var/tmp/_bazel_fullname/aff2bf6ff4a96b39956f7eadc4a78e20/execroot/_main/bazel-out/_coverage/_coverage_report.dat' is empty
        (use "genhtml --ignore-errors empty ..." to bypass this error)
```
