# make sure WinGet is present
try {
    
    $version = winget --version
    Write-Output "[i] WinGet $version is installed"

} catch {
    Write-Output "[-] WinGet not found / up-to-date"

    Add-AppxPackage -Path "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -ForceApplicationShutdown
}

# get package list
$selected_packages = @()

$packages = [PSCustomObject](Get-Content "$PSScriptRoot/winget_packages.json" | ConvertFrom-Json)

$selected_packages = $packages | Out-GridView -Title "Select your desired packages to install..." -PassThru

Write-Output "[i] Selected $($selected_packages.Count) to install"

if($selected_packages){
    
    $selected_packages | ForEach-Object {

        Write-Output "[+] Installing $($_.Name)"

        try { winget install -e --id $_.Id } catch { Write-Output "[-] Error installing $($_.Name) - please verify package id"}

    }
    
}