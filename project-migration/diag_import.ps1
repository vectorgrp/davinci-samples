###################################################################################################################################################################################
#
# DISCLAIMER
# for further details check the official documentation:
# https://help.vector.com/davinci-configurator-classic/en/current/dvcfg-classic/6.2-SP0/configuration/ddm/import-diagnostic-modules.html#_how_to_get_a_diagnostic_module_to_import
# 
# similar steps to this can be done in Visual Studio Code with the 'DaVinci-AUTOSAR-JSON' extension: 
# https://help.vector.com/davinci-configurator-classic/en/current/davinci-autosar-json/6.2-SP0/index.html
#
###################################################################################################################################################################################



# include config file 
. .\_config.ps1



Write-Log -Message "[INFO] To make sure the dvjson file is not blocked from the GUI, the core instance will be stopped" -Color "DarkCyan"
& ".\stop_dvcfg6_core.ps1"



# read cdd properties from dpa settings
Write-Log -Message "[INFO] Start - Getting file pre processing data." -Color "DarkCyan"
$cdd_info = Get-Content -Raw -Path $cdd_preprocessing_info | ConvertFrom-Json
$cdd = Join-Path $cdd_dir ($cdd_info.fileSet[0].diagnostic.description.value -replace '^[\.\\/]+', '')
$ecu = $cdd_info.fileSet[0].diagnostic.ecu
$variant = $cdd_info.fileSet[0].diagnostic.variant
$diagnostic_arxml = $cdd -replace "\.cdd$", ".arxml"
Write-Log -Message "[INFO] End - Got file pre processing data" -Color "DarkCyan"



Write-Log -Message "[INFO] Start - Generate DdmControlfile with output of the pre processing data." -Color "DarkCyan"
$out = @"
<DdmControl Version="2.0">
<LicenseInfo>
<SipLicenseFile>$bsw_package_r35\Components\Dcm\ComponentLicense_Dcm.lic</SipLicenseFile>
</LicenseInfo>
<ProcessingSteps>
<Import>
<InputFile>$cdd</InputFile>
<Ecu>$ecu</Ecu>
<Variant>$variant</Variant>
</Import>
<ShapeModel />
<ExportEcuc>
<OutputFormat>Ecuc</OutputFormat>
<OutputFile>$diagnostic_arxml</OutputFile>
<BswmdDir>$bsw_package_r35\Components</BswmdDir>
</ExportEcuc>
</ProcessingSteps>
</DdmControl>
"@
$out | Set-Content $ddm_config_file -Encoding UTF8
Write-Log -Message "[INFO] End - DdmControlfile generated." -Color "DarkCyan"



Write-Log -Message "[INFO] Start - convert CDD input file with DDM to an ARXML input file using the DdmControlFile:" -Color "DarkCyan"
& $ddm convert `
  -if $ddm_config_file `
  -lf DDM_log\importCdd.txt
Write-Log -Message "[INFO] End - conversion from CDD to ARXML done." -Color "DarkCyan"



Write-Log -Message "[INFO] Start - Run the diagnostic-modules import with before created ARXML:" -Color "DarkCyan"
& $cfg6 import diagnostic-modules `
  --project $cfg6_project `
  --bsw-package $bsw_package_r35 `
  --file-set $diagnostic_arxml
Write-Log -Message "[INFO] End - import of diagnostic data done." -Color "DarkCyan"