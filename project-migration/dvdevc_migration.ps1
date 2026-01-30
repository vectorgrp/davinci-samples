######################################################################################################################################################################
#
# DISCLAIMER
# for further details check the official documentation:
# https://help.vector.com/davinci-configurator-classic/en/current/dvcfg-classic/6.2-SP0/migration/critical-changes.html#_interactions_with_davinci_developer_classic
#
######################################################################################################################################################################



# include config file 
. .\_config.ps1



Write-Log -Message "[INFO] Start - link the dvjson in the dcf file:" -Color "DarkCyan"
& $dvdevc project link `
    --workspace-path $dvdevc_project `
    --davinci-project $cfg6_project
Write-Log -Message "[INFO] End - linking dvjson to dcf file is done." -Color "DarkCyan"



Write-Log -Message "[INFO] Start - convert dvdevc workspace:" -Color "DarkCyan"
Start-Process `
    -FilePath $dvdevc `
    -ArgumentList @(
    "project", "convert",
    "--workspace-path", $dvdevc_project,
    "--extract-file", "$cfg6_project_dir\Output\Config\EcuExtract\EcuExtract.arxml"
) `
    -Wait `
    -NoNewWindow `
    -RedirectStandardOutput "DVDEVC_migration.log"
Write-Log -Message "[INFO] End - dvdevc conversation is done." -Color "DarkCyan"



Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"
Write-Log -Message "IMPORTANT:                                                                                 " -Color "DarkRed"
Write-Log -Message "Further conversation details can be found in DVDEVC_migration.log                          " -Color "DarkRed"
Write-Log -Message "-------------------------------------------------------------------------------------------" -Color "DarkRed"