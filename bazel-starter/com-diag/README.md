# Bazel Starter for ECU Communication & Diagnostics

Bazel starter showing the steps required to import and update communication, diagnostic, and other description files for an existing DaVinci Project.

## Usage

- `dvcfg6-project` contains an empty ECU project for demonstration purposes. To use it:
  - Set the `<SipId>` in [General.json](dvcfg6-project/Settings/General.json) to match the BSW package configured in [Module.bazel](../../MODULE.bazel).
  - Run `bazel run @ComDiag//:open_configurator` to open the project in DaVinci Configurator Classic 6.
- Alternatively you may use your own ([migrated](https://help.vector.com/davinci-configurator-classic/en/current/dvcfg-classic/6.2-SP0/migration.html)) DaVinci project.
  - See `<MigratedProject>` in [com-diag.MODULE.bazel](com-diag.MODULE.bazel).
  - Run `bazel run @<MigratedProject>//:open_configurator` to open the project in DaVinci Configurator Classic 6.
- See the comments in [com-diag.MODULE.bazel](com-diag.MODULE.bazel) and [BUILD.bazel](BUILD.bazel) for hints on how to customize the Bazel rules to fit your specific use case.
