#=======================================================================
#   PreOS: Update-Module
#=======================================================================
Install-Module OSD -Force
Import-Module OSD -Force
#=======================================================================
#   OS: Params and Start-OSDCloud
#=======================================================================
$Params = @{
    OSBuild = "21H1"
    OSEdition = "Pro"
    OSLanguage = "en-gb"
    OSLicense = "Retail"
    SkipAutopilot = $true
    SkipODT = $true
}

Start-OSDCloud @Params

#=======================================================================
#   PostOS: OOBEDeploy Configuration
#=======================================================================
$OOBEDeployJson = @'
{
    "Autopilot":  {
                      "IsPresent":  true
                  },
    "RemoveAppx":  [
                       "CommunicationsApps",
                       "OfficeHub",
                       "People",
                       "Skype",
                       "Solitaire",
                       "Xbox",
                       "ZuneMusic",
                       "ZuneVideo"
                   ],
    "UpdateDrivers":  {
                          "IsPresent":  true
                      },
    "UpdateWindows":  {
                          "IsPresent":  true
                      }
}
'@
$OOBEDeployJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json" -Encoding ascii -Force

#=======================================================================
#   PostOS: Enroll Autopilot
#=======================================================================
$AutopilotCmd = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
set path=%path%;C:\Program Files\WindowsPowerShell\Scripts
start PowerShell -NoL -W Mi
start /wait PowerShell -NoL -C Install-Script -Name get-windowsautopilotinfocommunity -Force
start /wait PowerShell -NoL -C  get-windowsautopilotinfocommunity
'@


#=======================================================================
#   PostOS: Restart-Computer
#=======================================================================
Restart-Computer
