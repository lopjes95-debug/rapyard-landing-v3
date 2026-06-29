Write-Host "🔼 RAPYARD OS :: upgrade"

$versions = @("v6","v12","v20")
$plugins = "plugins"

foreach ($v in $versions) {
    $dir = Join-Path $plugins $v
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
        Set-Content -Path "$dir/README.md" -Value "# RAPYARD $v`n`nMigration notes."
        Write-Host "📁 Created $v"
    }
}

Write-Host "✅ Upgrade scaffolding complete."
