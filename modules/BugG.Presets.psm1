Set-StrictMode -Version 2.0

function Invoke-BugGPreset {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('safe', 'competitive', 'network', 'diagnostic')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [hashtable]$ActionMap
    )

    $ctx = Get-BugGContext
    $actions = $ctx.Settings.presets.$Name

    Write-BugGHeader ("Preset: {0}" -f $Name) White
    Write-Host '  Acoes:' -ForegroundColor DarkGray
    foreach ($action in $actions) {
        Write-Host ("  - {0}" -f $action) -ForegroundColor Gray
    }
    Write-Host ''

    if (-not (Confirm-BugGAction 'Executar este preset agora?')) {
        return
    }

    foreach ($action in $actions) {
        if ($ActionMap.ContainsKey($action)) {
            & $ActionMap[$action]
        }
        else {
            Write-BugGWarn "Acao nao mapeada no preset: $action"
        }
    }
}

Export-ModuleMember -Function Invoke-BugGPreset
