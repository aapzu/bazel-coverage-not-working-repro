"""
Custom mocha bazel macros to make linting easy
"""

load("@aspect_rules_js//js:defs.bzl", "js_library")
load("@aspect_rules_ts//ts:defs.bzl", "ts_project")
load("@bazel_skylib//lib:collections.bzl", "collections")
load("@npm//:mocha/package_json.bzl", "bin")

MOCHA_DEPS = [
    "//:node_modules/mocha",
    "//:node_modules/@types/mocha",
    "//:node_modules/chai",
    "//:node_modules/@types/chai",
    "//:node_modules/source-map-support",
]

def mocha_test(name, test_srcs, data, mocharc, tsconfig, deps, env = {}, **kwargs):
    args = [
        "--config $(location %s)" % mocharc,
        "--full-trace",
        "--fail-zero",
    ]

    tests = []

    # Batching doesn't change the input type so I'll skip it here
    batch_name = "batch1"
    batch_srcs = test_srcs

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
    js_library(
        name = "%s_js" % final_test_name,
        srcs = [],
        deps = MOCHA_DEPS + [compile_name],
    )
    bin.mocha_test(
        name = final_test_name,
        args = args + kwargs.pop("args", []),
        data = collections.uniq(
            deps +
            data +
            ["%s_js" % final_test_name, mocharc] +
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
