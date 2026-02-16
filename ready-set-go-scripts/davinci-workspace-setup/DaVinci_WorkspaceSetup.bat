@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

:: ============================================================================
:: Script: DaVinci_WorkspaceSetup
:: Version: 1.0
:: Purpose: Sets up and links DaVinci workspaces, and executes input file processing and updates.
:: Author: Vector Informatik GmbH
:: ============================================================================

:: ============================================================================
:: SECTION OVERVIEW
:: ============================================================================
:: This file contains the following sections:
::
:: Section 0 — User Manual
::     Explains how to run the script, expected inputs, and output structure.
::
:: Section 1 — Script Logic
::     Contains all steps of the script from Step 0 to Step 10,
::     including workspace handling, project creation, analysis, and updates.
::
:: Section 2 — Subroutines
::     Contains reusable subroutines such as :Log, ::CheckVariables and :AskWorkspace.
::
:: SECTION 3 — Batch Concept Explanation
::     Explains batch concepts used in this script.

:: ============================================================================
:: SECTION 0 — USER MANUAL
:: ============================================================================
:: 1. Set variables in Step 1 as needed.
:: 2. Understand that Step 7 requires manual editing of extractSystemDesc.bat for ECU instance(s).
:: 3. Run by double-clicking or command line. Log file will be written to Output_Log.txt automatically.

:: ============================================================================
:: SECTION 1 — SCRIPT LOGIC (Step-by-Step)
:: ============================================================================
:: Step 0: Initialize logging to record all operations in Output_Log.txt
:: Step 1: Store variables for tool paths, project specifics, and tool-specific settings
:: Step 1.1: Ask for/define tool installation paths (CFG6, DEV, EcuxPro)
:: Step 1.2: Define project-specific paths (BSW package, database, legacy converter)
:: Step 1.3: Define tool-specific variables (workspace paths, AUTOSAR version)
:: Step 2: Ask user whether CFG6 and DEV workspaces already exist
::         - Use existing paths or defaults
:: Step 3: Create missing workspaces/projects if they do not exist
:: Step 4: Link DEV workspace to CFG6 project
:: Step 5: Append DEV workspace reference in General.json
:: Step 6: Analyze input files with EcuXPro to generate extractSystemDesc.bat
:: Step 7: Prompt user to edit extractSystemDesc.bat, set ECU instance(s), and run it
:: Step 8: Derive ECUC from the merged ECU extract file
:: Step 9: Update CFG6 project with derived ECUC
:: Step 10: Log completion of script execution

:: ============================================================================
:: SECTION 1 — SCRIPT LOGIC (ACTUAL WORKING CODE)
:: ============================================================================

:: -------------------------------------------------------------------------
:: Step 0: Initialize logging
:: -------------------------------------------------------------------------
SET "LOG_FILE=%~dp0Output_Log.txt" REM create log file if it doesnt exist
IF NOT EXIST "%LOG_FILE%" ECHO.>"%LOG_FILE%"
CALL :Log "Step 0: Logging initialized"

:: -------------------------------------------------------------------------
:: Step 1: Store variables and paths
:: -------------------------------------------------------------------------

ECHO Please ensure that all required paths and variables are set in Step 1
:: Step 1.0: Ask user for tool installation paths
SET "DV_CFG6_INSTALPATH="   REM Set Path to DaVinci Configurator Classic (Folder: \Vector DaVinci Configurator Classic)
SET "ECUXPRO_INSTALPATH=%DV_CFG6_INSTALPATH%\EcucXPro"  REM Set Path to EcuXPro tool (Folder: \EcucXPro)
SET "DV_DEV_INSTALPATH="  REM Set Path to DaVinci Developer Classic (Folder: \Bin)
CALL :CheckVariables DV_CFG6_INSTALPATH ECUXPRO_INSTALPATH DV_DEV_INSTALPATH
CALL :Log "Step 1.0 done: Tool installation paths stored"

:: Step 1.1: Project specifics
SET "BSW_PACKAGE="  REM Path to baseline BSW package
SET "DATABASEPATH="  REM Path to input files
SET "LEGACYCONVERTEREXE="  REM Path to Legacy converter executable
SET "PROJECT_NAME=" REM A DVJSON file of this name will be created
SET "PROJECT_OUTPUTPATH=" REM Path where the project will be stored (DVJSON file will be created here)
CALL :CheckVariables BSW_PACKAGE DATABASEPATH LEGACYCONVERTEREXE PROJECT_NAME PROJECT_OUTPUTPATH
CALL :Log "Step 1.1 done: Project specifics stored"

:: Step 1.2: Tool-specific variables
SET "DEFAULTWORKSPACE_CFG6=%PROJECT_OUTPUTPATH%"  REM Default CFG6 workspace path as fallback
SET "DEFAULTWORKSPACE_DEV=%DEFAULTWORKSPACE_CFG6%\Config\AppConfig"  REM Default DEV workspace path as fallback
SET "DEV_MODEL_VERSION=1.0" REM Set Developer Model Version
SET "DEV_ASR_VERSION=23-11" REM Set Developer Autosar Version
CALL :CheckVariables DEFAULTWORKSPACE_CFG6 DEFAULTWORKSPACE_DEV DEV_MODEL_VERSION DEV_ASR_VERSION
CALL :Log "Step 1.2 done: Tool specifics stored"

:: -------------------------------------------------------------------------
:: Step 2: Ask user if existing workspaces exist
:: -------------------------------------------------------------------------
ECHO.
FOR %%T IN (CFG6 DEV) DO (
    CALL :AskWorkspace %%T
)
CALL :Log "Step 2 done: Check Workspace executed"

:: -------------------------------------------------------------------------
:: Step 3: Create missing workspaces/projects
:: -------------------------------------------------------------------------
SET "CFG6_PROJECT_FILEPATH=%WORKSPACE_CFG6%\%PROJECT_NAME%.dvjson"
SET "DEV_PROJECT_FILEPATH=%WORKSPACE_DEV%\%PROJECT_NAME%.dcf"

IF EXIST "%CFG6_PROJECT_FILEPATH%" (
    CALL :Log "Step 3: CFG6 project already exists at %CFG6_PROJECT_FILEPATH%, skipping creation"
) ELSE (
    CALL :Log "Starting project creation for CFG6"
    CALL "%DV_CFG6_INSTALPATH%\dvcfg-b" project create -b "%BSW_PACKAGE%" --project-name "%PROJECT_NAME%" -o "%WORKSPACE_CFG6%"
    IF ERRORLEVEL 1 (
        CALL :Log "ERROR: CFG6 project creation failed!"
        PAUSE
        EXIT /B 1
    )
    CALL :Log "Step 3: CFG6 project created at %WORKSPACE_CFG6%"
)

IF EXIST "%DEV_PROJECT_FILEPATH%" (
    CALL :Log "Step 3: DEV project already exists at %DEV_PROJECT_FILEPATH%, skipping creation"
) ELSE (
    CALL :Log "Starting project creation for DEV"
    CALL "%DV_DEV_INSTALPATH%\dvdevc" project create --workspace-path "%DEV_PROJECT_FILEPATH%" --model-version %DEV_MODEL_VERSION% --autosar-version %DEV_ASR_VERSION%
    IF ERRORLEVEL 1 (
        CALL :Log "ERROR: DEV project creation failed!"
        PAUSE
        EXIT /B 1
    )
    CALL :Log "Step 3: DEV project created at %DEV_PROJECT_FILEPATH%"
)

:: -------------------------------------------------------------------------
:: Step 4: Link DEV workspace to CFG6 workspace
:: -------------------------------------------------------------------------
CALL :Log "Linking workspaces..."
REM Link the DEV workspace to the CFG6 project so CFG6 can reference DEV configurations
CALL "%DV_DEV_INSTALPATH%\dvdevc" project link --workspace-path "%DEV_PROJECT_FILEPATH%" --davinci-project "%CFG6_PROJECT_FILEPATH%"

SET "ECU_EXTRACT_DIR=%WORKSPACE_CFG6%\Output\Config\EcuExtract"
SET "ECU_EXTRACT_FILE="

REM Check folder exists
IF NOT EXIST "%ECU_EXTRACT_DIR%\" (
    CALL :Log "No ECU extract folder found at %ECU_EXTRACT_DIR%"
    GOTO :SkipConvert
)

REM Look for an ARXML file
FOR /F "delims=" %%F IN ('DIR /B /A-D /O-D "%ECU_EXTRACT_DIR%\*.arxml" 2^>NUL') DO (
    SET "ECU_EXTRACT_FILE=%ECU_EXTRACT_DIR%\%%F"
    GOTO :DoConvert
)

REM Folder exists but no ARXML inside
CALL :Log "No ECU extract found in %ECU_EXTRACT_DIR%"
GOTO :SkipConvert

REM Convert the DEV Workspace to make it CFG6 compatible
:DoConvert
CALL :Log "Converting DCF Workspace using %ECU_EXTRACT_FILE%"
CALL "%DV_DEV_INSTALPATH%\dvdevc" project convert --workspace-path "%DEV_PROJECT_FILEPATH%" --extract-file "%ECU_EXTRACT_FILE%"
CALL :Log "Step 4 done: DEV workspace converted"
:SkipConvert
CALL :Log "Step 4 done: DEV workspace linked with CFG6 workspace"

:: -------------------------------------------------------------------------
:: Step 5: Add DEV workspace reference to General.json
:: -------------------------------------------------------------------------
::If references does not exist ? it is created.
::If references exists but dvWorkspace does not ? dcfWorkspace is added.
::If references.dcfWorkspace already exists ? its value is replaced with the new path.
SET "GENERALJSON_PATH=%WORKSPACE_CFG6%\Settings\General.json"
REM Use PowerShell to properly format the JSON
POWERSHELL -NoLogo -NoProfile -Command ^
  "$p = '%GENERALJSON_PATH%';" ^
  "$c = Get-Content $p -Raw | ConvertFrom-Json;" ^

  "if ($c.references -eq $null) {" ^
  "    $c | Add-Member -MemberType NoteProperty -Name references -Value @{ dvWorkspace = '../Config/AppConfig/%PROJECT_NAME%.dcf' };" ^
  "} else {" ^
  "    if ($c.references.dvWorkspace -eq $null) {" ^
  "        $c.references | Add-Member -MemberType NoteProperty -Name dvWorkspace -Value '../Config/AppConfig/%PROJECT_NAME%.dcf';" ^
  "    } else {" ^
  "        $c.references.dvWorkspace = '../Config/AppConfig/%PROJECT_NAME%.dcf';" ^
  "    }" ^
  "}" ^

  "$c | ConvertTo-Json -Depth 10 | Set-Content $p"
CALL :Log "Step 5 done: General.json snippet appended successfully"

:: -------------------------------------------------------------------------
:: Step 6: Analyze input files with EcuXPro
:: -------------------------------------------------------------------------
ECHO .
SET /P ECUXPRO_FILES="ECUXPRO: Enter input files (comma-separated):" REM Provide path of each input file, separated by a comma
SET /P ECUXPRO_OUTPATH="ECUXPRO: Enter output path:" REM Provide the path where the System Description should be stored
SET "ECUXPRO_SCRIPT=extractSystemDesc.bat"
REM Run EcuXPro to analyze databases and generate extractSystemDesc.bat
CALL "%ECUXPRO_INSTALPATH%\ecuxpro" analyze -f="%ECUXPRO_FILES%" -c="%LEGACYCONVERTEREXE%" -o="%ECUXPRO_OUTPATH%" --save-script "%ECUXPRO_SCRIPT%" --output-format=shell_cmd
CALL :Log "Step 6 done: EcuXPro analysis executed"

:: -------------------------------------------------------------------------
:: Step 7: Execute extractSystemDesc.bat after setting necessary variables
:: -------------------------------------------------------------------------
IF EXIST "%ECUXPRO_SCRIPT%" (
    ECHO ***---
    ECHO File "%ECUXPRO_SCRIPT%" has been created.
    ECHO Please open the file, set the ECU instances and save the file before continuing here.
    ECHO ---***
    PAUSE
    REM Run the updated extractSystemDesc.bat which generates the ECU extract
    CALL %ECUXPRO_SCRIPT%
    CALL :Log "Step 7 done: extractSystemDesc.bat executed"
) ELSE (
    CALL :Log "Step 7 skipped. The input file is an ECU extract that can be used exactly as it is."
)

:: -------------------------------------------------------------------------
:: Step 8: Derive ECUC from ECU Extract
:: -------------------------------------------------------------------------
IF EXIST "%ECUXPRO_SCRIPT%" (
    FOR /F "delims=" %%F IN ('DIR /B /A-D /O-D "%ECUXPRO_OUTPATH%\*.arxml"') DO (
        SET "ECU_EXTRACTPATH=%ECUXPRO_OUTPATH%\%%F"
        GOTO :FoundFile
    )
) ELSE (
    SET "ECU_EXTRACTPATH=%ECUXPRO_FILES%"
)

:FoundFile
ECHO ECUC will be derived from: %ECU_EXTRACTPATH%
REM Derive ECU configuration from the extract and update CFG6 project structure
CALL "%DV_CFG6_INSTALPATH%\dvcfg-b" project derive-ecuc -p "%WORKSPACE_CFG6%\%PROJECT_NAME%.dvjson" -b "%BSW_PACKAGE%" "%ECU_EXTRACTPATH%"
CALL :Log "Step 8 done: ECUC derived"

:: -------------------------------------------------------------------------
:: Step 9: Project update
:: -------------------------------------------------------------------------
REM Update CFG6 project to apply new ECUC configurations
CALL "%DV_CFG6_INSTALPATH%\dvcfg-b" project update -p "%WORKSPACE_CFG6%\%PROJECT_NAME%.dvjson" -b "%BSW_PACKAGE%"
CALL :Log "Step 9 done: Project updated"

:: -------------------------------------------------------------------------
:: Step 10: Log completion
:: -------------------------------------------------------------------------
CALL :Log "Step 10 done: Script executed successfully"
PAUSE

EXIT /B 0

:: ============================================================================
:: SECTION 2 — SUBROUTINES
:: ============================================================================

:: Subroutine: Log
:: ---------------------------
:Log
    ECHO.
    SET "msg=%~1"
    ECHO !msg!
     >>"%LOG_FILE%" ECHO [%DATE% %TIME%] !msg!
    GOTO :EOF


:: Subroutine: CheckVariables
:: ---------------------------
:CheckVariables
    REM Usage: CALL :CheckVariables VAR1 VAR2 VAR3 ...
    SET "missingVars="
    FOR %%V IN (%*) DO (
        IF "!%%V!"=="" (
            SET "missingVars=!missingVars! %%V"
        )
    )
    IF DEFINED missingVars (
        CALL :Log "ERROR: The following variable(s) are not set:%missingVars%. Please set it in the bat file and rerun it"
        PAUSE
        EXIT /B
    ) ELSE (
        CALL :Log "All variables set correctly for this step."
    )
    GOTO :EOF


:: Subroutine: AskWorkspace
:: ---------------------------
:AskWorkspace
    SET "tool=%~1"
    IF "%tool%"=="CFG6" SET "toolName=DV_CONFIGURATOR_6"
    IF "%tool%"=="DEV" SET "toolName=DV_DEVELOPER"
    SET "validAnswer=no"
    :askLoop
    SET /P answer="Do you have a workspace for !toolName!? (yes/no) [default=no]: "
    IF "!answer!"=="" SET "answer=no"
    IF /I "!answer!"=="yes" (
        SET /P WORKSPACE_%tool%="Please enter the full workspace path for !toolName!: "
        IF EXIST "!WORKSPACE_%tool%!" SET "validAnswer=yes"
        IF /I "!validAnswer!"=="no" CALL :Log "Path does not exist. Please enter a valid path."
    ) ELSE IF /I "!answer!"=="no" (
        SET "WORKSPACE_%tool%=!DEFAULTWORKSPACE_%tool%!"
        SET "validAnswer=yes"
    ) ELSE (
        CALL :Log "Please answer yes or no."
    )
    IF /I "!validAnswer!"=="no" GOTO askLoop
    GOTO :EOF

:: ============================================================================
:: SECTION 3 — BATCH CONCEPT EXPLANATION
:: ============================================================================
:: %1, %2, ...        - Script arguments
:: IF EXIST           - Check if a file/folder exists
:: FOR /F             - Loop through items from command output
:: SET /A             - Arithmetic operations
:: SET "VAR=VALUE"    - Recommended for proper quoting and avoiding trailing spaces
:: COPY               - Copy files
:: CALL               - Call subroutines or other scripts
:: ECHO               - Display messages
:: Delayed Expansion (!VAR!) - Allows variable values to be updated inside loops
:: Quoting Paths:
::     Always enclose paths in double quotes ("") to handle spaces/special characters
:: Subroutines (:Log, :CheckVariables, :AskWorkspace) - Reusable blocks for logging and user input
:: PowerShell Inline Call - Optional, for editing JSON or advanced tasks
