
# include config file 
. .\..\_config.ps1

Write-Host "Start derive ..." -ForegroundColor DarkCyan
& $cfg6 project derive-ecuc `
    --project $cfg6_project `
    --bsw-package $bsw_package_r35 `
    $cfg6_project_dir\Output\Config\EcuExtract\EcuExtract.arxml
Write-Host "done" -ForegroundColor DarkGreen

Write-Host "Stop core instance to make sure the dvjson is not blocked for further steps."
& $cfg6 stop --project $cfg6_project --force
Write-Host "-------------------------------------------------------------------------------------------" -ForegroundColor DarkCyan
