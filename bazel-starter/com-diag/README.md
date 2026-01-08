# Bazel Starter for ECU Communication & Diagnostics

This repository provides Bazel build rules and configurations for ECU projects using DaVinci Configurator Classic Version 6. It enables ECU extraction, ARXML merging, and module configuration within Bazel workflows.

## Key Bazel Rules

- ECU Extraction: Extract an ECU from the system desciption
- Merge ARXML Files: Combine multiple .arxml files into a single ECU extract.
- Replace Modules: Import modules in replace mode.
