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

def _migrated_project_impl(repository_ctx):
    dvjson = repository_ctx.path(repository_ctx.attr.dvjson)
    repository_ctx.symlink(dvjson, "_")
    repository_ctx.file("BUILD.bazel", 'filegroup(name = "dvjson", srcs = ["_/{}"])'.format(dvjson.basename))

migrated_project = repository_rule(
    doc = "Repo rule for referencing a migrated DaVinci Configurator project.",
    attrs = {
        "dvjson": attr.string(doc = "The project's dvjson file.", mandatory = True),
    },
    implementation = _migrated_project_impl,
)
