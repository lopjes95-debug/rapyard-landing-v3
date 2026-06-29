Write-Host ""
Write-Host "RAPYARD DOCTOR"
Write-Host ""

Write-Host "Node:"
node --version

Write-Host ""
Write-Host "pnpm:"
pnpm --version

Write-Host ""
Write-Host "Wrangler:"
wrangler --version

Write-Host ""
Write-Host "Cloudflare:"
wrangler whoami

Write-Host ""
Write-Host "Building..."

cd C:\dev\rapyard\apps\admin

pnpm run build