#region Offline image selection
function Select-Wim ($WimFiles) {
    $i = 1
    $available = $WimFiles | ForEach-Object {
        [PSCustomObject]@{
            Index = $i
            Name  = $_.Name
            Path  = $_.FullName
        }
        $i++
    }
    do {
        $available | Out-Host
        $selected_index = Read-Host -Prompt "Select index of wimfile"
    } until (
        $available.Index -contains $selected_index
    )
    # $available[$selected_index - 1].Path
    $Fullname = $available[$selected_index - 1].Path
    return $WimFiles | Where-Object FullName -EQ $Fullname
}
function Select-WimIndex ($WimFile) {
    $images = Get-WindowsImage -ImagePath $WimFile.FullName
    do {
        $images | Format-Table ImageIndex, ImageName | Out-Host
        $selected_index = Read-Host -Prompt "Select index of image"
    } until (
        $images.ImageIndex -contains $selected_index
    )
    return $selected_index
}
#endregion
