Write-Host "⏪ RAPYARD OS :: rollback"

# Version rollback
Write-Host "📦 Rolling back version..."
$package = Get-Content "package.json" | ConvertFrom-Json
$version = $package.version.Split(".")
$version[2] = [math]::Max([int]$version[2] - 1, 0)
$package.version = $version -join "."
$package | ConvertTo-Json -Depth 10 | Set-Content "package.json"
Write-Host "🔢 Version rolled back."

# Cloudflare Workers rollback
Write-Host "⚙️ Rolling back Cloudflare Workers..."
npx wrangler deploy --rollback

# Cloudflare Pages rollback
Write-Host "⚙️ Rolling back Cloudflare Pages..."
npx wrangler pages deployments list
Write-Host "Select deployment manually to rollback."

Write-Host "🟢 Rollback complete."
