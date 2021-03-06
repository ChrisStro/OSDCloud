Write-Host  -ForegroundColor Cyan "Starting SeguraOSD's Custom OSDCloud ..."
Start-Sleep -Seconds 5

#Change Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Cyan "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

#Make sure I have the latest OSD Content
Write-Host  -ForegroundColor Cyan "Updating the awesome OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Cyan "Importing the sweet OSD PowerShell Module"
Import-Module OSD -Force

#Define AutopilotConfiguration.json for Selfprovisioning Demo
Write-Host  -ForegroundColor Cyan "Set AutopilotConfiguration.json for unattended provisioning"
$Global:MyOSDCloud = @{}
$MyOSDCloud.AutopilotFile = Find-OSDCloudOfflineFile -Name *AutopilotConfigurationFile* | Select-Object -First 1

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

#Anything I want  can go right here and I can change it at any time since it is in the Cloud!!!!!
Write-Host  -ForegroundColor Cyan "Starting OSDCloud PostAction ..."
Write-Warning "I'm not sure of what to put here yet"

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
