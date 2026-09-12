Set-StrictMode -Version 2.0

function Flush-Dns {
    Write-BugGHeader 'Flush DNS' Magenta
    Invoke-BugGCommand -FilePath 'ipconfig.exe' -Arguments @('/flushdns') -Description 'Limpando cache DNS' -IgnoreExitCode
    Write-BugGOk
}

function Register-Dns {
    Write-BugGHeader 'Registrar DNS' Magenta
    Invoke-BugGCommand -FilePath 'ipconfig.exe' -Arguments @('/registerdns') -Description 'Registrando DNS' -IgnoreExitCode
    Write-BugGOk
}

function Renew-Ip {
    Write-BugGHeader 'Renovar IP' Magenta
    Invoke-BugGCommand -FilePath 'ipconfig.exe' -Arguments @('/release') -Description 'Liberando IP' -IgnoreExitCode
    Invoke-BugGCommand -FilePath 'ipconfig.exe' -Arguments @('/renew') -Description 'Renovando IP' -IgnoreExitCode
    Write-BugGOk
}

function Reset-Winsock {
    Write-BugGHeader 'Reset Winsock' Magenta
    if (-not (Assert-BugGAdmin 'Reset Winsock requer administrador.')) {
        return
    }

    Invoke-BugGCommand -FilePath 'netsh.exe' -Arguments @('winsock', 'reset') -Description 'Resetando Winsock' -IgnoreExitCode
    Write-BugGOk 'Winsock resetado. Reiniciar o PC e recomendado.'
}

function Repair-BugGNetwork {
    Write-BugGHeader 'Corrigir rede' Magenta
    if (-not (Assert-BugGAdmin 'Correcoes completas de rede requerem administrador.')) {
        return
    }

    Invoke-BugGCommand -FilePath 'ipconfig.exe' -Arguments @('/flushdns') -Description 'Limpando cache DNS' -IgnoreExitCode
    Invoke-BugGCommand -FilePath 'ipconfig.exe' -Arguments @('/registerdns') -Description 'Registrando DNS' -IgnoreExitCode
    Invoke-BugGCommand -FilePath 'ipconfig.exe' -Arguments @('/release') -Description 'Liberando IP' -IgnoreExitCode
    Invoke-BugGCommand -FilePath 'ipconfig.exe' -Arguments @('/renew') -Description 'Renovando IP' -IgnoreExitCode
    Invoke-BugGCommand -FilePath 'netsh.exe' -Arguments @('winsock', 'reset') -Description 'Resetando Winsock' -IgnoreExitCode
    Write-BugGOk 'Rede processada. Reiniciar o PC pode ser necessario.'
}

function Test-PubgNetwork {
    Write-BugGHeader 'Teste de rede' Magenta
    $targets = @('8.8.8.8', '1.1.1.1', 'google.com')

    foreach ($target in $targets) {
        Write-BugGStep "Ping: $target"
        Test-Connection -ComputerName $target -Count 4 -ErrorAction SilentlyContinue |
            Select-Object Address, ResponseTime |
            Format-Table -AutoSize
    }
}

function Show-PubgConnections {
    param([switch]$NoHeader)

    if (-not $NoHeader) {
        Write-BugGHeader 'Conexoes PUBG' Magenta
    }

    $pubgNames = (Get-BugGContext).Processes.pubg
    $processes = foreach ($name in $pubgNames) {
        Get-Process -Name $name -ErrorAction SilentlyContinue
    }

    if (-not $processes) {
        Write-BugGWarn 'Nenhum processo do PUBG encontrado.'
        return
    }

    $ids = $processes | Select-Object -ExpandProperty Id
    Get-NetTCPConnection -OwningProcess $ids -ErrorAction SilentlyContinue |
        Where-Object { $_.LocalAddress -ne '0.0.0.0' -and $_.RemoteAddress -ne '0.0.0.0' } |
        Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess |
        Format-Table -AutoSize
}

function Get-BugGNetworkAdapterSnapshot {
    Get-NetAdapter -Physical -ErrorAction SilentlyContinue |
        Where-Object { $_.Status -eq 'Up' } |
        ForEach-Object {
            $stats = Get-NetAdapterStatistics -Name $_.Name -ErrorAction SilentlyContinue
            if ($stats) {
                [pscustomobject]@{
                    Name = $_.Name
                    ReceivedBytes = [int64]$stats.ReceivedBytes
                    SentBytes = [int64]$stats.SentBytes
                }
            }
        }
}

function Format-BugGBytes {
    param([int64]$Bytes)

    if ($Bytes -ge 1GB) {
        return ('{0:N2} GB' -f ($Bytes / 1GB))
    }

    if ($Bytes -ge 1MB) {
        return ('{0:N2} MB' -f ($Bytes / 1MB))
    }

    if ($Bytes -ge 1KB) {
        return ('{0:N2} KB' -f ($Bytes / 1KB))
    }

    return ('{0:N0} B' -f $Bytes)
}

function Show-PubgNetworkUsage {
    Write-BugGHeader 'Uso de rede PUBG' Magenta
    Write-Host '  O Windows nao fornece bytes por conexao via Get-NetTCPConnection.' -ForegroundColor DarkGray
    Write-Host '  Abaixo ficam as conexoes do PUBG e o trafego total das interfaces durante a amostra.' -ForegroundColor DarkGray
    Write-Host ''

    Show-PubgConnections -NoHeader
    Write-Host ''

    $sampleSeconds = 5
    $before = @(Get-BugGNetworkAdapterSnapshot)
    if (-not $before) {
        Write-BugGWarn 'Nenhuma interface de rede ativa foi encontrada.'
        return
    }

    Write-BugGStep ("Medindo trafego por {0} segundos" -f $sampleSeconds)
    Start-Sleep -Seconds $sampleSeconds

    $after = @(Get-BugGNetworkAdapterSnapshot)
    $rows = foreach ($start in $before) {
        $end = $after | Where-Object { $_.Name -eq $start.Name } | Select-Object -First 1
        if (-not $end) {
            continue
        }

        $received = [Math]::Max(0, $end.ReceivedBytes - $start.ReceivedBytes)
        $sent = [Math]::Max(0, $end.SentBytes - $start.SentBytes)

        [pscustomobject]@{
            Interface = $start.Name
            Recebido = Format-BugGBytes $received
            Enviado = Format-BugGBytes $sent
            'Recebido/s' = Format-BugGBytes ([int64]($received / $sampleSeconds))
            'Enviado/s' = Format-BugGBytes ([int64]($sent / $sampleSeconds))
        }
    }

    if ($rows) {
        $rows | Format-Table -AutoSize
    }
    else {
        Write-BugGWarn 'Nao foi possivel calcular o trafego das interfaces.'
    }
}

Export-ModuleMember -Function Flush-Dns, Register-Dns, Renew-Ip, Reset-Winsock, Repair-BugGNetwork, Test-PubgNetwork, Show-PubgConnections, Show-PubgNetworkUsage
