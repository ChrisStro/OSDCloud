Watch-OSDCloudProvisioning {
    Write-Host -ForegroundColor Cyan "Hey this script running an OSD Cloud ZTI Deployment while displaying a MahApps.Metro progress Window"

    #Start OSDCloud ZTI
    Write-Host  -ForegroundColor Cyan "Starting OSDCloud PreAction stuff..."
    Start-Sleep -Seconds 5

    Start-OSDCloud -OSBuild 20H2 -OSEdition Pro -ZTI

    #Anything I want  can go right here and I can change it at any time since it is in the Cloud!!!!!
    Write-Host  -ForegroundColor Cyan "Starting OSDCloud PostAction stuff..."

    # lets throw an error, just for fun
    Update-OSDProgress -DisplayError "Custom error message, pls unlock screen!"

    #Restart from WinPE
    #Start-Sleep -Seconds 20
    #wpeutil reboot
} -Window
