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
#  [PostOS] Create AutoPilot PS Script
#================================================

Write-Host -ForegroundColor Green "C:\ProgramData\PCConfig\AutoPilot\Setup.ps1"
$OOBECMD = @'

Install-PackageProvider NuGet -Force -Verbose
sleep -seconds 10
Install-Script Get-WindowsAutoPilotInfoCommunity -Force -Verbose
sleep -seconds 10
Get-WindowsAutoPilotInfoCommunity -online -TenantId '57a4b287-a8d2-452b-acfd-242d26c3630c' -AppId '235d10fe-187e-40a3-9230-10f190ea4f58' -AppSecret 'U-Q8Q~PJJ3r.K3eKG_0Iw6-555kI2RtaUGO_Adat' -assign -reboot
'@
$OOBECMD | Out-File -FilePath 'C:\ProgramData\PCConfig\AutoPilot\Setup.ps1' -Encoding ascii -Force

#================================================
#  [PostOS] SetupComplete CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\Setup\Scripts\SetupComplete.cmd"
$SetupCompleteCMD = @'
powershell.exe -Command Set-ExecutionPolicy RemoteSigned -Force
powershell.exe -Command "& {IEX (IRM https://raw.githubusercontent.com/crashrebootrepeat/osd/main/oobetasks.ps1)}"
'@
$SetupCompleteCMD | Out-File -FilePath 'C:\Windows\Setup\Scripts\SetupComplete.cmd' -Encoding ascii -Force

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
