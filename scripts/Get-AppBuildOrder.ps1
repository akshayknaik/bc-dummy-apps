<#
.SYNOPSIS
    Reads every app.json in the repo and returns the apps in dependency (build) order.
.DESCRIPTION
    Topological sort on app.json "dependencies". Microsoft dependencies (not in the repo) are ignored.
    Throws on circular dependencies. Use -AsJson to feed a GitHub Actions matrix later.
.EXAMPLE
    ./scripts/Get-AppBuildOrder.ps1
    ./scripts/Get-AppBuildOrder.ps1 -AsJson
#>
[CmdletBinding()]
param(
    [string]$Root = (Split-Path -Path $PSScriptRoot -Parent),
    [switch]$AsJson
)

$ErrorActionPreference = 'Stop'

$apps = Get-ChildItem -Path $Root -Filter 'app.json' -Recurse -Depth 2 |
    Where-Object { $_.FullName -notmatch '[\\/]\.alpackages[\\/]' } |
    ForEach-Object {
        $j = Get-Content -Path $_.FullName -Raw | ConvertFrom-Json
        [pscustomobject]@{
            Id     = $j.id
            Name   = $j.name
            Folder = $_.Directory.Name
            IsTest = $_.Directory.Name -like '*.Test'
            Deps   = @($j.dependencies | ForEach-Object { $_.id })
        }
    }

$byId    = @{}
$apps | ForEach-Object { $byId[$_.Id] = $_ }
$state   = @{}
$order   = [System.Collections.Generic.List[object]]::new()

function Visit([object]$App) {
    switch ($state[$App.Id]) {
        'done'     { return }
        'visiting' { throw "Circular dependency detected at '$($App.Name)'" }
    }
    $state[$App.Id] = 'visiting'
    foreach ($d in $App.Deps) {
        if ($byId.ContainsKey($d)) { Visit $byId[$d] }
    }
    $state[$App.Id] = 'done'
    $order.Add($App)
}

$apps | Sort-Object Folder | ForEach-Object { Visit $_ }

$result = $order | Select-Object @{n='Order';e={ $order.IndexOf($_) + 1 }}, Name, Folder, IsTest

if ($AsJson) { $result | ConvertTo-Json -Compress } else { $result | Format-Table -AutoSize }
