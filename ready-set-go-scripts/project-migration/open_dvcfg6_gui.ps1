# include config file 
. .\_config.ps1

Write-Log -Message "[INFO] open dvcfg6 gui:" -Color "DarkCyan"
Start-Process -FilePath $cfg6_gui -ArgumentList "--project=$cfg6_project --bsw-package=$bsw_package_r35"