


#################################################################################################################
#################################################################################################################
#################################################################################################################
# SET THESE VARIABLES BEFORE EXECUTING THE WORKFLOW
# (let the string empty for variables that are not needed, eg. no developer project exist)

# path to the BSW-Package (SIP) folder
$bsw_package_r35 = ""

# path to folder where the dvcfg-b.exe is located
$cfg6_bridge = "" 

# path to the developer cli: dvdevc.exe
$dvdevc = "" 

# path to the folder where the dpa file is located
$cfg5_project_dir = "" 

# path to the folder where the dvjson file will be created
$cfg6_project_dir = "" 

# project name (without extension!)
$dvcfg_project_name = "" 

# vVirtualtarget: VttMake.exe
$vtt_make = "" 

# VTT project (with extension!) from DvCfg5:
$vtt_make_project = ""

#################################################################################################################
# Example:
# $bsw_package_r35 = "C:\SIP\CBDxxx\"
# $cfg6_bridge = "D:\dev\dvcfg-6.2.1"
# $dvdevc = "C:\Program Files\Vector DaVinci Developer Classic 4.17.45 (SP2)\Bin\dvdevc.exe"
# $cfg5_project_dir = "D:\My\CFG5\Project\"
# $cfg6_project_dir = "D:\My\CFG6\Project\"
# $dvcfg_project_name = "MyEcu"
# $vtt_make = "C:\Uti\PC\Vector\vVIRTUALtarget\V9_0_137\Exec64\VttMake.exe"
# $vtt_make_project = "D:\My\CFG5\Project\Config\VTT\MyEcu.vttmake"
#################################################################################################################




#################################################################################################################
#################################################################################################################
# DO NOT CHANGE THE FOLLOWING VARIABLES! (ONLY if you really know what you do)
#################################################################################################################
#################################################################################################################

# TOOLS
$project_migration_tool = "$cfg6_bridge\migration\project-migration.exe"
$cfg6 = "$cfg6_bridge\dvcfg-b.exe"
$cfg6_gui = "$cfg6_bridge\dvcfgui-b\dvcfgui-b.exe"
$ddm = "$bsw_package_r35\Misc\DiagnosticToEcuconfig\Application\DiagnosticDataModifier.exe"
$dvuct = "$bsw_package_r35\Misc\DaVinciUserCodeTool\Application\DvUCT.bat"


# DVCFG 5
$cfg5_project = "$cfg5_project_dir\$dvcfg_project_name.dpa"


# DVCFG 6
$cfg6_project = "$cfg6_project_dir\$dvcfg_project_name.dvjson"


# DVDEVC
$dvdevc_project_dir = "$cfg6_project_dir\Config\AppConfig"
$dvdevc_project = "$dvdevc_project_dir\$dvcfg_project_name.dcf"


# CDD
$cdd_dir = "$cfg6_project_dir\Input\OEMInput\Preprocessing\"
$cdd_preprocessing_info = "$cdd_dir\file_preprocessing_data.json"
$ddm_config_file = "$cdd_dir\DemoDatabase\DdmControlFile.xml"


# USER CODE BLOCKS
$cfg5_genData_dir = "$cfg5_project_dir\Appl\Source"
$user_code_blocks_dir = "$cfg6_project_dir\Output\Source\GenData\"
