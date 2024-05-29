# Define the log file path
$LogFile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\osd\AppLog.log"
 
# Wrap your script or command in a try-catch block

Try {

Install-Script -Name get-windowsautopilotinfocommunity -Force -wait -ErrorAction Stop
 
} Catch {
 
    # Log the error message to the log file
    Add-Content -Path $LogFile -Value $("[" + (Get-Date) + "] " + $_.Exception.Message)
}

