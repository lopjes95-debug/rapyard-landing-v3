Write-Host "Installing RapYard dependencies..." -ForegroundColor Cyan

# Ensure pnpm exists
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "pnpm not found. Install with: corepack enable" -ForegroundColor Red
    exit 1
}

# Install root deps
pnpm install

# Install app-specific deps
pnpm --filter ./apps/mobile add expo react-native
pnpm --filter ./apps/web add next react react-dom
pnpm --filter ./apps/admin add next react react-dom

# Shared packages
pnpm --filter ./packages/ui add react-native react
pnpm --filter ./packages/brand add none
pnpm --filter ./packages/config add zod dotenv
pnpm --filter ./packages/utils add none

# Workers
pnpm --filter ./workers add bullmq ioredis

Write-Host "Install complete." -ForegroundColor Green
