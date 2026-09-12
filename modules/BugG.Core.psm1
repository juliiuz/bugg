Set-StrictMode -Version 2.0

$script:BugGContext = $null

function Initialize-BugGContext {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RootPath
    )

    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8
    Set-BugGConsoleLayout

    $configPath = Join-Path $RootPath 'config\settings.json'
    $processPath = Join-Path $RootPath 'config\processes.json'
    $servicesPath = Join-Path $RootPath 'config\services.json'
    $logDir = Join-Path $RootPath 'logs'

    if (-not (Test-Path -LiteralPath $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }

    $settings = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $processConfig = Get-Content -LiteralPath $processPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $servicesConfig = Get-Content -LiteralPath $servicesPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $steamPath = Get-BugGSteamPath
    $pubgPath = $null

    if ($steamPath) {
        $pubgPath = Join-Path $steamPath $settings.pubgRelativePath
    }

    $script:BugGContext = [pscustomobject]@{
        RootPath = $RootPath
        Settings = $settings
        Processes = $processConfig
        Services = $servicesConfig
        SteamPath = $steamPath
        PubgPath = $pubgPath
        DesktopPath = [Environment]::GetFolderPath('Desktop')
        LocalAppData = $env:LOCALAPPDATA
        TempPath = $env:TEMP
        LogPath = Join-Path $logDir ("BugG-{0}.log" -f (Get-Date -Format 'yyyy-MM-dd'))
        IsAdmin = Test-BugGAdmin
        WhatIf = $false
    }

    Write-BugGLog ('--- Session started: {0} ---' -f (Get-Date -Format 'HH:mm:ss'))
    Write-BugGLog "Initialized $($settings.appName) $($settings.version)"
    return $script:BugGContext
}

function Get-BugGContext {
    if (-not $script:BugGContext) {
        throw 'Bug-G context was not initialized.'
    }

    return $script:BugGContext
}

function Get-BugGSteamPath {
    $registryPaths = @(
        'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam',
        'HKLM:\SOFTWARE\Valve\Steam',
        'HKCU:\SOFTWARE\Valve\Steam'
    )

    foreach ($path in $registryPaths) {
        try {
            $value = (Get-ItemProperty -LiteralPath $path -ErrorAction Stop).InstallPath
            if ($value -and (Test-Path -LiteralPath $value)) {
                return $value
            }
        }
        catch {
            continue
        }
    }

    return $null
}

function Test-BugGAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Restart-BugGElevated {
    param(
        [string]$ScriptPath
    )

    $args = @(
        '-NoProfile',
        '-ExecutionPolicy', 'Bypass',
        '-File', ('"{0}"' -f $ScriptPath)
    )

    Start-Process -FilePath 'powershell.exe' -ArgumentList ($args -join ' ') -Verb RunAs | Out-Null
}

function Write-BugGLog {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [ValidateSet('INFO', 'WARN', 'ERROR')]
        [string]$Level = 'INFO'
    )

    if (-not $script:BugGContext) {
        return
    }

    $line = '{0} [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Message
    Add-Content -LiteralPath $script:BugGContext.LogPath -Value $line -Encoding UTF8
}

function Write-BugGHeader {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [ConsoleColor]$Color = [ConsoleColor]::Cyan
    )

    Clear-Host
    $ctx = Get-BugGContext
    $adminText = if ($ctx.IsAdmin) { 'Admin: Sim' } else { 'Admin: Nao' }
    $pubgText = if ($ctx.PubgPath -and (Test-Path -LiteralPath $ctx.PubgPath)) { 'PUBG: OK' } else { 'PUBG: Nao localizado' }

    Write-Host ''
    Write-Host ('  {0} {1}' -f $ctx.Settings.appName, $ctx.Settings.version) -ForegroundColor Gray
    Write-Host ('  {0} | {1} | Log: {2}' -f $adminText, $pubgText, (Split-Path $ctx.LogPath -Leaf)) -ForegroundColor DarkGray
    Write-Host ''
    Write-Host ('  {0}' -f $Title) -ForegroundColor $Color
    Write-Host ('  {0}' -f ('-' * 80)) -ForegroundColor DarkGray
}

function Set-BugGConsoleLayout {
    try {
        $width = 112
        $height = 36
        $bufferHeight = 900

        if ([Console]::BufferWidth -lt $width -or [Console]::BufferHeight -lt $bufferHeight) {
            [Console]::SetBufferSize([Math]::Max([Console]::BufferWidth, $width), [Math]::Max([Console]::BufferHeight, $bufferHeight))
        }

        $maxWidth = [Console]::LargestWindowWidth
        $maxHeight = [Console]::LargestWindowHeight
        [Console]::SetWindowSize([Math]::Min($width, $maxWidth), [Math]::Min($height, $maxHeight))
    }
    catch {
        Write-BugGLog "Could not resize console: $($_.Exception.Message)" 'WARN'
    }
}

function Set-BugGConsoleFontPreference {
    Write-BugGHeader 'Fonte do console' Cyan
    Write-Host '  O Windows aplica esta preferencia normalmente na proxima janela do console.' -ForegroundColor DarkGray
    Write-Host '  Fonte: Consolas | Tamanho: 20px | Peso: normal' -ForegroundColor Gray
    Write-Host ''

    if (-not (Confirm-BugGAction 'Aplicar preferencia de fonte para o console classico?')) {
        return
    }

    $consoleKeys = @(
        'HKCU:\Console',
        'HKCU:\Console\%SystemRoot%_System32_cmd.exe',
        'HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe'
    )

    foreach ($key in $consoleKeys) {
        if (-not (Test-Path -LiteralPath $key)) {
            New-Item -Path $key -Force | Out-Null
        }

        New-ItemProperty -LiteralPath $key -Name 'FaceName' -PropertyType String -Value 'Consolas' -Force | Out-Null
        New-ItemProperty -LiteralPath $key -Name 'FontFamily' -PropertyType DWord -Value 54 -Force | Out-Null
        New-ItemProperty -LiteralPath $key -Name 'FontSize' -PropertyType DWord -Value 0x00140000 -Force | Out-Null
        New-ItemProperty -LiteralPath $key -Name 'FontWeight' -PropertyType DWord -Value 400 -Force | Out-Null
        New-ItemProperty -LiteralPath $key -Name 'ScreenBufferSize' -PropertyType DWord -Value 0x03840070 -Force | Out-Null
        New-ItemProperty -LiteralPath $key -Name 'WindowSize' -PropertyType DWord -Value 0x00240070 -Force | Out-Null
    }

    Write-BugGOk 'Preferencia aplicada. Feche e abra o Bug-G Tools v2.bat novamente.'
}

function Write-BugGStep {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [ConsoleColor]$Color = [ConsoleColor]::Gray
    )

    Write-Host ('  > {0}' -f $Message) -ForegroundColor $Color
    Write-BugGLog $Message
}

function Write-BugGOk {
    param([string]$Message = 'Operacao concluida.')
    Write-Host ''
    Write-Host ('  [OK] {0}' -f $Message) -ForegroundColor Green
    Write-BugGLog $Message
}

function Write-BugGWarn {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host ('  [!] {0}' -f $Message) -ForegroundColor Yellow
    Write-BugGLog $Message 'WARN'
}

function Write-BugGError {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host ('  [ERRO] {0}' -f $Message) -ForegroundColor Red
    Write-BugGLog $Message 'ERROR'
}

function Pause-BugG {
    param([string]$Message = 'Pressione Enter para voltar...')
    Write-Host ''
    Read-Host ('  {0}' -f $Message) | Out-Null
}

function Confirm-BugGAction {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $answer = Read-Host ('  {0} [s/N]' -f $Message)
    return ($answer -match '^(s|sim|y|yes)$')
}

function Assert-BugGAdmin {
    param([string]$Reason = 'Esta opcao requer administrador.')

    $ctx = Get-BugGContext
    if ($ctx.IsAdmin) {
        return $true
    }

    Write-BugGWarn $Reason
    Write-Host '  Abra pelo launcher e aceite a elevacao, ou execute como administrador.' -ForegroundColor DarkGray
    return $false
}

function Invoke-BugGCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [string[]]$Arguments = @(),

        [string]$Description = $FilePath,

        [switch]$IgnoreExitCode
    )

    $ctx = Get-BugGContext
    Write-BugGStep $Description

    if ($ctx.WhatIf) {
        Write-BugGWarn ("Simulacao: {0} {1}" -f $FilePath, ($Arguments -join ' '))
        return
    }

    $process = Start-Process -FilePath $FilePath -ArgumentList $Arguments -NoNewWindow -Wait -PassThru
    if ($process.ExitCode -ne 0 -and -not $IgnoreExitCode) {
        Write-BugGWarn ("Comando retornou codigo {0}: {1}" -f $process.ExitCode, $Description)
    }
}

function Remove-BugGItem {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [switch]$Recurse,

        [string]$Description
    )

    $ctx = Get-BugGContext
    $label = if ($Description) { $Description } else { $Path }
    Write-BugGStep ("Removendo {0}" -f $label)

    if ($ctx.WhatIf) {
        Write-BugGWarn ("Simulacao: remover {0}" -f $Path)
        return
    }

    if (-not (Test-Path -LiteralPath $Path)) {
        Write-BugGWarn ("Nao encontrado: {0}" -f $Path)
        return
    }

    try {
        Remove-Item -LiteralPath $Path -Force -ErrorAction Stop -Recurse:$Recurse
    }
    catch {
        Write-BugGWarn ("Falha ao remover {0}: {1}" -f $Path, $_.Exception.Message)
    }
}

function Set-BugGWhatIf {
    param([bool]$Enabled)
    (Get-BugGContext).WhatIf = $Enabled
}

Export-ModuleMember -Function *-BugG*, Initialize-BugGContext, Get-BugGContext, Test-BugGAdmin, Restart-BugGElevated
