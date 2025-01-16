load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "aspect_rules_ts",
    sha256 = "da6620683ab2c28014e9c82e8a8fdbb724cd67f6a1d27317f42a8ceb14048b9b",
    strip_prefix = "rules_ts-2.4.1",
    url = "https://github.com/aspect-build/rules_ts/releases/download/v2.4.1/rules_ts-v2.4.1.tar.gz",
)

#NB! Must be the same version as in https://github.com/aspect-build/rules_ts/blob/v2.4.1/ts/repositories.bzl
http_archive(
    name = "aspect_rules_js",
    patch_args = ["-p1"],
    patches = ["//:patches/rules_js.patch"],
    sha256 = "d9ceb89e97bb5ad53b278148e01a77a3e9100db272ce4ebdcd59889d26b9076e",
    strip_prefix = "rules_js-1.34.0",
    url = "https://github.com/aspect-build/rules_js/releases/download/v1.34.0/rules_js-v1.34.0.tar.gz",
)

http_archive(
    name = "aspect_rules_swc",
    sha256 = "cde09df7dea773adaed896612434559f8955d2dfb2cfd6429ee333f30299ed34",
    strip_prefix = "rules_swc-1.2.2",
    url = "https://github.com/aspect-build/rules_swc/releases/download/v1.2.2/rules_swc-v1.2.2.tar.gz",
)

load("@aspect_rules_ts//ts:repositories.bzl", "rules_ts_dependencies")

rules_ts_dependencies(
    ts_version_from = "//:package.json",
)

load("@aspect_rules_js//js:repositories.bzl", "rules_js_dependencies")

rules_js_dependencies()

load("@aspect_rules_swc//swc:dependencies.bzl", "rules_swc_dependencies")

rules_swc_dependencies()

load("@aspect_rules_swc//swc:repositories.bzl", "swc_register_toolchains")

swc_register_toolchains(
    name = "swc",
    swc_version_from = "//:package.json",
)

load("@rules_nodejs//nodejs:repositories.bzl", "nodejs_register_toolchains")

nodejs_register_toolchains(
    name = "node",
    # NOTE(SH): All of these lines are required. Fresh CI instances will beging crashing due to the lib
    # not finding the necessary versions if left out. This is regardless of the fact that we only use
    # the darwin and linux amd64 bundles.
    node_repositories = {
        "22.11.0-darwin_amd64": ("node-v22.11.0-darwin-x64.tar.xz", "node-v22.11.0-darwin-x64", "ab28d1784625d151e3f608a9412a009118f376118ed842ae643f8c2efdfb0af6"),
        "22.11.0-darwin_arm64": ("node-v22.11.0-darwin-arm64.tar.xz", "node-v22.11.0-darwin-arm64", "c379a90c6aa605b74042a233ddcda4247b347ba5732007d280e44422cc8f9ecb"),
        "22.11.0-linux_amd64": ("node-v22.11.0-linux-x64.tar.xz", "node-v22.11.0-linux-x64", "83bf07dd343002a26211cf1fcd46a9d9534219aad42ee02847816940bf610a72"),
        "22.11.0-linux_arm64": ("node-v22.11.0-linux-arm64.tar.xz", "node-v22.11.0-linux-arm64", "6031d04b98f59ff0f7cb98566f65b115ecd893d3b7870821171708cdbaf7ae6e"),
        "22.11.0-linux_s390x": ("node-v22.11.0-linux-s390x.tar.xz", "node-v22.11.0-linux-s390x", "f474ed77d6b13d66d07589aee1c2b9175be4c1b165483e608ac1674643064a99"),
        "22.11.0-windows_amd64": ("node-v22.11.0-win-x64.zip", "node-v22.11.0-win-x64", "905373a059aecaf7f48c1ce10ffbd5334457ca00f678747f19db5ea7d256c236"),
    },
    node_urls = ["https://nodejs.org/dist/v{version}/{filename}"],
    node_version = "22.11.0",
)

load("@aspect_rules_js//npm:repositories.bzl", "npm_translate_lock")

npm_translate_lock(
    name = "npm",
    npmrc = "//:.npmrc",
    pnpm_lock = "//:pnpm-lock.yaml",
    verify_node_modules_ignored = "//:.bazelignore",
)

load("@npm//:repositories.bzl", "npm_repositories")

npm_repositories()
