load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "aspect_rules_ts",
    sha256 = "cff3137b043ff6bf1a2542fd9691dc762432370cd39eb4bb0756d288de52067d",
    strip_prefix = "rules_ts-3.3.2",
    url = "https://github.com/aspect-build/rules_ts/releases/download/v3.3.2/rules_ts-v3.3.2.tar.gz",
)

load("@aspect_rules_ts//ts:repositories.bzl", "rules_ts_dependencies")

rules_ts_dependencies(
    ts_version_from = "//:package.json",
)

http_archive(
    name = "aspect_rules_jest",
    sha256 = "7fc6798dc566f8ec83867f636739716d81097bd3cead9c0fedb098c58fae6567",
    strip_prefix = "rules_jest-0.22.0",
    url = "https://github.com/aspect-build/rules_jest/releases/download/v0.22.0/rules_jest-v0.22.0.tar.gz",
)

load("@aspect_rules_jest//jest:dependencies.bzl", "rules_jest_dependencies")

rules_jest_dependencies()

load("@aspect_rules_js//js:repositories.bzl", "rules_js_dependencies")

rules_js_dependencies()

load("@aspect_rules_js//js:toolchains.bzl", "rules_js_register_toolchains")

rules_js_register_toolchains(
    name = "node",
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