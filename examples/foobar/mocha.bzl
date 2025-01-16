"""
Custom mocha bazel macros to make linting easy
"""
load("@aspect_rules_ts//ts:defs.bzl", "ts_project")
load(":batch.bzl", "split_srcs_to_batches")
load("@bazel_skylib//lib:collections.bzl", "collections")
load("@npm//:mocha/package_json.bzl", "bin")

def is_test_file(src):
    for part in [".test.", ".tests.", ".app-tests."]:
        if src.rfind(part) != -1:
            return True
    return False

def convert_ext_to_js(file_name):
    if file_name.endswith(".js"):
        return file_name.removesuffix(".ts") + ".js"
    return file_name

MOCHA_DEPS = [
    "//:node_modules/mocha",
    "//:node_modules/@types/mocha",
    "//:node_modules/chai",
    "//:node_modules/@types/chai",
    "//:node_modules/source-map-support",
]

def mocha_test(name, test_srcs, data, mocharc, tsconfig, deps, env = {}, **kwargs):
    batches = split_srcs_to_batches(test_srcs, "unit_test_batch", 1, 1)

    args = [
        "--config $(location %s)" % mocharc,
        "--full-trace",
        "--fail-zero",
    ]

    tests = []

    for batch_name, batch_srcs in batches.items():
        final_test_name = "%s_%s" % (name, batch_name)
        compile_name = "compile_%s_%s" % (name, batch_name)
        ts_project(
            name = compile_name,
            srcs = batch_srcs,
            transpiler = "tsc",
            tsconfig = tsconfig,
            declaration = True,
            allow_js = False,
            source_map = True,
            deps = deps + data + [
                "//:node_modules/@types/chai",
                "//:node_modules/@types/mocha",
                "//:node_modules/@types/node",
                "//:node_modules/chai",
                "//:node_modules/tslib",
            ],
        )
        bin.mocha_test(
            name = final_test_name,
            args = args + kwargs.pop("args", []),
            data = collections.uniq(
                deps +
                data +
                batch_srcs +
                [compile_name, mocharc] +
                MOCHA_DEPS,
            ),
            env = env,
            **kwargs
        )
        tests.append(final_test_name)

    native.test_suite(
        name = name,
        tests = tests,
    )