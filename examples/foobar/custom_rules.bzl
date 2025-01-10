def _instrumented_ts_project_impl(ctx):
    # Call the underlying ts_project rule
    result = ctx.attr.ts_project_target[DefaultInfo]

    # Add InstrumentedFilesProvider via coverage_common
    instrumented_provider = coverage_common.instrumented_files_info(
        ctx,
        source_attributes=["srcs"],
        dependency_attributes=["deps"],
        extensions=["js", "map", "ts", "tsx"],  # Ensure TypeScript files are included
    )

    return [result] + [instrumented_provider]

instrumented_ts_project = rule(
    implementation=_instrumented_ts_project_impl,
    attrs={
        "srcs": attr.label_list(allow_files=[".ts"]),
        "ts_project_target": attr.label(),  # Reference to the original ts_project
    },
    fragments=["instrumentation"],  # Required to access instrumentation settings
)
