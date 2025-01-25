# Made by Alan Daniel Florez Cerro (adcerro)
# Run as admin with: powershell.exe -executionpolicy unrestricted PATH/TO/SCRIPT.ps1

Write-Output "Script written by: adcerro`n"

$serial = wmic bios get serialnumber

Write-Output "Serial Number: $($serial[2])`n"

Write-Output "Setting stuff up"

# The programs with silent option or that don't require interacting with the installer at all.
cd $PSScriptRoot\handsfree

Get-ChildItem -Filter *.exe | 
Foreach-Object {
    Write-Output "Installing: $($_.Name)"
    Start-Process -FilePath $_.Name -ArgumentList "/S" -Wait
}

cd ..

# Specific custom install(s)
Write-Output "Installing fusion inventory"
./fusioninventory-agent_windows-x64_2.3.20.exe /acceptlicense /S /runnow /execmode=Service /server=""

Write-Output "Finished Script."