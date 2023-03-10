Write-Host  -ForegroundColor Magenta "Starting OSDCloud with Provision Package support"
Start-Sleep -Seconds 5

# Load custom functions
Write-Host -ForegroundColor Cyan "Load own function from GitHub to extend functionality"
Invoke-RestMethod "https://raw.githubusercontent.com/ChrisStro/OSDCloud/main/addl/myFunctions.ps1" -UseBasicParsing | Invoke-Expression

# Change Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host -ForegroundColor Cyan "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

# Set basic Env variables
Write-Host -ForegroundColor Cyan "Configure OSDCloud using Env variables"
$Global:MyOSDCloud              = @{} # will be parsed into $Global:OSDCloud by Invoke-OSDCloud
$MyOSDCloud.ZTI                 = $false
$MyOSDCloud.ClearDiskConfirm    = $false

# Select offline image & index
Write-Host -ForegroundColor Cyan "Load own function from GitHub to extend functionality"
$MyOSDCloud.ImageFileItem       = Select-OSDCloudFileWim
$MyOSDCloud.OSImageIndex        = Select-OSDCloudImageIndex -ImagePath $MyOSDCloud.ImageFileItem

# Select Provision Packages
$MyOSDCloud.ProvPack            = Select-OSDCloudProvPackage

Write-Host -ForegroundColor DarkGray "Start deployment via Invoke-OSDCloud with following hashtable set :"
$MyOSDCloud

Write-Host -ForegroundColor Magenta "Start OSDCloud in offline mode"
Invoke-OSDCloud

# Apply Provision Packages
if ($MyOSDCloud.ProvPack) {
    Write-Host  -ForegroundColor Cyan "Apply following Provisioning Packages to expanded OS"
    $MyOSDCloud.ProvPack
    Start-Sleep -Seconds 5
    Add-OSDCloudProvPackage $OSDCloud.ProvPack
}

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
