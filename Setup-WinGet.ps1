# make sure WinGet is present
try {
    
    $version = winget --version
    Write-Output "[i] WinGet $version is installed"

} catch {
    Write-Output "[-] WinGet not found / up-to-date"

    Add-AppxPackage -Path "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -ForceApplicationShutdown
}

$selected_packages = @()

$packages = [PSCustomObject](Get-Content "$PSScriptRoot/winget_packages.json" | ConvertFrom-Json)

$selected_packages = $packages | Sort-Object -Property Category,Name  | Out-GridView -Title "Select your desired packages to install..." -PassThru

Write-Output "[i] Selected $($selected_packages.Count) to install"

if($selected_packages){
    
    $selected_packages | ForEach-Object {

        Write-Output "[+] Installing $($_.Name)"

        try { winget install -e --id $_.Id } catch { Write-Output "[-] Error installing $($_.Name) - please verify package id"}

    }
    
}

$scheduled_task = Get-ScheduledTask | Where-Object {($_.TaskPath -like "\winget-toolbox\") -and ($_.TaskName -like "WinGet Auto-updates")}

if(!($scheduled_task)){
    $title    = 'Enable auto-updates'
    $question = 'Do you want to enable auto-updates on system start up (Creates a scheduled task)?'
    $choices  = '&Yes', '&No'
    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    
    if ($decision -eq 0) {
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $action = New-ScheduledTaskAction -Execute "PowerShell" -Argument "winget upgrade --all --silent --accept-package-agreements --accept-source-agreements"
        Register-ScheduledTask -TaskName "WinGet Auto-updates" -TaskPath "winget-toolbox" -Action $action -Trigger $trigger | Out-Null
        Write-Output "[+] Created a scheduled task to enable auto updates via winget on system start up"
    } else {
        Write-Output "[i] Auto-updates not enabled."
    }
}

