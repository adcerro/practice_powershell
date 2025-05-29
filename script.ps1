# Made by Alan Daniel Florez Cerro (adcerro)
# Run as admin with: powershell.exe -executionpolicy unrestricted PATH/TO/SCRIPT.ps1

Write-Output "Script written by: adcerro`n"

$serial = (Get-CimInstance Win32_BIOS).SerialNumber

Write-Output "Serial Number: $serial `nSetting stuff up"

# The programs that barely need interacting with the installer.
Get-ChildItem -Path "$PSScriptRoot\programs" -Filter *.exe | 
Foreach-Object {
    Write-Output "Installing: $($_.Name)"
    Start-Process -FilePath $_.FullName -ArgumentList "/S"
}

# Specific custom install(s)
cd $PSScriptRoot

Write-Output "Installing NanaZip"
.\NanaZip_5.0.1263.0.msixbundle

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
#FusionInventory without server
Start-Process -FilePath ./fusioninventory-agent_windows-x64_2.3.20.exe -ArgumentList "/acceptlicense /S /execmode=Service /tag=$tag" -Wait

$server = Get-Content -Path .\server.txt -TotalCount 1

#Modify registry to add server
Set-ItemProperty -Path "HKLM:\SOFTWARE\FusionInventory-Agent" -Name "server" -Value "$server"

#Restart service to apply the changes
Restart-Service -Name "FusionInventory-Agent"

Start-Process "http://127.0.0.1:62354/"

Write-Output "Opening computer management"

compmgmt.msc

Write-Output "Opening domain config"

Write-Output "Computer Name would be:`n$dependency-$serial"

sysdm.cpl

Write-Output "Finished Script."
