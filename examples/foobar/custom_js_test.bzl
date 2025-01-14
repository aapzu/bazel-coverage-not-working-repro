load("@aspect_rules_js//js:libs.bzl", "js_binary_lib", "js_lib_helpers")
load("@bazel_skylib//lib:dicts.bzl", "dicts")

_attrs = dicts.add(js_binary_lib.attrs, {
    "enable_runfiles": attr.bool(
        default = True,
        doc = "Whether to enable runfiles support for the test.",
    ),
    "entry_point": attr.label(
      mandatory = True,
      allow_files = True,  # Allow generated files
    ),
    "env_inherit": attr.string_list(
        doc = """Environment variables to inherit from the external environment.""",
    ),
    "_lcov_merger": attr.label(
        executable = True,
        default = Label("@aspect_rules_js//js/private/coverage:merger"),
        cfg = "exec",
    ),
})

def _custom_js_test_impl(ctx):
    providers = []

    fixed_env = {}

    # Extract srcs from the compile target
    launcher = js_binary_lib.create_launcher(
        ctx,
        log_prefix_rule_set = "aspect_rules_js",
        log_prefix_rule = "js_test",
        fixed_env = fixed_env,
        fixed_args = ctx.attr.fixed_args,
    )

    files = ctx.files.data[:]

    runfiles = ctx.runfiles(
        files = files,
        transitive_files = js_lib_helpers.gather_files_from_js_infos(
            targets = ctx.attr.data,
            include_sources = ctx.attr.include_sources,
            include_types = ctx.attr.include_types,
            include_transitive_sources = ctx.attr.include_transitive_sources,
            include_transitive_types = ctx.attr.include_transitive_types,
            include_npm_sources = ctx.attr.include_npm_sources,
        ),
    ).merge(launcher.runfiles).merge_all([
        target[DefaultInfo].default_runfiles
        for target in ctx.attr.data
    ])

    runfiles = runfiles.merge(ctx.runfiles(
        files = ctx.attr.data[0][InstrumentedFilesInfo].instrumented_files.to_list(),
    ))

    if ctx.configuration.coverage_enabled:
        # We have to instruct rule implementers to have this attribute present.
        if not hasattr(ctx.attr, "_lcov_merger"):
            fail("_lcov_merger attribute is missing and coverage was requested")
        runfiles = runfiles.merge(ctx.attr._lcov_merger[DefaultInfo].default_runfiles)
        providers.append(
            ctx.attr.data[0][InstrumentedFilesInfo],
        )

    providers.append(
        DefaultInfo(
            executable = launcher.executable,
            runfiles = runfiles,
        ),
    )

    if ctx.attr.env_inherit != None:
        providers.append(
            testing.TestEnvironment(fixed_env, ctx.attr.env_inherit),
        )

    if len(providers) > 1:
        print([file.path for file in providers[1].default_runfiles.files.to_list() if file.path.endswith(".ts")])

    return providers

custom_js_test = rule(
    implementation = _custom_js_test_impl,
    test = True,  # Marks this rule as a test
    attrs = _attrs,
    toolchains = js_binary_lib.toolchains,
)
