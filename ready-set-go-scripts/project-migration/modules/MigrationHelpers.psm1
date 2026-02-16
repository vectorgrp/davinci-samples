################################################################################
# Module: MigrationHelpers.psm1
# Version: 1.1
# Purpose: Reusable helper functions for the CFG6 migration workflow
# Author: VISKGU - Vector Informatik GmbH
################################################################################



# --------------------------------------------------------------------------------
# Function: Write-Log
# --------------------------------------------------------------------------------
# Purpose:
#   Logs a message to both the console and a log file.
#   Automatically timestamps every message.
# Usage:
#   Write-Log "Starting migration step" -LogFile "MyLog.txt"
# Notes:
#   If no log file is specified, defaults to "MasterWorkflow.log".
function Write-Log {
    param(
        [Parameter(Mandatory = $true)][string]$Message,
        [string]$LogFile = "MasterWorkflow.log",
        [string]$Color = "Gray",
        [bool]$Print = $true
    )
    if ($print) {
        Write-Host $Message -ForegroundColor $color
    }
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $Message"
    try {
        Add-Content -Path $LogFile -Value $line
    }
    catch {
        Write-Host "WARNING: Could not write to log file '$LogFile': $_" -ForegroundColor "DarkYellow"
    }
}


# ------------------------------------------------------------------------------
# Function: Invoke-StepWithRetry
# ------------------------------------------------------------------------------
# Executes a PowerShell script with retry handling and execution timing.
# Intended for maintainers: provides detailed logging on failures.
function Invoke-StepWithRetry {
    param(
        [string]$ScriptPath,
        [int]$RetryCount = 1
    )

    for ($attempt = 1; $attempt -le $RetryCount; $attempt++) {

        $startTime = Get-Date
        Write-Log -Message "[INFO] Starting ${ScriptPath} (Attempt ${attempt})..." -Color "DarkCyan"

        try {
            & $ScriptPath

            $elapsed = (Get-Date) - $startTime
            Write-Log -Message "[INFO] ${ScriptPath} finished in $([math]::Ceiling($elapsed.TotalSeconds)) seconds" -Color "DarkCyan"
            return $true
        }
        catch {
            $elapsed = (Get-Date) - $startTime
            Write-Log -Message "[ERROR] failed after running ${ScriptPath} on attempt ${attempt}: $($_.Exception.Message) in $([math]::Ceiling($elapsed.TotalSeconds)) seconds" -Color "DarkRed"

            if ($attempt -lt $RetryCount) {
                Write-Log -Message "[WARNING] Retrying ${ScriptPath}..." -Color "DarkYellow"
            }
            else {
                Write-Log -Message "[ERROR] Step failed after ${RetryCount} attempts: ${ScriptPath}" -Color "DarkRed"
                return $false
            }
        }
    }
}



# ------------------------------------------------------------------------------
# Function: Show-Workflow
# ------------------------------------------------------------------------------
# Displays the workflow menu as seen by the user.
# Shows completion state via a checkmark.
function Show-Workflow {
    param($Steps)

    Write-Host "`nWorkflow status:"
    foreach ($step in $Steps) {
        $status = if ($step.Completed) { "V" } else { " " }
        Write-Host "[${status}] [$($step['Id'])] $($step['Label'])"
    }
    Write-Host ""
}