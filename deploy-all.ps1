# ============================================
# RapYard Deploy Engine v1
# ============================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "===================================="
Write-Host "      RAPYARD DEPLOY ENGINE"
Write-Host "===================================="
Write-Host ""

# Root

$ROOT = "C:\dev\rapyard"

# -------------------------
# ADMIN
# -------------------------

Write-Host "Building Admin..."

Set-Location "$ROOT\apps\admin"

pnpm install

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: pnpm install failed"
    exit 1
}

pnpm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Build failed"
    exit 1
}

Write-Host ""
Write-Host "Deploying Admin..."

wrangler pages deploy dist --project-name rapyard

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Deployment failed"
    exit 1
}

Write-Host ""
Write-Host "===================================="
Write-Host "      DEPLOY SUCCESSFUL"
Write-Host "===================================="
Write-Host ""

Write-Host "Production:"
Write-Host "https://rapyard-admin.pages.dev"
Write-Host ""