Write-Host "=== RapYard Local Bootstrap ===" -ForegroundColor Cyan

# 1) Ensure Node is installed
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Node.js not found. Install Node 20+ and re-run." -ForegroundColor Red
    exit 1
}

# 2) Ensure pnpm is installed
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "pnpm not found. Installing..." -ForegroundColor Yellow
    npm install -g pnpm
}

# 3) Move to repo root
Set-Location "C:\dev\rapyard"

Write-Host "Cleaning node_modules and lockfiles..." -ForegroundColor Yellow
Get-ChildItem -Recurse -Directory -Filter "node_modules" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item pnpm-lock.yaml -Force -ErrorAction SilentlyContinue

# 4) Rebuild corrupted package.json files
Write-Host "Validating package.json files..." -ForegroundColor Yellow

$webPkg = "apps/web/package.json"
if (Test-Path $webPkg) {
    $json = Get-Content $webPkg -Raw
    try {
        $parsed = $json | ConvertFrom-Json
    } catch {
        Write-Host "apps/web/package.json is corrupted. Rebuilding..." -ForegroundColor Red

        @"
{
  "name": "@rapyard/web",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "three": "^0.164.0",
    "@react-three/fiber": "^8.15.12",
    "@react-three/drei": "^9.105.5",
    "zustand": "^4.5.2",
    "postprocessing": "^6.35.3",
    "leva": "^0.9.35",
    "clsx": "^2.1.1"
  },
  "devDependencies": {
    "typescript": "^5.4.0",
    "vite": "^5.4.0",
    "@vitejs/plugin-react": "^4.3.1",
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "@types/three": "^0.164.0"
  }
}
"@ | Set-Content $webPkg -Encoding UTF8
    }
}

# 5) Install workspace dependencies
Write-Host "Installing workspace dependencies..." -ForegroundColor Cyan
pnpm install

# 6) Run ry doctor (workspace drift)
Write-Host "Running ry doctor..." -ForegroundColor Cyan
pnpm run ry:doctor

# 7) Run deep drift fix
Write-Host "Running deep drift auto-fix..." -ForegroundColor Cyan
pnpm run ry:doctor:deep:fix

# 8) Build everything
Write-Host "Building RapYard..." -ForegroundColor Cyan
pnpm -w run build

# 9) Start the web app
Write-Host "Starting RapYard web app..." -ForegroundColor Green
Start-Process "http://localhost:5173"
pnpm --filter @rapyard/web dev
