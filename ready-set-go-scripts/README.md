# Ready-Set-Go-Scripts

## 📦 What Does This Folder Contain?

- **Ready-Set-Go-Scripts** demonstrating how DaVinci Configurator Classic integrates into typical MICROSAR projects.

  - Create a new DaVinci Project and link additional workspaces
  - Project Import and Update

## 🧩 Ready-Set-Go-Script Options

- **DaVinci_WorkspaceSetup.bat** sets up and links DaVinci workspaces, and executes input file processing and updates.

  This script automates the creation and setup of DaVinci projects using both DaVinci Configurator Classic and DaVinci Developer Classic.
  It ensures workspaces exist or creates them, links CFG6 and DEV workspaces, analyzes input files with EcuXPro derives ECU configuration, and updates the CFG6 project automatically.
  Note: This script is for a non-variant project only!

  ```mermaid
  flowchart TB
  subgraph B["Step 1: Store variables"]
    B1["Step 1.1: Ask user for tool installation paths"]
    B2["Step 1.2: Project specifics"]
    B3["Step 1.3: Tool-specific variables"]
    B1 --> B2 --> B3
  end
  subgraph C["Step 2: Check workspaces"]
    C1["Ask for CFG6 workspace"]
    C2["Ask for DEV workspace"]
  end
  A["Step 0: Initialize logging"] --> B
  B --> C
  C --> |"Workspaces do not exist "|D["Step 3: Create missing workspaces/projects"]
  C --> |"Workspaces exist"|E
  D --> E["Step 4: Convert and link DEV workspace to CFG6 workspace"]
  E --> F["Step 5: Add DEV workspace reference to General.json"]
  F --> G["Step 6: Analyze input files with EcuXPro"]
  G --> H["Step 7: Execute extractSystemDesc.bat after path update"]
  H --> I["Step 8: Derive ECUC from MergedECUExtract.arxml"]
  I --> J["Step 9: Project update"]
  J --> K["Step 10: Log completion"]
  ```

## 🚀 Getting Started with DaVinci_WorkspaceSetup.bat

1. Set variables in Step 1 as needed.
2. Run the script by double-clicking or executing via command line.
3. Check the output (Log file: Output_Log.txt).

## 🪄 Tips

- Always verify that installation paths are correct before running the script.
- Enclose paths in double quotes to handle spaces.
- Use the log file (Output_Log.txt) to debug any issues.
- This script assumes a basic understanding of AUTOSAR and DaVinci project structure.
- This script assumes either no CFG6 and/or DEV workspaces exist beforehand OR that the existing workspaces have never been linked before
