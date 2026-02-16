################################################################################
# Script: MasterWorkflow.ps1
# Version: 1.0
# Purpose: Master script to orchestrate modular migration tasks via a menu-based
#          workflow. Executes selected step and visually tracks completed steps.
# Author: VIRNOK - Vector Informatik GmbH
################################################################################


# Import MigrationHelpers.psm1 for consistent logging and shared helpers
$ModulePath = Join-Path $PSScriptRoot "modules\MigrationHelpers.psm1"
if (Test-Path $ModulePath) {
    Import-Module $ModulePath -Force
}
else {
    Write-Log -Message "[ERROR] MigrationHelpers.psm1 not found at $ModulePath" -Color "DarkRed"
    exit
}


################################################################################
# Initial note for users
################################################################################
Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"
Write-Log -Message "IMPORTANT:                                                                                 " -Color "DarkRed"
Write-Log -Message "Please ensure that all needed paths in _config.ps1 are already set!                        " -Color "DarkRed"
Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"

################################################################################
# Define workflow steps 
################################################################################
# Each entry represents exactly one executable step.
# Execution does NOT trigger other steps automatically.
$workflowSteps = @(
    @{
        Id        = 1
        Label     = "Tool Migration: DVCFG (DaVinci Configurator Classic) [always required]"
        Script    = ".\dvcfg_migration.ps1"
        Completed = $false
    },
    @{
        Id        = 2
        Label     = "Tool Migration: DVDEVC (DaVinci Developer Classic) [required if dvdevc workspace used in project]"
        Script    = ".\dvdevc_migration.ps1"
        Completed = $false
    },
    @{
        Id        = 3
        Label     = "Tool Migration: VTT (vVIRTUALtarget) [required if vtt workspace used in project]"
        Script    = ".\update_vtt.ps1"
        Completed = $false
    },
    @{
        Id        = 4
        Label     = "BSW-Package (SIP) Migration via GUI [always required]"
        Script    = ".\open_dvcfg6_gui.ps1"
        Completed = $false
    },
    @{
        Id        = 5
        Label     = "Diagnostic Import [required if CDD used in project]"
        Script    = ".\diag_import.ps1"
        Completed = $false
    },
    @{
        Id        = 6
        Label     = "Store User Code Blocks [always required]"
        Script    = ".\store_user_code_blocks.ps1"
        Completed = $false
    }
)

################################################################################
# Menu-driven execution loop
################################################################################
while ($true) {

    Show-Workflow -Steps $workflowSteps

    if ($workflowSteps.Completed -notcontains $false) {
        Write-Log -Message "All workflow steps completed" -Color "DarkGreen"
        Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkGreen"
        break
    }

    $stepInput = Read-Host "Enter: [step number to execute] or [Q to quit] or [S to stop dvcfg6 core]"
    if ($stepInput -match '^[Qq]$') {
        Write-Log -Message "User exited workflow" -Color "DarkRed"
        Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"
        break
    }
    
    if ($stepInput -match '^[Ss]$') {
        Write-Log -Message "[INFO] User stopped dvcfg6 core." -Color "DarkCyan"
        $_ = Invoke-StepWithRetry -ScriptPath ".\stop_dvcfg6_core.ps1" -RetryCount 2
        Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkCyan"
        continue
    }

    if (-not [int]::TryParse($stepInput, [ref]$stepInput)) {
        Write-Log -Message "[ERORR] Invalid input. Please enter a number." -Color "DarkRed"
        Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"
        continue
    }

    $step = $workflowSteps | Where-Object { $_.Id -eq $stepInput }

    if (-not $step) {
        Write-Log -Message "[ERROR] Invalid step number." -Color "DarkRed"
        Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"
        continue
    }

    if ($step.Completed) {
        Write-Log -Message "[ERROR] Selected step has already been completed." -Color "DarkRed"
        $redoStep = Read-Host "Do you want to do set the step as not completed? [Y/N]."
        if ($redoStep -match '^[Yy]$') {
            Write-Log -Message "[INFO] Step $($step.Id) will be set to not completed" -Color "DarkCyan"
            Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkCyan"
            $step.Completed = $false
        }
        else {
            Write-Log -Message "[INFO] Step $($step.Id) will not be executed again" -Color "DarkCyan"
            Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkCyan"
        }
        continue
    }

    Write-Log -Message "User selected step $($step.Id): $($step.Label)" -Color "Gray"
    Write-Log -Message " " -Color "Gray"

    if ($step.Id -eq 4) {
        Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"
        Write-Log -Message "IMPORTANT:                                                                                 " -Color "DarkRed"
        Write-Log -Message "BSW-Package (SIP) migration needs to be done manually in the GUI!                                        " -Color "DarkRed"
        Write-Log -Message "This script will only open the migrated project in the GUI.                                 " -Color "DarkRed"
        Write-Log -Message "There the BSW-Package migration needs to be triggered as usual.                                " -Color "DarkRed"
        Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"
    }

    $success = Invoke-StepWithRetry -ScriptPath $step.Script -RetryCount 2
    if ($success) {
        $step.Completed = $true
        Write-Log -Message "[INFO] Step $($step.Id) completed." -Color "DarkCyan"
        Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkCyan"
    }
    else {
        Write-Log -Message "[ERROR] Step $($step.Id) failed." -Color "DarkRed"
        Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"
    }
}

Write-Log -Message "Master workflow finished" -Color "DarkGreen"
Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkGreen"

