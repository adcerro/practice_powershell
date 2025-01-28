# Made by Alan Daniel Florez Cerro (adcerro)
# Run as admin with: powershell.exe -executionpolicy unrestricted PATH/TO/SCRIPT.ps1

Write-Output "Script written by: adcerro`n"

$serial = wmic bios get serialnumber

$serial = $serial[2].Trim()

Write-Output "Serial Number: $serial `nSetting stuff up"

# The programs with silent option or that don't require interacting with the installer at all.
Get-ChildItem -Path "$PSScriptRoot\silent" -Filter *.exe | 
Foreach-Object {
    Write-Output "Installing: $($_.Name)"
    Start-Process -FilePath $_.Name -ArgumentList "/S" -Wait
}

cd $PSScriptRoot

# Specific custom install(s)
Write-Output "Installing fusion inventory"

$tagCheck = "n"
while($tagCheck.ToLower() -ne "y"){
    DO{
    $dependency = Read-Host 'Dependency acronim'
    }while([string]::IsNullOrEmpty($dependency))

    $dependency = $dependency.ToUpper()

    DO{
    $year = Read-Host 'Current year'
    }while([string]::IsNullOrEmpty($year))

    $tag = "$serial-$dependency-$year"

    Write-Output "`nTag: $tag `n"

    Write-Output "REMEMBER TAGS WITH SPACES ARE NOT VALID`n"

    $tagCheck = Read-Host 'Confirm Dependency acronim [y/n]'
}

$server = Get-Content -Path .\server.txt -TotalCount 1

./fusioninventory-agent_windows-x64_2.3.20.exe /acceptlicense /S /runnow /execmode=Service /server=$server /tag=$tag

Start-Process "http://127.0.0.1:62354/"

Write-Output "Finished Script."
