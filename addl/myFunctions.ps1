function Select-OSDCloudProvPackage {
    [CmdletBinding()]
    param (
        [switch]$All
    )

    $i = $null
    [array]$FindOSDCloudFile = Find-OSDCloudOfflineFile -Name *.ppkg | Sort-Object FullName

    $FindOSDCloudFile = $FindOSDCloudFile | Where-Object { $_.FullName -notlike "C*" }

    if ($FindOSDCloudFile) {
        if ($All) {
            Return Get-Item $FindOSDCloudFile
        }
        else {
            $ProvisioningPackages = foreach ($Item in $FindOSDCloudFile) {
                $i++

                $root = $Item.PSDrive.Root
                $SourceDevice = Get-CimInstance win32_Volume -Filter "Caption='$root\'" | Select-Object -ExpandProperty DeviceID # Get-Volume does not return device id for ramdrives
                #$Fullpath = Join-Path -Path $DeviceID (Split-Path $Item -NoQualifier)

                [PSCustomObject]@{
                    Selection   = $i
                    Name        = $Item.Name
                    Fullname    = $Item.Fullname
                    SourceDevice    = $SourceDevice
                }
            }

            $ProvisioningPackages | Select-Object -Property Selection, Name | Format-Table | Out-Host
            $SelectedItems = @()
            do {
                if ($SelectedItems) { Write-Host "Current selection : $($SelectedItems -join ",") " }

                $SelectReadHost = Read-Host -Prompt "Enter the Selection of the Provisioning Package to apply, press [A]ll or [D]one or [S]kip"
                if ($SelectReadHost -in $ProvisioningPackages.Selection -and $SelectReadHost -notin $SelectedItems) {
                    $SelectedItems += $SelectReadHost
                }
                elseif ($SelectReadHost -eq 'A') {
                    $SelectedItems = $ProvisioningPackages.Selection
                }
            }
            until (($SelectedItems.count -eq $ProvisioningPackages.count) -or
                $SelectReadHost -eq 'S' -or
                $SelectReadHost -eq 'D'
            )

            if ($SelectReadHost -eq 'S') {
                break
            }

            $ProvisioningPackages = $ProvisioningPackages | Where-Object { $_.Selection -in $SelectedItems }

            Return $ProvisioningPackages
        }
    }
}
function Add-OSDCloudProvPackage {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [object[]]$OSDCloudProvPackages
    )
    process {
        foreach ($item in $OSDCloudProvPackages) {
            $PPKGPath = $item.Fullname
            $PPKGName = $item.name
            $PPKGSourceDevice = $item.SourceDevice

            # Check if volume is accessible for dism ( does not support Volume Paths )
            $SourceDriveLetter = Get-CimInstance Win32_Volume | Where-Object DeviceID -eq $PPKGSourceDevice | Select-Object -ExpandProperty Caption
            if (!$SourceDriveLetter) {
                # temporarily reassign drive letter if needed ( after Expand OS for example )
                $tempAssign = $true
                $freeDriveLetter = Get-ChildItem function:[d-z]: -Name | Where-Object{ !(test-path $_) } | Get-Random
                $SourceDriveLetter = Set-Volume -UniqueId $PPKGSourceDevice -DriveLetter $freeDriveLetter
            }

            $newPPKGPath = Join-Path $SourceDriveLetter (Split-Path -Path $PPKGPath -NoQualifier)
            Write-Host -ForegroundColor DarkGray "Applying $PPKGName " -NoNewline

            $command = "DISM.exe /Image=c:\ /Add-ProvisioningPackage /PackagePath:`"$newPPKGPath`""
            $result = $command | Invoke-Expression
            if ($tempAssign) {
                Get-Volume -UniqueId $PPKGSourceDevice | Get-Partition | Remove-PartitionAccessPath -AccessPath "$freeDriveLetter\"
            }
            if ($LASTEXITCODE -eq 0) {
                Write-Host -ForegroundColor Green "OK"
            }
            else {
                Write-Host -ForegroundColor Red "FAIL"
                throw "There was en error when applying $PPKGName offline. Error was $result"
            }
        }
    }
}
