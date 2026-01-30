###################################################################################################################################################################################
#
# DISCLAIMER
# for further details check the official documentation:
# https://help.vector.com/vVIRTUALtarget/9.5/en/Help/Content/Topics/General/AUTOSARClassicECUs/vVIRTUALtargetMigrationDPAtoDVJSON.htm?Highlight=configurator%206# 
#
###################################################################################################################################################################################



# include config file 
. .\_config.ps1



Write-Log -Message "[INFO] Start - update VTT:" -Color "DarkCyan"
& $vtt_make update $vtt_make_project `
    --systemDesc $cfg6_project `
    --bswPackage $bsw_package_r35
Write-Log -Message "[INFO] End - updating VTT done." -Color "DarkCyan"