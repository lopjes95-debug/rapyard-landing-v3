Write-Host "🔥 RAPYARD OS :: init"

$bootstrap = Join-Path $PSScriptRoot "..\bootstrap.ps1"

powershell -ExecutionPolicy Bypass -File $bootstrap

Write-Host "✅ Bootstrap complete."
