# Bazel Starter

## 📦 What Does This Folder Contain?

- **Bazel Starter** shows how to build and automate configurations using Bazel and modern build systems. You can leverage various Bazel rules depending on your build needs:
  - Create a new DaVinci Project or reuse an existing one
  - Execute EcuC-as-Code
  - Project Import and Update
  - Validate and generate the DaVinci Project

## 🧩 Bazel Starter Options

- **com-diag** Bazel starter showing the steps required to import and update communication, diagnostic, and other description files for an existing DaVinci Project.
- **eac** Bazel starter showing how to implement the EcuC-as-Code workflow for ECU configuration in DaVinci Projects.
- **project-creation** Bazel starter showing how to create a new DaVinci Project using a configuration file.

## 🚀 Getting Started

1. Configure the path to your `<BswPackage>` in [MODULE.bazel](../MODULE.bazel).
2. Select a Bazel starter that matches your use case and adjust it to your specific requirements
   (see `Usage` section in [com-diag](com-diag/README.md), [eac](eac/README.md) or [project-creation](project-creation/README.md) READMEs).
