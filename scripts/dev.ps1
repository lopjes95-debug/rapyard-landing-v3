Write-Host "Starting RapYard development environment..." -ForegroundColor Cyan

# Ensure pnpm exists
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "pnpm not found. Run: corepack enable" -ForegroundColor Red
    exit 1
}

# Install dependencies if node_modules missing
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    pnpm install
}

Write-Host "Launching Turbo dev pipeline..." -ForegroundColor Green

# Run all dev servers in parallel
pnpm dev
