# DaVinci Samples

Welcome to **DaVinci Samples**, an open-source repository designed to help developers understand and adopt **DaVinci Configurator Classic Version 6** workflows more easily.

## 📌 What is This Repository For?

This repository provides sample resources to help you integrate DaVinci Configurator Classic Version 6 workflows:

- **Ready-Set-Go-Scripts** demonstrating how DaVinci Configurator Classic Version 6 integrates into typical MICROSAR projects.
    - **davinci-workspace-setup**: Create a new DaVinci Project and link additional workspaces. Execute project import and update.
- **Build-Starter** shows how to build and automate configurations using Bazel and modern build systems. You can leverage various Bazel rules depending on your build needs:
    - Create a new DaVinci Project or reuse an existing one
    - Execute EcuC-as-Code
    - Project Import and Update
    - Validate and generate the DaVinci Project

## 🛠 Requirements

Always required:

- Activated DaVinci Configurator Classic Version 6 License
- A valid MICROSAR BSW package

If using scripts:

- DaVinci Developer Classic (Release 4.17 SP2 or newer)
- DaVinci Team (Release 6.2 or newer)

If using pipelines (if using Bazel):

- Bazel by Google (see [.bazeliskrc](.bazeliskrc) for version)

If using EcuC as Code:

- EcuC-As-Code Development Kit

## 🚀 Getting Started

1. Clone the repository:

    ```bash
    git clone https://github.com/vectorgrp/davinci-samples.git
    ```

2. Explore the samples:
    - Navigate to the folder that matches your use case.
3. Follow the instructions in each folder’s README to get started.

## 📂 Repository Structure

```text
davinci-samples/
 ├─ build-starter/         # Bazel-based project setup example
 ├─ ready-set-go-scripts/  # Ready-to-use scripts for quick workflow setup
 ├─ .bazelrc               # Bazel configuration file defining build options and settings
 ├─ .editorconfig          # Editor configuration for consistent coding styles across IDEs
 ├─ .gitignore             # Specifies files and directories to be ignored by Git
 ├─ LICENSE                # License information
 ├─ MODULE.bazel           # Bazel module definition for dependency management
 ├─ MODULE.bazel.lock      # Lock file for Bazel module dependencies to ensure reproducible builds
 ├─ README.md              # Main documentation for the repository
 └─ SECURITY.md            # Security policy
```

## 📖 Documentation

Check the repository folders for step-by-step guides and explanations.

[Learn more about DaVinci Configurator Classic Version 6.](https://help.vector.com/davinci-configurator-classic/en/current/index.html)
