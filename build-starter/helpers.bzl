def _bsw_pkg_impl(repository_ctx):
    repository_ctx.file("BUILD.bazel", 'exports_files(["folder"])')
    repository_ctx.symlink(repository_ctx.attr.path, "folder")

bsw_pkg = repository_rule(
    doc = "Repo rule for referencing the folder of a BSW package.",
    attrs = {
        "path": attr.string(doc = "Path to the BSW package folder.", mandatory = True),
    },
    implementation = _bsw_pkg_impl,
)

def _dvjson_impl(repository_ctx):
    file_path = repository_ctx.path(repository_ctx.attr.path)
    repository_ctx.symlink(file_path.dirname, "_")
    repository_ctx.file("BUILD.bazel", 'filegroup(name = "{name}", srcs = ["_/{name}"], visibility = ["//visibility:public"])'.format(name = file_path.basename))

dvjson = repository_rule(
    doc = "Repo rule for referencing an existing .dvjson file.",
    attrs = {
        "path": attr.string(doc = "The path to the .dvjson file.", mandatory = True),
    },
    implementation = _dvjson_impl,
)
