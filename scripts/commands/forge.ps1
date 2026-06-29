Write-Host "🔥 RAPYARD OS :: forge"

Write-Host "🏗️ Building project..."
npm run build

Write-Host "🚀 Deploying..."
& "$PSScriptRoot/deploy.ps1"

Write-Host "📈 Bumping version..."
$package = Get-Content "package.json" | ConvertFrom-Json
$version = $package.version.Split(".")
$version[2] = [int]$version[2] + 1
$package.version = $version -join "."
$package | ConvertTo-Json -Depth 10 | Set-Content "package.json"

Write-Host "🟢 Forge complete. Version updated."
