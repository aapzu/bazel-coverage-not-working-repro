# bazel-coverage-not-working-repro

## To produce coverage

```shell
bazelisk coverage --nocache_test_results --combined_report=lcov //examples/coverage:coverage
```

## Try to convert to HTML

Use the command from https://bazel.build/configure/coverage

```shell
genhtml --branch-coverage --output genhtml "$(bazel info output_path)/_coverage/_coverage_report.dat"
```

This produces the following error:
```shell
Reading tracefile /private/var/tmp/_bazel_fullname/abcdef0123456789abcdef0123456789/execroot/_main/bazel-out/_coverage/_coverage_report.dat.
genhtml: ERROR: (empty) trace file '/private/var/tmp/_bazel_fullname/aff2bf6ff4a96b39956f7eadc4a78e20/execroot/_main/bazel-out/_coverage/_coverage_report.dat' is empty
        (use "genhtml --ignore-errors empty ..." to bypass this error)
```
