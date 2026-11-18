<#
.SYNOPSIS
    Compiles all Contoso apps (in dependency order) without a BC container.
.DESCRIPTION
    Uses BcContainerHelper Run-AlPipeline with a compiler folder:
      - downloads BC artifacts (cached under C:\bcartifacts.cache)
      - resolves build order from app.json dependencies
      - compiles apps + test apps with CodeCop/UICop
      - writes .app files to <OutputFolder>\Apps and \TestApps
    Same script runs in GitHub Actions and on a dev machine.
.EXAMPLE
    ./scripts/Invoke-CIBuild.ps1 -BcVersion 25 -BuildNumber 42
#>
[CmdletBinding()]
param(
    [string]$BaseFolder   = (Split-Path -Path $PSScriptRoot -Parent),
    [string]$BcVersion    = '25',
    [string]$Country      = 'w1',
    [int]$BuildNumber     = 0,
    [string]$OutputFolder = (Join-Path (Split-Path -Path $PSScriptRoot -Parent) 'output')
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Module -ListAvailable -Name BcContainerHelper)) {
    Install-Module BcContainerHelper -Force -AllowClobber -Scope CurrentUser
}
Import-Module BcContainerHelper -DisableNameChecking

$artifactUrl = Get-BCArtifactUrl -type Sandbox -country $Country -version $BcVersion -select Latest
if (-not $artifactUrl) { throw "No BC artifact found for version '$BcVersion' / country '$Country'." }
Write-Host "Using artifact: $artifactUrl"

$appDirs     = Get-ChildItem -Path $BaseFolder -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'app.json') }
$appFolders  = @($appDirs | Where-Object { $_.Name -notlike '*.Test' } | ForEach-Object Name)
$testFolders = @($appDirs | Where-Object { $_.Name -like '*.Test' }    | ForEach-Object Name)

Write-Host "App folders : $($appFolders -join ', ')"
Write-Host "Test folders: $($testFolders -join ', ')"

if (Test-Path $OutputFolder) { Remove-Item $OutputFolder -Recurse -Force }

$pipelineParams = @{
    pipelineName         = 'Contoso-CI'
    baseFolder           = $BaseFolder
    appFolders           = $appFolders
    testFolders          = $testFolders
    artifact             = $artifactUrl
    useCompilerFolder    = $true
    doNotPublishApps     = $true
    doNotRunTests        = $true
    installTestFramework = $true
    enableCodeCop        = $true
    enableUICop          = $true
    failOn               = 'error'
    appBuild             = $BuildNumber
    appRevision          = 0
    buildArtifactFolder  = $OutputFolder
}
if ($env:GITHUB_ACTIONS -eq 'true') { $pipelineParams.gitHubActions = $true }

Run-AlPipeline @pipelineParams

# Job summary for GitHub Actions
$apps = Get-ChildItem -Path $OutputFolder -Filter '*.app' -Recurse
if (-not $apps) { throw "Build produced no .app files." }

if ($env:GITHUB_STEP_SUMMARY) {
    $lines = @('## Built apps', '', '| File | Type | Size (KB) |', '|---|---|---|')
    foreach ($a in $apps) {
        $lines += "| $($a.Name) | $($a.Directory.Name) | $([math]::Round($a.Length / 1KB, 1)) |"
    }
    $lines += '', "Artifact: ``$artifactUrl``"
    $lines | Out-File -FilePath $env:GITHUB_STEP_SUMMARY -Append -Encoding utf8
}

$apps | Select-Object Name, @{n='Folder'; e={ $_.Directory.Name }} | Format-Table -AutoSize
