$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-InstallAPInfo.log"
Start-Transcript -Path (Join-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD\" $Global:Transcript) -ErrorAction Ignore

Write-Host -ForegroundColor Green "Install NuGet"

Start-Sleep -Seconds 5

Install-PackageProvider -Name NUGET -Force

Start-Sleep -Seconds 5

Write-Host -ForegroundColor Green "Install NuGet"

Install-Script -Name get-windowsautopilotinfocommunity -Force

Stop-Transcript