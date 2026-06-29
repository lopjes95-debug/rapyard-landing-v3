Write-Host "Starting RapYard Worker Cluster..." -ForegroundColor Cyan

# Ensure pnpm exists
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "pnpm not found. Run: corepack enable" -ForegroundColor Red
    exit 1
}

# Install dependencies if needed
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    pnpm install
}

Write-Host "Launching worker cluster..." -ForegroundColor Green

# Run all workers + schedulers in parallel
pnpm --filter ./workers run dev
