Set-StrictMode -Version 2.0

function New-BugGMenuItem {
    param(
        [string]$Key,
        [string]$Title,
        [string]$Action,
        [string]$Menu,
        [switch]$RequiresAdmin
    )

    [pscustomobject]@{
        Key = $Key
        Title = $Title
        Action = $Action
        Menu = $Menu
        RequiresAdmin = [bool]$RequiresAdmin
    }
}

function Get-BugGMenus {
    $menus = @{}

    $menus.Main = @(
        New-BugGMenuItem '1' 'PUBG' -Menu 'Pubg'
        New-BugGMenuItem '2' 'Limpeza' -Menu 'Cleanup'
        New-BugGMenuItem '3' 'Rede' -Menu 'Network'
        New-BugGMenuItem '4' 'Performance Windows' -Menu 'Windows'
        New-BugGMenuItem '5' 'Processos e servicos' -Menu 'Processes'
        New-BugGMenuItem '6' 'Diagnostico' -Menu 'Diagnostics'
        New-BugGMenuItem '7' 'Presets' -Menu 'Presets'
        New-BugGMenuItem '8' 'Configuracoes' -Menu 'Settings'
    )

    $menus.Pubg = @(
        New-BugGMenuItem '11' 'Abrir PUBG' -Action 'Start-Pubg'
        New-BugGMenuItem '12' 'Fechar PUBG' -Action 'Stop-Pubg'
        New-BugGMenuItem '13' 'Reiniciar PUBG' -Action 'Restart-Pubg'
        New-BugGMenuItem '14' 'Ver processos do PUBG' -Action 'Show-PubgProcesses'
        New-BugGMenuItem '15' 'Backup de configuracao' -Action 'Backup-PubgConfig'
        New-BugGMenuItem '16' 'Abrir pasta do PUBG' -Action 'Open-PubgFolder'
    )

    $menus.Cleanup = @(
        New-BugGMenuItem '21' 'Limpar cache/temp do PUBG' -Action 'Clear-PubgTemp'
        New-BugGMenuItem '22' 'Limpar cache de shaders NVIDIA/DirectX' -Action 'Clear-ShaderCache'
        New-BugGMenuItem '23' 'Limpar temporarios do Windows' -Action 'Clear-WindowsTemp' -RequiresAdmin
        New-BugGMenuItem '24' 'Limpeza completa segura' -Action 'Clear-BugGFullSafe' -RequiresAdmin
        New-BugGMenuItem '25' 'Simular limpeza sem apagar' -Action 'Invoke-BugGCleanupSimulation'
    )

    $menus.Network = @(
        New-BugGMenuItem '31' 'Flush DNS' -Action 'Flush-Dns'
        New-BugGMenuItem '32' 'Registrar DNS' -Action 'Register-Dns'
        New-BugGMenuItem '33' 'Renovar IP' -Action 'Renew-Ip'
        New-BugGMenuItem '34' 'Reset Winsock' -Action 'Reset-Winsock' -RequiresAdmin
        New-BugGMenuItem '35' 'Corrigir rede completa' -Action 'Repair-BugGNetwork' -RequiresAdmin
        New-BugGMenuItem '36' 'Teste de ping/latencia' -Action 'Test-PubgNetwork'
        New-BugGMenuItem '37' 'Ver conexoes do PUBG' -Action 'Show-PubgConnections'
        New-BugGMenuItem '38' 'Uso de rede do PUBG' -Action 'Show-PubgNetworkUsage'
    )

    $menus.Windows = @(
        New-BugGMenuItem '41' 'Plano Ultimate Performance' -Action 'Set-UltimatePerformance' -RequiresAdmin
        New-BugGMenuItem '42' 'Desativar Game DVR / captura' -Action 'Disable-GameDvr'
        New-BugGMenuItem '43' 'Ativar Hardware GPU Scheduling' -Action 'Enable-HardwareGpuScheduling' -RequiresAdmin
        New-BugGMenuItem '44' 'Aplicar tweaks MMCSS para jogos' -Action 'Apply-MmcssGameTweaks' -RequiresAdmin
        New-BugGMenuItem '45' 'Efeitos visuais automaticos' -Action 'Set-VisualEffectsAuto'
        New-BugGMenuItem '46' 'Efeitos visuais performance' -Action 'Set-VisualEffectsPerformance'
        New-BugGMenuItem '47' 'Otimizar Windows para jogos' -Action 'Optimize-WindowsForGames' -RequiresAdmin
        New-BugGMenuItem '48' 'Restaurar defaults parciais' -Action 'Restore-WindowsGamingDefaults'
        New-BugGMenuItem '49' 'Desativar notificacoes Windows' -Action 'Disable-WindowsNotifications'
    )

    $menus.Processes = @(
        New-BugGMenuItem '51' 'Encerrar processos desnecessarios' -Action 'Stop-NonEssentialProcesses'
        New-BugGMenuItem '52' 'Encerrar Browsers' -Action 'Stop-Browsers'
        New-BugGMenuItem '53' 'Encerrar Cloud' -Action 'Stop-Cloud'
        New-BugGMenuItem '54' 'Encerrar Comunicadores' -Action 'Stop-Communication'
        New-BugGMenuItem '55' 'Encerrar Launchers extras' -Action 'Stop-Launchers'
        New-BugGMenuItem '56' 'Encerrar Overlays' -Action 'Stop-Overlays'
        New-BugGMenuItem '57' 'Parar servicos opcionais' -Action 'Stop-BugGServiceGroups' -RequiresAdmin
        New-BugGMenuItem '58' 'Modo foco antes do jogo' -Action 'Invoke-FocusMode'
        New-BugGMenuItem '59' 'Ver grupos editaveis' -Action 'Show-ProcessGroups'
    )

    $menus.Diagnostics = @(
        New-BugGMenuItem '61' 'Status do sistema' -Action 'Show-SystemStatus'
        New-BugGMenuItem '62' 'Drivers relevantes' -Action 'Show-DriverStatus'
        New-BugGMenuItem '63' 'Plano de energia atual' -Action 'Show-PowerPlan'
        New-BugGMenuItem '64' 'Processos do PUBG' -Action 'Show-PubgProcesses'
        New-BugGMenuItem '65' 'Conexoes do PUBG' -Action 'Show-PubgConnections'
        New-BugGMenuItem '66' 'Uso de rede do PUBG' -Action 'Show-PubgNetworkUsage'
        New-BugGMenuItem '67' 'Gerar relatorio Bug-G' -Action 'New-BugGReport'
    )

    $menus.Presets = @(
        New-BugGMenuItem '71' 'Preset seguro' -Action 'Preset-Safe'
        New-BugGMenuItem '72' 'Preset competitivo [AGRESSIVO]' -Action 'Preset-Competitive' -RequiresAdmin
        New-BugGMenuItem '73' 'Preset rede' -Action 'Preset-Network'
        New-BugGMenuItem '74' 'Preset diagnostico' -Action 'Preset-Diagnostic'
        New-BugGMenuItem '75' 'Restaurar servicos do competitivo' -Action 'Restore-CompetitiveServices' -RequiresAdmin
    )

    $menus.Settings = @(
        New-BugGMenuItem '81' 'Abrir settings.json' -Action 'Open-Settings'
        New-BugGMenuItem '82' 'Abrir processes.json' -Action 'Open-ProcessesConfig'
        New-BugGMenuItem '83' 'Abrir pasta de logs' -Action 'Open-Logs'
        New-BugGMenuItem '84' 'Mostrar caminhos detectados' -Action 'Show-DetectedPaths'
        New-BugGMenuItem '85' 'Aplicar fonte legivel no console' -Action 'Set-ConsoleFont'
    )

    return $menus
}

function Read-BugGMenuChoice {
    if ([Console]::IsInputRedirected) {
        $line = (Read-Host '  Sua opcao').Trim()
        if ($line.Length -gt 1) {
            return $line.Substring(0, 1)
        }

        return $line
    }

    while ($true) {
        $key = [Console]::ReadKey($true)
        if ($key.KeyChar -match '^[0-9+-]$') {
            Write-Host $key.KeyChar
            return [string]$key.KeyChar
        }
    }
}

function Invoke-BugGMenu {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$ActionMap,

        [string]$ScriptPath
    )

    $menus = Get-BugGMenus
    $current = 'Main'
    $page = 0
    $pageSize = 9
    $stack = New-Object System.Collections.Stack

    while ($true) {
        $ctx = Get-BugGContext
        $title = if ($current -eq 'Main') { 'Menu principal' } else { $current }
        $items = @($menus[$current])
        $totalPages = [Math]::Max(1, [Math]::Ceiling($items.Count / $pageSize))

        if ($page -ge $totalPages) {
            $page = $totalPages - 1
        }

        $start = $page * $pageSize
        $visibleItems = @($items | Select-Object -Skip $start -First $pageSize)

        Write-BugGHeader $title Cyan

        for ($index = 0; $index -lt $visibleItems.Count; $index++) {
            $item = $visibleItems[$index]
            $displayKey = $index + 1
            $adminTag = if ($item.RequiresAdmin) { ' [ADM]' } else { '' }
            Write-Host ('  [{0}] {1}{2}' -f $displayKey, $item.Title, $adminTag) -ForegroundColor White
        }

        Write-Host ''
        if ($totalPages -gt 1) {
            Write-Host ('  Pagina {0}/{1}    [+] Proxima    [-] Anterior' -f ($page + 1), $totalPages) -ForegroundColor DarkGray
        }
        elseif ($current -ne 'Main') {
            Write-Host '  [-] Voltar' -ForegroundColor DarkGray
        }

        Write-Host '  [0] Fechar' -ForegroundColor DarkGray
        Write-Host ''
        Write-Host '  Escolha com uma tecla...' -ForegroundColor DarkGray

        $choice = Read-BugGMenuChoice
        if (-not $choice) {
            continue
        }

        if ($choice -eq '0') {
            return
        }

        if ($choice -eq '+') {
            if ($page -lt ($totalPages - 1)) {
                $page++
            }

            continue
        }

        if ($choice -eq '-') {
            if ($page -gt 0) {
                $page--
            }
            elseif ($current -ne 'Main' -and $stack.Count -gt 0) {
                $state = $stack.Pop()
                $current = $state.Menu
                $page = $state.Page
            }

            continue
        }

        if ($choice -notmatch '^[1-9]$') {
            Write-BugGError 'Opcao invalida.'
            Start-Sleep -Milliseconds 800
            continue
        }

        $selectedIndex = [int]$choice - 1
        $selected = if ($selectedIndex -lt $visibleItems.Count) { $visibleItems[$selectedIndex] } else { $null }
        if (-not $selected) {
            Write-BugGError 'Opcao invalida.'
            Start-Sleep -Milliseconds 800
            continue
        }

        if ($selected.Menu) {
            $stack.Push([pscustomobject]@{ Menu = $current; Page = $page })
            $current = $selected.Menu
            $page = 0
            continue
        }

        if ($selected.RequiresAdmin -and -not $ctx.IsAdmin) {
            Write-BugGHeader 'Administrador necessario' Red
            Write-BugGWarn 'Esta acao precisa de privilegios de administrador.'
            Write-Host '  Feche com [0] e abra o launcher como administrador.' -ForegroundColor DarkGray
            Pause-BugG
            continue
        }

        if ($ActionMap.ContainsKey($selected.Action)) {
            & $ActionMap[$selected.Action]
            Pause-BugG
        }
        else {
            Write-BugGError "Acao nao mapeada: $($selected.Action)"
            Pause-BugG
        }
    }
}

Export-ModuleMember -Function Invoke-BugGMenu, Get-BugGMenus
