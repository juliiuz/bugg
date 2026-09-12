Set-StrictMode -Version 2.0

function Clear-PubgTemp {
    Write-BugGHeader 'Limpeza PUBG' Red
    $ctx = Get-BugGContext
    $saved = Join-Path $ctx.LocalAppData 'TslGame\Saved'

    $folders = @(
        'Crashes',
        'CohCache',
        'Demos',
        'Dist',
        'Dists',
        'Logs'
    )

    foreach ($folder in $folders) {
        Remove-BugGItem -Path (Join-Path $saved $folder) -Recurse -Description $folder
    }

    if (Test-Path -LiteralPath $saved) {
        Get-ChildItem -LiteralPath $saved -Filter '*.ushaderprecache' -File -ErrorAction SilentlyContinue |
            ForEach-Object { Remove-BugGItem -Path $_.FullName -Description $_.Name }
    }

    Write-BugGOk 'Limpeza do PUBG finalizada.'
}

function Clear-ShaderCache {
    Write-BugGHeader 'Limpar cache de shaders' Red
    $ctx = Get-BugGContext
    $paths = @(
        (Join-Path $ctx.LocalAppData 'NVIDIA\DXCache'),
        (Join-Path $ctx.LocalAppData 'NVIDIA\GLCache'),
        (Join-Path $ctx.LocalAppData 'D3DSCache')
    )

    foreach ($path in $paths) {
        if (Test-Path -LiteralPath $path) {
            Get-ChildItem -LiteralPath $path -Force -ErrorAction SilentlyContinue |
                ForEach-Object { Remove-BugGItem -Path $_.FullName -Recurse -Description $_.Name }
        }
        else {
            Write-BugGWarn "Nao encontrado: $path"
        }
    }

    Write-BugGOk 'Cache de shaders limpo.'
}

function Clear-WindowsTemp {
    Write-BugGHeader 'Limpeza temporarios Windows' Red
    if (-not (Assert-BugGAdmin 'Limpar temporarios do Windows pode precisar de administrador.')) {
        return
    }

    $ctx = Get-BugGContext
    $paths = @(
        (Join-Path $ctx.LocalAppData 'Temp'),
        $ctx.TempPath,
        (Join-Path $env:SystemRoot 'Temp')
    ) | Select-Object -Unique

    foreach ($path in $paths) {
        if (Test-Path -LiteralPath $path) {
            Get-ChildItem -LiteralPath $path -Force -ErrorAction SilentlyContinue |
                ForEach-Object { Remove-BugGItem -Path $_.FullName -Recurse -Description $_.Name }
        }
    }

    Write-BugGOk 'Temporarios do Windows processados.'
}

function Clear-BugGFullSafe {
    Clear-PubgTemp
    Clear-ShaderCache
    Clear-WindowsTemp
}

function Invoke-BugGCleanupSimulation {
    Set-BugGWhatIf $true
    try {
        Clear-PubgTemp
        Clear-ShaderCache
        Clear-WindowsTemp
    }
    finally {
        Set-BugGWhatIf $false
    }
}

Export-ModuleMember -Function Clear-PubgTemp, Clear-ShaderCache, Clear-WindowsTemp, Clear-BugGFullSafe, Invoke-BugGCleanupSimulation
