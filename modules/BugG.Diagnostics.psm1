Set-StrictMode -Version 2.0

function Show-SystemStatus {
    Write-BugGHeader 'Status do sistema' Blue
    $ctx = Get-BugGContext
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $gpu = Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion
    $plan = powercfg /getactivescheme 2>$null

    Write-Host ("  Windows: {0} build {1}" -f $os.Caption, $os.BuildNumber)
    Write-Host ("  CPU:     {0}" -f $cpu.Name)
    Write-Host ("  RAM:     {0:N1} GB livre de {1:N1} GB" -f ($os.FreePhysicalMemory / 1MB), ($os.TotalVisibleMemorySize / 1MB))
    Write-Host ("  Energia: {0}" -f ($plan -join ' '))
    Write-Host ("  Steam:   {0}" -f $(if ($ctx.SteamPath) { $ctx.SteamPath } else { 'Nao localizada' }))
    Write-Host ("  PUBG:    {0}" -f $(if ($ctx.PubgPath) { $ctx.PubgPath } else { 'Nao localizado' }))
    Write-Host ''
    Write-Host '  GPU(s):'
    $gpu | Format-Table -AutoSize
}

function Show-DriverStatus {
    Write-BugGHeader 'Drivers relevantes' Blue
    Get-CimInstance Win32_PnPSignedDriver |
        Where-Object { $_.DeviceClass -in @('DISPLAY', 'NET') } |
        Select-Object DeviceClass, DeviceName, DriverVersion, DriverDate |
        Sort-Object DeviceClass, DeviceName |
        Format-Table -AutoSize
}

function Show-PowerPlan {
    Write-BugGHeader 'Plano de energia' Blue
    powercfg /list
}

function New-BugGReport {
    Write-BugGHeader 'Relatorio Bug-G' Blue
    $ctx = Get-BugGContext
    $reportPath = Join-Path $ctx.RootPath ('logs\BugG-Report-{0}.txt' -f (Get-Date -Format 'yyyy-MM-dd-HHmmss'))
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $gpu = Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion
    $plan = powercfg /getactivescheme 2>$null
    $pubgProcesses = foreach ($name in $ctx.Processes.pubg) {
        Get-Process -Name $name -ErrorAction SilentlyContinue
    }

    $lines = @()
    $lines += "Bug-G Tools report - $(Get-Date)"
    $lines += "Version: $($ctx.Settings.version)"
    $lines += "Admin: $($ctx.IsAdmin)"
    $lines += "Windows: $($os.Caption) build $($os.BuildNumber)"
    $lines += "CPU: $($cpu.Name)"
    $lines += ("RAM free/total GB: {0:N1}/{1:N1}" -f ($os.FreePhysicalMemory / 1MB), ($os.TotalVisibleMemorySize / 1MB))
    $lines += "Power: $($plan -join ' ')"
    $lines += "Steam: $($ctx.SteamPath)"
    $lines += "PUBG: $($ctx.PubgPath)"
    $lines += ''
    $lines += 'GPU:'
    $lines += ($gpu | Format-Table -AutoSize | Out-String)
    $lines += 'PUBG processes:'
    $lines += ($pubgProcesses | Select-Object ProcessName, Id, CPU, WorkingSet64 | Format-Table -AutoSize | Out-String)

    Set-Content -LiteralPath $reportPath -Value $lines -Encoding UTF8
    Write-BugGOk "Relatorio salvo em: $reportPath"
}

Export-ModuleMember -Function Show-SystemStatus, Show-DriverStatus, Show-PowerPlan, New-BugGReport
