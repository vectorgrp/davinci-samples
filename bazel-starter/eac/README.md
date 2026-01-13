# Bazel Starter for EcuC-as-Code

Bazel starter showing how to implement the EcuC-as-Code workflow for ECU configuration in DaVinci Projects.

## Usage

- `dvcfg6-project` contains an empty ECU project for demonstration purposes. To use it:
  - Set the `<SipId>` in [General.json](dvcfg6-project/Settings/General.json) to match your BSW package.
  - Run `bazel run @ComDiag//:open_configurator` to open the project in DaVinci Configurator Classic 6.
- Alternatively you may use your own ([migrated](https://help.vector.com/davinci-configurator-classic/en/current/dvcfg-classic/6.2-SP0/migration.html)) DaVinci project.
  - See `<MigratedProject>` in [com-diag.MODULE.bazel](com-diag.MODULE.bazel).
  - Run `bazel run @<MigratedProject>//:open_configurator` to open the project in DaVinci Configurator Classic 6.
- See the comments in [eac.MODULE.bazel](eac.MODULE.bazel) and [BUILD.bazel](BUILD.bazel) for hints on how to customize the Bazel rules to fit your specific use case.
