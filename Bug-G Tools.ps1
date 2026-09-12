param(
    [switch]$NoLogo
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Continue'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulePath = Join-Path $root 'modules'

Import-Module (Join-Path $modulePath 'BugG.Core.psm1') -Force -DisableNameChecking
Import-Module (Join-Path $modulePath 'BugG.Cleanup.psm1') -Force -DisableNameChecking
Import-Module (Join-Path $modulePath 'BugG.Network.psm1') -Force -DisableNameChecking
Import-Module (Join-Path $modulePath 'BugG.Windows.psm1') -Force -DisableNameChecking
Import-Module (Join-Path $modulePath 'BugG.Pubg.psm1') -Force -DisableNameChecking
Import-Module (Join-Path $modulePath 'BugG.Processes.psm1') -Force -DisableNameChecking
Import-Module (Join-Path $modulePath 'BugG.Diagnostics.psm1') -Force -DisableNameChecking
Import-Module (Join-Path $modulePath 'BugG.Presets.psm1') -Force -DisableNameChecking
Import-Module (Join-Path $modulePath 'BugG.Menu.psm1') -Force -DisableNameChecking

$ctx = Initialize-BugGContext -RootPath $root

$actions = @{
    'Start-Pubg' = { Start-Pubg }
    'Stop-Pubg' = { Stop-Pubg }
    'Restart-Pubg' = { Restart-Pubg }
    'Show-PubgProcesses' = { Show-PubgProcesses }
    'Backup-PubgConfig' = { Backup-PubgConfig }
    'Open-PubgFolder' = { Open-PubgFolder }

    'Clear-PubgTemp' = { Clear-PubgTemp }
    'Clear-ShaderCache' = { Clear-ShaderCache }
    'Clear-WindowsTemp' = { Clear-WindowsTemp }
    'Clear-BugGFullSafe' = { Clear-BugGFullSafe }
    'Invoke-BugGCleanupSimulation' = { Invoke-BugGCleanupSimulation }

    'Flush-Dns' = { Flush-Dns }
    'Register-Dns' = { Register-Dns }
    'Renew-Ip' = { Renew-Ip }
    'Reset-Winsock' = { Reset-Winsock }
    'Repair-BugGNetwork' = { Repair-BugGNetwork }
    'Test-PubgNetwork' = { Test-PubgNetwork }
    'Show-PubgConnections' = { Show-PubgConnections }
    'Show-PubgNetworkUsage' = { Show-PubgNetworkUsage }

    'Set-UltimatePerformance' = { Set-UltimatePerformance }
    'Disable-GameDvr' = { Disable-GameDvr }
    'Disable-WindowsNotifications' = { Disable-WindowsNotifications }
    'Enable-HardwareGpuScheduling' = { Enable-HardwareGpuScheduling }
    'Apply-MmcssGameTweaks' = { Apply-MmcssGameTweaks }
    'Set-VisualEffectsAuto' = { Set-VisualEffectsAuto }
    'Set-VisualEffectsPerformance' = { Set-VisualEffectsPerformance }
    'Optimize-WindowsForGames' = { Optimize-WindowsForGames }
    'Restore-WindowsGamingDefaults' = { Restore-WindowsGamingDefaults }

    'Stop-NonEssentialProcesses' = { Stop-NonEssentialProcesses }
    'Stop-Browsers' = { Stop-ProcessGroup -GroupName 'Browsers' }
    'Stop-Cloud' = { Stop-ProcessGroup -GroupName 'Cloud' }
    'Stop-Communication' = { Stop-ProcessGroup -GroupName 'Communication' }
    'Stop-Launchers' = { Stop-ProcessGroup -GroupName 'Launchers' }
    'Stop-Overlays' = { Stop-ProcessGroup -GroupName 'Overlays' }
    'Stop-BugGServiceGroups' = { Stop-BugGServiceGroups }
    'Stop-CompetitiveProcesses' = { Stop-CompetitiveProcesses }
    'Stop-CompetitiveServices' = { Stop-CompetitiveServices }
    'Restore-CompetitiveServices' = { Restore-CompetitiveServices }
    'Finalize-CompetitiveMode' = { Finalize-CompetitiveMode }
    'Invoke-FocusMode' = { Invoke-FocusMode }
    'Show-ProcessGroups' = { Show-ProcessGroups }

    'Show-SystemStatus' = { Show-SystemStatus }
    'Show-DriverStatus' = { Show-DriverStatus }
    'Show-PowerPlan' = { Show-PowerPlan }
    'New-BugGReport' = { New-BugGReport }

    'Preset-Safe' = { Invoke-BugGPreset -Name 'safe' -ActionMap $actions }
    'Preset-Competitive' = { Invoke-BugGPreset -Name 'competitive' -ActionMap $actions }
    'Preset-Network' = { Invoke-BugGPreset -Name 'network' -ActionMap $actions }
    'Preset-Diagnostic' = { Invoke-BugGPreset -Name 'diagnostic' -ActionMap $actions }

    'Open-Settings' = { Start-Process notepad.exe -ArgumentList ('"{0}"' -f (Join-Path $root 'config\settings.json')) }
    'Open-ProcessesConfig' = { Start-Process notepad.exe -ArgumentList ('"{0}"' -f (Join-Path $root 'config\processes.json')) }
    'Open-Logs' = { Start-Process explorer.exe -ArgumentList ('"{0}"' -f (Join-Path $root 'logs')) }
    'Show-DetectedPaths' = {
        Write-BugGHeader 'Caminhos detectados' Cyan
        $current = Get-BugGContext
        Write-Host ("  Root:  {0}" -f $current.RootPath)
        Write-Host ("  Steam: {0}" -f $(if ($current.SteamPath) { $current.SteamPath } else { 'Nao localizada' }))
        Write-Host ("  PUBG:  {0}" -f $(if ($current.PubgPath) { $current.PubgPath } else { 'Nao localizado' }))
        Write-Host ("  Logs:  {0}" -f (Join-Path $current.RootPath 'logs'))
    }
    'Set-ConsoleFont' = { Set-BugGConsoleFontPreference }
}

if (-not $NoLogo) {
    Write-BugGHeader 'Inicializando' Cyan
    #Write-BugGStep 'Base modular carregada'
    Start-Sleep -Milliseconds 600
}

Invoke-BugGMenu -ActionMap $actions -ScriptPath $MyInvocation.MyCommand.Path
