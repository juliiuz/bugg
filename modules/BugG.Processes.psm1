Set-StrictMode -Version 2.0

function Stop-ProcessGroup {
    param(
        [Parameter(Mandatory = $true)]
        [string]$GroupName
    )

    $ctx = Get-BugGContext
    $group = $ctx.Processes.groups | Where-Object { $_.name -eq $GroupName } | Select-Object -First 1
    if (-not $group) {
        Write-BugGError "Grupo nao encontrado: $GroupName"
        return
    }

    Write-BugGHeader ("Encerrar grupo: {0}" -f $group.name) DarkYellow
    foreach ($name in $group.processes) {
        Write-BugGStep ("Encerrando {0}" -f $name)
        Get-Process -Name $name -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }

    Write-BugGOk "Grupo $($group.name) processado."
}

function Stop-NonEssentialProcesses {
    Write-BugGHeader 'Encerrar processos desnecessarios' DarkYellow
    $ctx = Get-BugGContext

    foreach ($group in $ctx.Processes.groups) {
        Write-Host ''
        Write-Host ("  [{0}]" -f $group.name) -ForegroundColor Yellow
        foreach ($name in $group.processes) {
            Write-BugGStep ("Encerrando {0}" -f $name)
            Get-Process -Name $name -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        }
    }

    Write-BugGOk 'Processos processados.'
}

function Stop-BugGServiceGroups {
    Write-BugGHeader 'Parar servicos opcionais' DarkYellow
    if (-not (Assert-BugGAdmin 'Parar servicos requer administrador.')) {
        return
    }

    $ctx = Get-BugGContext
    foreach ($group in $ctx.Services.safeStopGroups) {
        Write-Host ''
        Write-Host ("  [{0}]" -f $group.name) -ForegroundColor Yellow
        foreach ($name in $group.services) {
            Write-BugGStep ("Parando {0}" -f $name)
            Stop-Service -Name $name -Force -ErrorAction SilentlyContinue
        }
    }

    Write-BugGOk 'Servicos processados.'
}

function Invoke-FocusMode {
    Write-BugGHeader 'Modo foco para PUBG' DarkYellow
    if (-not (Confirm-BugGAction 'Encerrar apps comuns e launchers extras?')) {
        return
    }

    Stop-NonEssentialProcesses
    Disable-GameDvr
    Clear-ShaderCache
    Flush-Dns
    Write-BugGOk 'Modo foco finalizado.'
}

function Show-ProcessGroups {
    Write-BugGHeader 'Grupos de processos' DarkYellow
    $ctx = Get-BugGContext

    foreach ($group in $ctx.Processes.groups) {
        Write-Host ''
        Write-Host ("  {0} - {1}" -f $group.name, $group.description) -ForegroundColor Yellow
        Write-Host ("  {0}" -f (($group.processes) -join ', ')) -ForegroundColor DarkGray
    }
}

function Test-BugGProcessPattern {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [object[]]$Patterns
    )

    foreach ($pattern in $Patterns) {
        if ($Name -like [string]$pattern) {
            return $true
        }
    }

    return $false
}

function Get-BugGProcessPathSafe {
    param(
        [Parameter(Mandatory = $true)]
        [System.Diagnostics.Process]$Process
    )

    try {
        return $Process.Path
    }
    catch {
        return $null
    }
}

function Stop-CompetitiveProcesses {
    Write-BugGHeader 'Competitive trim - processos' DarkYellow
    $ctx = Get-BugGContext
    $policy = $ctx.Processes.competitive

    if (-not $policy) {
        Write-BugGError 'Politica competitive nao encontrada em processes.json.'
        return
    }

    $protected = @($policy.protectedProcesses)
    $windowsKill = @($policy.windowsKillProcesses)
    $windowsRoot = [IO.Path]::GetFullPath($env:WINDIR).TrimEnd('\')
    $stopped = New-Object System.Collections.Generic.List[string]
    $skipped = New-Object System.Collections.Generic.List[string]

    foreach ($process in (Get-Process -ErrorAction SilentlyContinue | Sort-Object ProcessName, Id)) {
        $name = $process.ProcessName

        if ($process.Id -eq $PID) {
            $skipped.Add("$name[$($process.Id)] (Bug-G host)")
            continue
        }

        if (Test-BugGProcessPattern -Name $name -Patterns $protected) {
            continue
        }

        $path = Get-BugGProcessPathSafe -Process $process
        $isWindowsProcess = $false
        if ($path) {
            try {
                $fullPath = [IO.Path]::GetFullPath($path)
                $isWindowsProcess = $fullPath.StartsWith($windowsRoot, [StringComparison]::OrdinalIgnoreCase)
            }
            catch {
                $isWindowsProcess = $false
            }
        }

        $explicitWindowsKill = Test-BugGProcessPattern -Name $name -Patterns $windowsKill
        $shouldStop = $explicitWindowsKill -or ($path -and -not $isWindowsProcess)

        if (-not $shouldStop) {
            # Unknown/protected Windows host: do not force-kill it merely because it was not in the list.
            continue
        }

        try {
            Write-BugGStep ("Encerrando {0} (PID {1})" -f $name, $process.Id)
            Stop-Process -Id $process.Id -Force -ErrorAction Stop
            $stopped.Add("$name[$($process.Id)]")
        }
        catch {
            Write-BugGWarn ("Nao foi possivel encerrar {0} (PID {1}): {2}" -f $name, $process.Id, $_.Exception.Message)
        }
    }

    Write-BugGOk ("Competitive trim: {0} processo(s) encerrado(s)." -f $stopped.Count)
}

function Stop-CompetitiveServices {
    Write-BugGHeader 'Competitive trim - servicos' DarkYellow
    if (-not (Assert-BugGAdmin 'O preset competitivo precisa de administrador para parar servicos.')) {
        return
    }

    $ctx = Get-BugGContext
    $policy = $ctx.Services.competitive
    if (-not $policy) {
        Write-BugGError 'Politica competitive nao encontrada em services.json.'
        return
    }

    $protected = @($policy.protectedServices)
    $stateFile = Join-Path $ctx.RootPath 'logs\competitive-stopped-services.txt'
    $stopped = New-Object System.Collections.Generic.List[string]
    $previouslyStopped = @()

    if (Test-Path -LiteralPath $stateFile) {
        $previouslyStopped = @(Get-Content -LiteralPath $stateFile -ErrorAction SilentlyContinue | Where-Object { $_ })
    }

    foreach ($pattern in @($policy.stopServices)) {
        $matches = @(Get-Service -Name ([string]$pattern) -ErrorAction SilentlyContinue)
        foreach ($service in $matches) {
            if ($service.Status -ne 'Running') {
                continue
            }

            $isProtected = $false
            foreach ($protectedPattern in $protected) {
                if ($service.Name -like [string]$protectedPattern) {
                    $isProtected = $true
                    break
                }
            }

            if ($isProtected) {
                Write-BugGWarn ("Ignorando servico protegido: {0}" -f $service.Name)
                continue
            }

            try {
                Write-BugGStep ("Parando {0} - {1}" -f $service.Name, $service.DisplayName)
                Stop-Service -Name $service.Name -ErrorAction Stop
                $service.WaitForStatus('Stopped', [TimeSpan]::FromSeconds(4))
                $stopped.Add($service.Name)

                # Persist after each successful stop so a later interruption does not lose restore state.
                @($previouslyStopped + $stopped) |
                    Where-Object { $_ } |
                    Sort-Object -Unique |
                    Set-Content -LiteralPath $stateFile -Encoding UTF8
            }
            catch {
                Write-BugGWarn ("Nao foi possivel parar {0}: {1}" -f $service.Name, $_.Exception.Message)
            }
        }
    }

    if ($stopped.Count -gt 0 -or $previouslyStopped.Count -gt 0) {
        @($previouslyStopped + $stopped) |
            Where-Object { $_ } |
            Sort-Object -Unique |
            Set-Content -LiteralPath $stateFile -Encoding UTF8
    }

    Write-BugGOk ("Competitive trim: {0} servico(s) parado(s) nesta execucao." -f $stopped.Count)
    Write-Host '  Nenhum startup type foi alterado; reiniciar o Windows restaura o comportamento normal.' -ForegroundColor DarkGray
}

function Restore-CompetitiveServices {
    Write-BugGHeader 'Restaurar servicos do competitive trim' DarkYellow
    if (-not (Assert-BugGAdmin 'Restaurar servicos requer administrador.')) {
        return
    }

    $ctx = Get-BugGContext
    $stateFile = Join-Path $ctx.RootPath 'logs\competitive-stopped-services.txt'
    if (-not (Test-Path -LiteralPath $stateFile)) {
        Write-BugGWarn 'Nenhum estado de servicos do competitive trim foi encontrado.'
        return
    }

    $names = @(Get-Content -LiteralPath $stateFile -ErrorAction SilentlyContinue | Where-Object { $_ } | Sort-Object -Unique)
    $restored = 0
    $pending = New-Object System.Collections.Generic.List[string]

    foreach ($name in $names) {
        try {
            $service = Get-Service -Name $name -ErrorAction Stop
            if ($service.Status -ne 'Running') {
                Write-BugGStep ("Iniciando {0}" -f $name)
                Start-Service -Name $name -ErrorAction Stop
                $service.WaitForStatus('Running', [TimeSpan]::FromSeconds(4))
                $restored++
            }
        }
        catch {
            $pending.Add($name)
            Write-BugGWarn ("Nao foi possivel iniciar {0}: {1}" -f $name, $_.Exception.Message)
        }
    }

    if ($pending.Count -gt 0) {
        $pending | Sort-Object -Unique | Set-Content -LiteralPath $stateFile -Encoding UTF8
        Write-BugGWarn ("{0} servico(s) ainda pendente(s) de restauracao; o estado foi preservado." -f $pending.Count)
    }
    else {
        Remove-Item -LiteralPath $stateFile -Force -ErrorAction SilentlyContinue
    }

    Write-BugGOk ("{0} servico(s) restaurado(s)." -f $restored)
}

function Finalize-CompetitiveMode {
    Write-BugGHeader 'Finalizando preset competitivo' DarkYellow
    $deadline = (Get-Date).AddSeconds(60)
    $pubgDetected = $false

    # zksvc/BattlEye services can already be running before PUBG starts.
    # Wait for the actual game executable instead of any PUBG-related helper/service.
    while ((Get-Date) -lt $deadline) {
        if (Get-Process -Name 'TslGame' -ErrorAction SilentlyContinue) {
            $pubgDetected = $true
            break
        }

        Start-Sleep -Seconds 2
    }

    if ($pubgDetected) {
        Write-BugGStep 'TslGame detectado; aguardando estabilizacao do launch antes do trim final'
        Start-Sleep -Seconds 5
        Stop-CompetitiveProcesses
        Write-BugGOk 'Preset competitivo finalizado.'
    }
    else {
        Write-BugGWarn 'TslGame nao foi detectado em 60s; trim final cancelado para nao interferir no anti-cheat/launch.'
        Write-BugGOk 'Preset competitivo finalizado sem o segundo trim.'
    }
}

Export-ModuleMember -Function Stop-ProcessGroup, Stop-NonEssentialProcesses, Stop-BugGServiceGroups, Invoke-FocusMode, Show-ProcessGroups, Stop-CompetitiveProcesses, Stop-CompetitiveServices, Restore-CompetitiveServices, Finalize-CompetitiveMode
