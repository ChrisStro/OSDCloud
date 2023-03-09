# Running pre actions
Write-Host  -ForegroundColor Cyan "Load own Powershell functions from GitHub to extend functionality"
irm https://raw.githubusercontent.com/ChrisStro/OSDCloud/main/addl/myFunctions.ps1 | iex

#Start OSDCloud ZTI the RIGHT way
if ($WimFiles = Find-OSDCloudOfflineFile -Name *.wim) {
    Write-Host  -ForegroundColor Magenta "Start OSDCloud in offline mode"
    $MyOSDCloud.ImageFileOffline = Select-Wim -WimFiles $WimFiles 
    $MyOSDCloud.OSImageIndex = Select-WimIndex -WimFile $MyOSDCloud.ImageFileOffline
    $MyOSDCloud.ZTI = $true
    Write-Host  -ForegroundColor Magenta "Start deployment via Invoke-OSDCloud with following hashtable set :"
    $MyOSDCloud
    Invoke-OSDCloud
} else {
    Write-Host -ForegroundColor Green "No offline images found"
    break
}

# Running post actions
Write-Host  -ForegroundColor Cyan "Starting OSDCloud PostAction ..."
Write-Warning "I'm not sure of what to put here yet"

# Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
