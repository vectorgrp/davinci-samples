# 📦 DaVinci Workspace Setup (Deprecated)

With the release of **DaVinci Configurator Classic 6.3**, we introduced a new tool called **DaVinci Assistant**.

## 🚀 DaVinci Assistant

The **dvassistant** has fully taken over the functionality previously provided by the script in this folder.  
As a result, the script has been **removed**.

DaVinci Assistant is a CLI Tool that covers the complete workspace setup:

- **Create a Project** (`dv-assistant.exe create`): Create a new DaVinci Project from your BSW Package, including an optional DaVinci Developer Classic workspace and vVIRTUALtarget project linked to it.
- **Update a Project** (`dv-assistant.exe update`): Import new or changed input files (ARXML, DBC, LDF, FIBEX, CDD, VSDE) into an existing project and derive the ECU configuration from them.

### ✅ Why dvassistant?

Using **dvassistant**, workspaces can now be set up:

- with a **clean and user-friendly interface**
- in a **more automated and reliable way**
- with **improved user handling** compared to the legacy script

## 📖 Documentation

For further details, usage instructions, and examples, please refer to the official documentation:

👉 **[DaVinci Assistant - Documentation](https://help.vector.com/davinci-configurator-classic/en/latest/user-manual/tools/davinci-assistant/index.html)**

- [Create a Project](https://help.vector.com/davinci-configurator-classic/en/latest/user-manual/tools/davinci-assistant/index.html#create-a-project)
- [Update a Project](https://help.vector.com/davinci-configurator-classic/en/latest/user-manual/tools/davinci-assistant/index.html#_update_a_project)

---

> ⚠️ **Note**  
> This folder is kept for reference purposes only.  
> Please use **dvassistant** for all future workspace setups.  
> This folder will be removed completely in the future.
