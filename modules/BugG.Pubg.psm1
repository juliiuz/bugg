Set-StrictMode -Version 2.0

function Get-PubgInstallPath {
    $ctx = Get-BugGContext
    return $ctx.PubgPath
}

function Test-PubgInstalled {
    $path = Get-PubgInstallPath
    return ($path -and (Test-Path -LiteralPath $path))
}

function Invoke-PubgSteamStart {
    $ctx = Get-BugGContext
    Start-Process ("steam://rungameid/{0}" -f $ctx.Settings.steamAppId)
}

function Start-Pubg {
    Write-BugGHeader 'Abrir PUBG' Green
    Write-BugGStep 'Iniciando PUBG pela Steam'
    Invoke-PubgSteamStart
    Write-BugGOk 'O jogo deve iniciar em instantes.'
}

function Stop-Pubg {
    Write-BugGHeader 'Fechar PUBG' Green
    $ctx = Get-BugGContext

    foreach ($name in $ctx.Processes.pubg) {
        Write-BugGStep ("Encerrando {0}" -f $name)
        Get-Process -Name $name -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }

    Write-BugGOk 'PUBG encerrado.'
}

function Restart-Pubg {
    Stop-Pubg
    Start-Sleep -Seconds 2
    Start-Pubg
}

function Show-PubgProcesses {
    Write-BugGHeader 'Processos do PUBG' Green
    $ctx = Get-BugGContext

    foreach ($name in $ctx.Processes.pubg) {
        $running = Get-Process -Name $name -ErrorAction SilentlyContinue
        if ($running) {
            Write-Host ('  {0,-18} Rodando  PID: {1}' -f $name, (($running | Select-Object -ExpandProperty Id) -join ', ')) -ForegroundColor Green
        }
        else {
            Write-Host ('  {0,-18} Parado' -f $name) -ForegroundColor DarkGray
        }
    }
}

function Backup-PubgConfig {
    Write-BugGHeader 'Backup de configuracao PUBG' Yellow
    $ctx = Get-BugGContext
    $source = Join-Path $ctx.LocalAppData 'TslGame\Saved\Config\WindowsNoEditor\GameUserSettings.ini'
    $dest = Join-Path $ctx.DesktopPath $ctx.Settings.configBackupFile

    if (-not (Test-Path -LiteralPath $source)) {
        Write-BugGError "Config nao encontrada: $source"
        return
    }

    Copy-Item -LiteralPath $source -Destination $dest -Force
    Write-BugGOk "Backup salvo em: $dest"
}

function Open-PubgFolder {
    $path = Get-PubgInstallPath
    if ($path -and (Test-Path -LiteralPath $path)) {
        Start-Process explorer.exe -ArgumentList ('"{0}"' -f $path)
    }
    else {
        Write-BugGHeader 'Abrir pasta PUBG' Yellow
        Write-BugGError 'PUBG nao localizado.'
    }
}

Export-ModuleMember -Function Get-PubgInstallPath, Test-PubgInstalled, Start-Pubg, Stop-Pubg, Restart-Pubg, Show-PubgProcesses, Backup-PubgConfig, Open-PubgFolder
