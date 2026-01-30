########################################################################################################################
#
# DISCLAIMER
# for further details check the official documentation:
# https://help.vector.com/davinci-configurator-classic/en/current/dvcfg-classic/6.2-SP0/references/cli-reference.html
#
########################################################################################################################



. (Join-Path $PSScriptRoot '_config.ps1')
Import-Module (Join-Path $PSScriptRoot 'modules\MigrationHelpers.psm1') -Force



Write-Log -Message "[INFO] Start - Stop the running config core instance of dvcfg" -Color "DarkCyan" -Print $false
& $cfg6 stop --project $cfg6_project --force
Write-Log -Message "[INFO] End - done" -Color "DarkCyan" -Print $false