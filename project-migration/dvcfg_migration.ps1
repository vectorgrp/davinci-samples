######################################################################################################################################
#
# DISCLAIMER
# for further details check the official documentation:
# https://help.vector.com/davinci-configurator-classic/en/current/dvcfg-classic/6.2-SP0/migration/pro-project-migration.html
#
######################################################################################################################################



# include config file 
. .\_config.ps1



# check if cfg6 dest folder already exist and request to replace it
if (Test-Path $cfg6_project_dir) {
    Write-Log -Message "[Error] dvcfg6 destination directory exist already." -Color "DarkRed"
    Write-Log -Message "[Error] cfg6_project_dir: $cfg6_project_dir" -Color "DarkRed"
    $stepInput = Read-Host "Replace project directory [R] or exit DVCFG migration [any other Key]"
    if ($stepInput -match '^[Rr]$') {
        Write-Log -Message "[INFO] Start - Project directory will be deleted" -Color "DarkCyan"
        Remove-Item $cfg6_project_dir -Recurse -Force
        Write-Log -Message "[INFO] End - Project directory deleted." -Color "DarkCyan"
    }
    else {
        Write-Log -Message "DVCFG migration will be canceled" -Color "DarkRed"
        exit
    }
}
else {
    # directory does not exist yet. everything is fine
}



Write-Log -Message "[INFO] Start - migration of dpa to dvjson" -Color "DarkCyan"
Write-Log -Message "[INFO] In case you received the following two Warnings, they are logging bugs of the project migration tool. They can be ignored:" -Color "DarkCyan"
Write-Log -Message "'Warning: NLS unused message: canIf_frif_UnsupportedTypeOfTxPdu in: com.vector.cfg.ifp.baseecuc.mapping.legacy.impl.mapping.msg.messages' -> ignore" -Color "DarkCyan"
Write-Log -Message "'Warning: NLS missing message: com_InvalidSignalValue in: com.vector.cfg.ifp.baseecuc.mapping.legacy.impl.mapping.msg.messages' -> ignore" -Color "DarkCyan"
& $project_migration_tool `
    --dpaFile $cfg5_project `
    --bsw-package $bsw_package_r35 `
    --dest-dir $cfg6_project_dir
Write-Log -Message "[INFO] End - Migration of dvcfg6 done. please check log for errors!" -Color "DarkCyan"



# rename the auto generated log file from the project-migration tool
Move-Item -Path "DvCfgCmd.log" -Destination "DVCFG_migration.log" -Force



Write-Log -Message "[INFO] Start - create helper file (start_dvcfg6_gui.bat) to directly open the project with the selected bsw-package from the project directory" -Color "DarkCyan"
$batFile = "$cfg6_project_dir\start_dvcfg6_gui.bat"
$batContent = @"
@echo off


set dvcfg6_gui=$cfg6_gui
set project_path=$cfg6_project
set bsw_package=$bsw_package_r35


REM Start cfg6 GUI with project and sipRootPath
echo Start DaVinci Configurator 6 GUI
echo   GUI:         "%dvcfg6_gui%"
echo   Project:     "%project_path%" 
echo   BSW Package: "%bsw_package%"
echo.
%dvcfg6_gui% --project="%project_path%" --bsw-package="%bsw_package%"

timeout /t 10 >nul
exit

"@
Set-Content -Path $batFile -Value $batContent -Encoding ASCII
Write-Log -Message "[INFO] End - File '$batFile' created" -Color "DarkCyan"



Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"
Write-Log -Message "IMPORTANT:                                                            " -Color "DarkRed"
Write-Log -Message "Please check the DVCFG_migration.log for further details and keyword [ERROR] before proceeding!" -Color "DarkRed"
Write-Log -Message "Also '\Output\Log\ProjectLoad\ModelMergeReport.sarif' can be helpfull for error handling." -Color "DarkRed"
Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"
Read-Host "click [Enter] if you checked the DVCFG_migration.log for potential errors"