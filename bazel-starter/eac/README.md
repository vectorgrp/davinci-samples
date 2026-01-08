# Bazel Starter for EcuC-as-Code

This repository provides Bazel build rules and configurations for ECU projects using DaVinci Configurator Classic Version 6. It enables ECU extraction, ARXML merging, module configuration and EcuC-as-Code within Bazel workflows.

## Key Bazel Rules

- Creation File: Uses project-specific settings to create DaVinci Project
- ECU Extraction: Extract an ECU from the system desciption
- Merge ARXML Files: Combine multiple .arxml files into a single ECU Extract.
- Replace Modules: Import modules in replace mode.
- EaC Jar: EcuC-as-Code to be executed on your DaVinci Project.
