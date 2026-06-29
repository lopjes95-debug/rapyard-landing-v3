param(
    [string]$Command,
    [string]$Subcommand,
    [string]$Arg
)

switch ($Command) {
    "init"      { & "$PSScriptRoot/commands/init.ps1" }
    "doctor"    { & "$PSScriptRoot/commands/doctor.ps1" }
    "doctor-deep" { & "$PSScriptRoot/commands/doctor-deep.ps1" }
    "build"     { & "$PSScriptRoot/commands/build.ps1" }
    "upgrade"   { & "$PSScriptRoot/commands/upgrade.ps1" }
    "generate"  { & "$PSScriptRoot/commands/generate-module.ps1" -Name $Arg }
    "scaffold"  { & "$PSScriptRoot/commands/scaffold-api.ps1" -Name $Arg }
    "studio"    { & "$PSScriptRoot/commands/studio.ps1" }
    "deploy"    { & "$PSScriptRoot/commands/deploy.ps1" }
    "sync"      { & "$PSScriptRoot/commands/sync.ps1" }
    "migrate"   { & "$PSScriptRoot/commands/migrate.ps1" }
    "forge"     { & "$PSScriptRoot/commands/forge.ps1" }
    "rollback"  { & "$PSScriptRoot/commands/rollback.ps1" }
    "logs"      { & "$PSScriptRoot/commands/logs.ps1" }
    "secrets"   { & "$PSScriptRoot/commands/secrets.ps1" -Action $Subcommand -Key $Arg -Value $args[3] }
    "cluster"   { & "$PSScriptRoot/commands/cluster.ps1" }
    default {
        Write-Host "RAPYARD OS CLI"
        Write-Host "  rapyard init"
        Write-Host "  rapyard doctor"
        Write-Host "  rapyard doctor-deep"
        Write-Host "  rapyard build"
        Write-Host "  rapyard upgrade"
        Write-Host "  rapyard generate module <Name>"
        Write-Host "  rapyard scaffold api <Name>"
        Write-Host "  rapyard studio"
        Write-Host "  rapyard deploy"
        Write-Host "  rapyard sync"
        Write-Host "  rapyard migrate"
        Write-Host "  rapyard forge"
        Write-Host "  rapyard rollback"
        Write-Host "  rapyard logs"
        Write-Host "  rapyard secrets set <key> <value>"
        Write-Host "  rapyard cluster"
    }
}
