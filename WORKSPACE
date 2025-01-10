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

load("@aspect_rules_js//js:toolchains.bzl", "DEFAULT_NODE_VERSION", "rules_js_register_toolchains")

rules_js_register_toolchains(
    name = "node",
    node_version = DEFAULT_NODE_VERSION,
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