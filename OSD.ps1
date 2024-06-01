#================================================
#   [PreOS] Update Module
#================================================
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force   

#=======================================================================
#   [OS] Params and Start-OSDCloud
#=======================================================================
$Params = @{
    OSVersion = "Windows 11"
    OSBuild = "23H2"
    OSEdition = "Enterprise"
    OSLanguage = "en-us"
    OSLicense = "Volume"
    ZTI = $true
    Firmware = $false
}
Start-OSDCloud @Params

#================================================
#  [PostOS] Create PC Config Directory
#================================================

New-Item "C:\ProgramData\PCConfig" -ItemType Directory -Force | Out-Null
New-Item "C:\ProgramData\PCConfig\AutoPilot" -ItemType Directory -Force | Out-Null

#================================================
#  [PostOS] AutopilotOOBE CMD Command Line
#================================================
Write-Host -ForegroundColor Green "C:\ProgramData\PCConfig\AutoPilot\Setup.cmd"
$OOBECMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Install-PackageProvider NuGet -Force -Verbose
Start /Wait PowerShell -NoL -C Install-Script Get-WindowsAutoPilotInfoCommunity -Force -Verbose
Start /Wait PowerShell -NoL -C Get-WindowsAutoPilotInfoCommunity -online -assign
'@
$OOBECMD | Out-File -FilePath 'C:\ProgramData\PCConfig\AutoPilot\Setup.cmd' -Encoding ascii -Force

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
