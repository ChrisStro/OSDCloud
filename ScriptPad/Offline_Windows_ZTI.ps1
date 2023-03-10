# Running pre actions
Write-Host  -ForegroundColor Cyan "Starting SeguraOSD's Custom OSDCloud ..."

#Start OSDCloud ZTI the RIGHT way
Start-OSDCloud -FindImageFile -SkipAutopilot -ZTI

# Running post actions
Write-Host  -ForegroundColor Cyan "Starting OSDCloud PostAction ..."
Write-Warning "I'm not sure of what to put here yet"

# Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
