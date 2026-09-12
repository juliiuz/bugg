Set-StrictMode -Version 2.0

function Set-RegistryDWord {
    param(
        [string]$Path,
        [string]$Name,
        [int64]$Value
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    New-ItemProperty -LiteralPath $Path -Name $Name -PropertyType DWord -Value $Value -Force | Out-Null
}

function Set-RegistryString {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Value
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    New-ItemProperty -LiteralPath $Path -Name $Name -PropertyType String -Value $Value -Force | Out-Null
}

function Set-UltimatePerformance {
    Write-BugGHeader 'Plano maximo desempenho' Cyan
    if (-not (Assert-BugGAdmin 'Alterar plano de energia pode requerer administrador.')) {
        return
    }

    $templateGuid = 'e9a42b02-d5df-448d-aa00-03f14749eb61'
    $buggGuid = '7f9c9c3d-7f0c-4c4a-9b74-6ac047854e51'

    # /duplicatescheme creates a new GUID. Use a fixed Bug-G destination GUID so
    # repeated preset runs do not create unlimited duplicate power plans.
    $schemes = (& powercfg.exe /list 2>&1 | Out-String)
    if ($schemes -notmatch [regex]::Escape($buggGuid)) {
        Invoke-BugGCommand -FilePath 'powercfg.exe' -Arguments @('-duplicatescheme', $templateGuid, $buggGuid) -Description 'Criando plano Bug-G Ultimate Performance'
    }

    Invoke-BugGCommand -FilePath 'powercfg.exe' -Arguments @('-setactive', $buggGuid) -Description 'Ativando plano Bug-G Ultimate Performance'

    $active = (& powercfg.exe /getactivescheme 2>&1 | Out-String)
    if ($active -match [regex]::Escape($buggGuid)) {
        Write-BugGOk 'Plano de energia Bug-G Ultimate Performance ativo.'
    }
    else {
        Write-BugGWarn 'Nao foi possivel confirmar o plano Ultimate Performance como ativo.'
    }
}

function Disable-GameDvr {
    Write-BugGHeader 'Desativar Game DVR' Cyan
    Write-BugGStep 'Desativando captura em background do Xbox Game DVR'
    Set-RegistryDWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 0
    Set-RegistryDWord -Path 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -Value 0
    Remove-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Xbox Game Bar' -ErrorAction SilentlyContinue
    Write-BugGOk 'Game DVR desativado.'
}

function Disable-WindowsNotifications {
    Write-BugGHeader 'Desativar notificacoes Windows' Cyan
    Write-BugGStep 'Desativando notificacoes toast'
    Set-RegistryDWord -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'ToastEnabled' -Value 0

    Write-BugGStep 'Desativando notificacoes globais'
    Set-RegistryDWord -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name 'NOC_GLOBAL_SETTING_TOASTS_ENABLED' -Value 0

    Write-BugGStep 'Desativando sugestoes e dicas do Windows'
    Set-RegistryDWord -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338389Enabled' -Value 0
    Set-RegistryDWord -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353694Enabled' -Value 0
    Set-RegistryDWord -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353696Enabled' -Value 0

    Write-BugGOk 'Notificacoes desativadas. Pode ser necessario sair e entrar no Windows para aplicar tudo.'
}

function Enable-HardwareGpuScheduling {
    Write-BugGHeader 'Hardware GPU Scheduling' Cyan
    if (-not (Assert-BugGAdmin 'HAGS altera HKLM e requer administrador.')) {
        return
    }

    Write-BugGStep 'Ativando HAGS'
    Set-RegistryDWord -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' -Name 'HwSchMode' -Value 2
    Write-BugGOk 'HAGS ativado. Reinicie o PC para aplicar.'
}

function Apply-MmcssGameTweaks {
    Write-BugGHeader 'MMCSS jogos' Cyan
    if (-not (Assert-BugGAdmin 'Tweaks MMCSS alteram HKLM e requerem administrador.')) {
        return
    }

    Write-BugGStep 'Removendo Network Throttling'
    Set-RegistryDWord -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'NetworkThrottlingIndex' -Value 0xffffffff
    Set-RegistryDWord -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -Value 0

    $gamesPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games'
    Write-BugGStep 'Priorizando perfil Games'
    Set-RegistryDWord -Path $gamesPath -Name 'GPU Priority' -Value 8
    Set-RegistryDWord -Path $gamesPath -Name 'Priority' -Value 6
    Set-RegistryString -Path $gamesPath -Name 'Scheduling Category' -Value 'High'
    Write-BugGOk 'Tweaks MMCSS aplicados.'
}

function Set-VisualEffectsAuto {
    Write-BugGHeader 'Efeitos visuais automaticos' Cyan
    Set-RegistryDWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 0
    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -PropertyType Binary -Value ([byte[]](0x90,0x32,0x07,0x80,0x10,0x00,0x00,0x00)) -Force | Out-Null
    Write-BugGOk 'Perfil automatico aplicado.'
}

function Set-VisualEffectsPerformance {
    Write-BugGHeader 'Efeitos visuais performance' Cyan
    Set-RegistryDWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 2
    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -PropertyType Binary -Value ([byte[]](0x9E,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Force | Out-Null
    Write-BugGOk 'Perfil de performance aplicado. Reinicie para efeito completo.'
}

function Optimize-WindowsForGames {
    Write-BugGHeader 'Otimizar Windows para jogos' Cyan
    if (-not (Assert-BugGAdmin 'O pacote completo de otimizacao requer administrador.')) {
        return
    }

    Apply-MmcssGameTweaks
    Set-UltimatePerformance
    Disable-GameDvr
    Disable-WindowsNotifications
    Enable-HardwareGpuScheduling
    Clear-ShaderCache
    Flush-Dns
    Reset-Winsock
    Write-BugGOk 'Otimizacao aplicada. Reinicie o PC para efeito completo.'
}

function Restore-WindowsGamingDefaults {
    Write-BugGHeader 'Restaurar defaults Windows' Cyan
    if (-not (Confirm-BugGAction 'Restaurar alguns valores padrao de jogos do Windows?')) {
        return
    }

    Set-RegistryDWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 1
    Set-RegistryDWord -Path 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -Value 1
    Set-RegistryDWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 0
    Write-BugGOk 'Defaults parciais restaurados.'
}

Export-ModuleMember -Function Set-UltimatePerformance, Disable-GameDvr, Disable-WindowsNotifications, Enable-HardwareGpuScheduling, Apply-MmcssGameTweaks, Set-VisualEffectsAuto, Set-VisualEffectsPerformance, Optimize-WindowsForGames, Restore-WindowsGamingDefaults
