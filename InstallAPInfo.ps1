# Define the log file path
$LogFile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\osd\AppLog.txt"
 
# Wrap your script or command in a try-catch block
Try {
    
Install-PackageProvider -Name NUGET -Force -ErrorAction Stop
Install-Script -Name get-windowsautopilotinfocommunity -Force -ErrorAction Stop
 
} Catch {
 
    # Log the error message to the log file
    Add-Content -Path $LogFile -Value $("[" + (Get-Date) + "] " + $_.Exception.Message)
}
