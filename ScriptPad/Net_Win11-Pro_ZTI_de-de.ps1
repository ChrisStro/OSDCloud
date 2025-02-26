Write-Host  -ForegroundColor Magenta "Starting OSDCloud with Provision Package support and selfhosted WIM-File"
Start-Sleep -Seconds 5

# Load custom functions
Write-Host -ForegroundColor Cyan "Load own function from GitHub to extend functionality"
Invoke-RestMethod "https://raw.githubusercontent.com/ChrisStro/OSDCloud/main/addl/myFunctions.ps1" -UseBasicParsing | Invoke-Expression

# My own download function
Invoke-RestMethod "https://gist.githubusercontent.com/ChrisStro/37444dd012f79592080bd46223e27adc/raw/5ba566bd030b89358ba5295c04b8ef1062ddd0ce/Get-FileFromWeb.ps1" -UseBasicParsing | Invoke-Expression

#Change Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Cyan "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

# Set basic Env variables
Write-Host -ForegroundColor Cyan "Configure OSDCloud using Env variables"
$Global:MyOSDCloud = @{} # will be parsed into $Global:OSDCloud by Invoke-OSDCloud
$MyOSDCloud.ZTI = $true
$MyOSDCloud.ClearDiskConfirm = $false

# Select web image & index
Write-Host -ForegroundColor Cyan "Set selfhosted wim-url and wim-index"
$MyOSDCloud.ImageFileUrl = "http://osd.onmy.net:8880/wim/Win11_24H2_German_x64.wim"
$MyOSDCloud.OSImageIndex = 5

# Do some configuration
$MyOSDCloud.SkipAutopilot   = $true
$MyOSDCloud.updateFirmware  = $false
$MyOSDCloud.DriverPackName  = "" # no driver install
# $MyOSDCloud.DriverPackName      = "Microsoft Update Catalog" # via windows update

# Add Provpack

Write-Host -ForegroundColor DarkGray "Start deployment via Invoke-OSDCloud with following hashtable set :"
$MyOSDCloud

Write-Host -ForegroundColor DarkGray "Wait 5 Sec"
Start-Sleep -Seconds 5

Write-Host -ForegroundColor Magenta "Start OSDCloud in offline mode"
Invoke-OSDCloud

#Start OSDCloud ZTI the RIGHT way
#Write-Host  -ForegroundColor Cyan "Start OSDCloud with WIM download from custom url"
#Start-OSDCloud -ImageFileUrl "http://osd.onmy.net:8880/wim/Win11_24H2_German_x64.wim" -OSImageIndex 5 -SkipAutopilot -ZTI

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot