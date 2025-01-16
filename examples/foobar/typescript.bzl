load("@aspect_rules_js//js:defs.bzl", "js_binary")
load("@aspect_rules_swc//swc:defs.bzl", "swc")
load("@aspect_rules_ts//ts:defs.bzl", _ts_project = "ts_project")
load("@bazel_skylib//lib:partial.bzl", "partial")

def _swc_transpile(srcs, **kwargs):
    srcs = [src for src in srcs if not _is_declaration_file(src)]
    return swc(srcs = srcs, **kwargs)

def _is_declaration_file(filename):
    return filename.endswith(".d.ts")

def ts_project_custom(
        name,
        srcs,
        deps,
        tsconfig,
        module = "esnext",
        allow_implicit_any = False,
        legacy = False,
        use_swc = False,
        data = [],
        tsconfig_types_override = None,
        source_map = False,
        **kwargs):
    """Run typescript with predefined configuration on the provided source files

    Args:
        name: target name
        module: module type
        srcs: the source files to compile with tsc
        legacy: disable legacy incompatible checks
        allow_implicit_any: allow implicit any (required for legacy frontend)
        deps: the bazel targets and/or npm modules required for compilation with tsc
        data: package non-source-code runtime dependencies
        use_swc: set to true if swc should be used to transpile ts to js
        tsconfig: the typescript configuration file to use
        tsconfig_types_override: a list of types included automatically (i.e. tsconfig.compilerOptions.types)
        source_map: generate source maps
        **kwargs: remaining arguments passed directly to tsc

    Returns:
        the compiled files
    """
    compiled_name = name

    tsconfig_compiler_options = {
        "module": module,
        "noImplicitAny": allow_implicit_any == False,
        "sourceMap": source_map,
        "strictFunctionTypes": legacy == False,
        "strictNullChecks": legacy == False,
    }
    if tsconfig_types_override != None:
        tsconfig_compiler_options.update({"types": tsconfig_types_override})

    transpiler = "tsc"
    if use_swc:
        # Setup SWC for faster transpilation
        transpiler = partial.make(
            _swc_transpile,
            out_dir = None,
            source_maps = source_map,
            swcrc = {
                "jsc": {
                    "externalHelpers": False,
                    "parser": {
                        "decorators": True,
                        "syntax": "typescript",
                        "tsx": False,
                    },
                    "target": "es2021",
                    "transform": {
                        "decoratorMetadata": True,
                        "legacyDecorator": True,
                        "react": {
                            "runtime": "automatic",
                        },
                    },
                },
                "module": {
                    "type": module,
                },
            },
        )

    result = _ts_project(
        name = compiled_name,
        srcs = srcs,
        deps = deps,
        data = data,
        # necessary to extend to get build paths correct
        # extends = tsconfig,
        tsconfig = tsconfig,
        transpiler = transpiler,
        # tsconfig = {
        #     "compilerOptions": tsconfig_compiler_options,
        # },
        declaration = True,
        source_map = source_map,
        # declaration_map = False,
        # resolve_json_module = True,
        # emit_declaration_only = False,
        # out_dir = None,
        **kwargs
    )

    return result

def ts_project_hoxapp_server(name, module = "commonjs", **kwargs):
    tsc_with_more_heap_binary_name = "tsc_with_more_heap_%s" % name
    js_binary(
        name = tsc_with_more_heap_binary_name,
        data = ["@npm_typescript//:node_modules/typescript"],
        entry_point = "@npm_typescript//:tsc_entrypoint",
        node_options = ["--max-old-space-size=8192"],
    )
    ts_project_custom(
        name = name,
        # tsc = tsc_with_more_heap_binary_name,
        module = module,
        # use_swc = True,
        **kwargs
    )
