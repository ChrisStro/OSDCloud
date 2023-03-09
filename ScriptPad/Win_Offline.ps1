# Running pre actions
Write-Host  -ForegroundColor Cyan "Starting OSDCloud PreAction ..."

#Start OSDCloud ZTI the RIGHT way
if (Find-OSDCloudOfflineFile -Name *.wim) {
    Write-Host  -ForegroundColor Magenta "Start OSDCloud in offline mode"
    $MyOSDCloud.ImageFileOffline = Find-OSDCloudOfflineFile -Name Win10* | Select-Object -First 1
    $MyOSDCloud.OSImageIndex = 8
    $MyOSDCloud.ZTI = $true
    Write-Host  -ForegroundColor Magenta "Start deployment via Invoke-OSDCloud with following hashtable set :"
    $MyOSDCloud
    Invoke-OSDCloud
} else {
    Write-Host -ForegroundColor Green "Start OSDCloud in cloud mode"
    Start-OSDCloud -OSBuild 21H2 -OSEdition Pro -OSLanguage de-de -ZTI    
}

# Running post actions
Write-Host  -ForegroundColor Cyan "Starting OSDCloud PostAction ..."
Write-Warning "I'm not sure of what to put here yet"

# Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
