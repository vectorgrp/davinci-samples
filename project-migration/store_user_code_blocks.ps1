############################################################################################################################
#
# DISCLAIMER
# for further details check the official documentation:
# https://help.vector.com/davinci-configurator-classic/en/current/dvcfg-classic/6.2-SP0/generation/user-code-handling.html
#
############################################################################################################################



# include config file 
. .\_config.ps1



Write-Log -Message "[INFO] Start - storing user code blocks in .ucb files" -Color "DarkCyan"
& $dvuct store `
    --rootPath $cfg5_genData_dir `
    --userCodeStoragePath $user_code_blocks_dir
Write-Log -Message "[INFO] End - storing user code blocks done." -Color "DarkCyan"