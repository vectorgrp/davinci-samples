# Bazel Starter for ECU Communication & Diagnostics

This repository provides Bazel build rules and configurations for ECU projects using DaVinci Configurator Classic Version 6. It enables ECU extraction, ARXML merging, and module configuration within Bazel workflows.

## Usage

- `dvcfg6-project` contains an empty ECU project for demonstration purposes. To use it:
  - Set the `<SipId>` in [General.json](dvcfg6-project/Settings/General.json) to match your BSW package.
  - Run `bazel run @ComDiag//:open_configurator` to open the project in DaVinci Configurator Classic 6.
- Alternatively you may use your own ([migrated](https://help.vector.com/davinci-configurator-classic/en/current/dvcfg-classic/6.2-SP0/migration.html)) DaVinci project.
  - See `<MigratedProject>` in [com-diag.MODULE.bazel](com-diag.MODULE.bazel).
  - Run `bazel run @<MigratedProject>//:open_configurator` to open the project in DaVinci Configurator Classic 6.
- See the comments in [com-diag.MODULE.bazel](com-diag.MODULE.bazel) and [BUILD.bazel](BUILD.bazel) for hints on how to customize the Bazel rules to fit your specific use case.
