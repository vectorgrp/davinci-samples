# Bazel Starter for Creating a New DaVinci Project

This repository provides Bazel build rules and configurations for ECU projects using DaVinci Configurator Classic Version 6. It enables ECU extraction, ARXML merging, and module configuration within Bazel workflows.

## Usage

- Run `bazel run @MyProject//:open_configurator` to open the project in DaVinci Configurator Classic 6.
- See [project-creation.json](project-creation.json) for the settings with which Bazel creates the new project.
- See the comments in [project-creation.MODULE.bazel](eac.MODULE.bazel) and [BUILD.bazel](BUILD.bazel) for hints on how to customize the Bazel rules to fit your specific use case.
