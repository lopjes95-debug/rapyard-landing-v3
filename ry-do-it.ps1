Write-Host "=== RAPYARD ONE-CLICK BOOTSTRAP + CI/CD ===" -ForegroundColor Cyan

# ---------- 1) Create core directories ----------

$dirs = @(
    "apps","apps/web","apps/admin",
    "edge","edge/api",
    "packages","packages/ui","packages/core","packages/config",
    "tools","tools/scripts",
    "brain","brain/docs",
    ".github",".github/workflows"
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        Write-Host "Creating: $dir" -ForegroundColor Green
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

# ---------- 2) Root files ----------

@'
{
  "name": "rapyard",
  "private": true,
  "scripts": {
    "dev:web": "pnpm --filter rapyard-web dev",
    "build:web": "pnpm --filter rapyard-web build",
    "dev:api": "pnpm --filter rapyard-api dev",
    "deploy:api": "pnpm --filter rapyard-api deploy"
  }
}
'@ | Set-Content package.json -Encoding UTF8

@'
packages:
  - "apps/*"
  - "edge/*"
  - "packages/*"
  - "tools/*"
'@ | Set-Content pnpm-workspace.yaml -Encoding UTF8

@'
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "Node",
    "strict": true,
    "jsx": "react-jsx",
    "esModuleInterop": true,
    "skipLibCheck": true
  }
}
'@ | Set-Content tsconfig.base.json -Encoding UTF8

@'
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "dev": { "cache": false }
  }
}
'@ | Set-Content turbo.json -Encoding UTF8

@'
# RapYard Monorepo

apps/   - Web apps (React Router, Admin)
edge/   - Cloudflare Workers (API)
packages/ - Shared UI + core logic
tools/  - Scripts (clean, reset, do-it)
brain/  - Docs, ADRs
.github/ - CI/CD pipelines
'@ | Set-Content README.md -Encoding UTF8

@'
CF_API_TOKEN=
CF_ACCOUNT_ID=
CF_PAGES_PROJECT=rapyard
'@ | Set-Content .env.example -Encoding UTF8

# ---------- 3) apps/web (React Router + Vite) ----------

@'
{
  "name": "rapyard-web",
  "version": "1.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "react-router-dom": "^6.22.0"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "typescript": "^5.3.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@vitejs/plugin-react": "^4.0.0"
  }
}
'@ | Set-Content apps/web/package.json -Encoding UTF8

New-Item -ItemType Directory -Path "apps/web/src" -Force | Out-Null
New-Item -ItemType Directory -Path "apps/web/public" -Force | Out-Null

@'
import { createRoot } from "react-dom/client";
import { RouterProvider } from "react-router-dom";
import { router } from "./router";

const root = document.getElementById("root")!;
createRoot(root).render(<RouterProvider router={router} />);
'@ | Set-Content apps/web/src/main.tsx -Encoding UTF8

@'
import { createBrowserRouter } from "react-router-dom";
import CinematicRoot from "./CinematicRoot";

export const router = createBrowserRouter([
  { path: "/", element: <CinematicRoot /> }
]);
'@ | Set-Content apps/web/src/router.tsx -Encoding UTF8

@'
export default function CinematicRoot() {
  return (
    <div style={{ padding: 40, fontFamily: "system-ui" }}>
      <h1>RapYard</h1>
      <p>Cinematic root is live.</p>
    </div>
  );
}
'@ | Set-Content apps/web/src/CinematicRoot.tsx -Encoding UTF8

@'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  build: { outDir: "dist" }
});
'@ | Set-Content apps/web/vite.config.ts -Encoding UTF8

@'
{
  "extends": "../../tsconfig.base.json",
  "include": ["src"]
}
'@ | Set-Content apps/web/tsconfig.json -Encoding UTF8

@'
/* SPA redirects */
# Always serve index.html for any path
/*   /index.html   200
'@ | Set-Content apps/web/public/_redirects -Encoding UTF8

# ---------- 4) edge/api (Cloudflare Worker, multi-env) ----------

@'
{
  "name": "rapyard-api",
  "version": "1.0.0",
  "scripts": {
    "dev": "wrangler dev src/index.ts",
    "deploy": "wrangler deploy"
  },
  "devDependencies": {
    "typescript": "^5.3.0",
    "wrangler": "^3.0.0"
  }
}
'@ | Set-Content edge/api/package.json -Encoding UTF8

New-Item -ItemType Directory -Path "edge/api/src" -Force | Out-Null

@'
export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname === "/api/tasks" && request.method === "GET") {
      return Response.json({
        success: true,
        tasks: []
      });
    }

    return new Response("Not found", { status: 404 });
  }
};
'@ | Set-Content edge/api/src/index.ts -Encoding UTF8

@'
name = "rapyard-api"
main = "src/index.ts"
compatibility_date = "2024-01-01"

[env.dev]
route = ""
[env.staging]
route = ""
[env.production]
route = ""
'@ | Set-Content edge/api/wrangler.toml -Encoding UTF8

@'
{
  "extends": "../../tsconfig.base.json",
  "include": ["src"]
}
'@ | Set-Content edge/api/tsconfig.json -Encoding UTF8

# ---------- 5) tools scripts ----------

@'
Write-Host "=== ry-clean (root only) ===" -ForegroundColor Cyan

$allowedDirs = @("apps","packages","modules","edge","tools","brain",".github")
$allowedFiles = @("package.json","pnpm-workspace.yaml","tsconfig.base.json","turbo.json","README.md",".gitignore",".env.example")

Get-ChildItem -Directory | ForEach-Object {
  if ($allowedDirs -notcontains $_.Name) {
    Write-Host "Deleting unexpected directory: $($_.Name)" -ForegroundColor Red
    Remove-Item -Recurse -Force $_.FullName
  }
}

Get-ChildItem -File | ForEach-Object {
  if ($allowedFiles -notcontains $_.Name) {
    Write-Host "Deleting unexpected file: $($_.Name)" -ForegroundColor Red
    Remove-Item -Force $_.FullName
  }
}
'@ | Set-Content tools/scripts/ry-clean.ps1 -Encoding UTF8

@'
Write-Host "=== ry-mkdir ===" -ForegroundColor Cyan

$dirs = @(
  "apps","apps/web","apps/admin",
  "edge","edge/api",
  "packages","packages/ui","packages/core","packages/config",
  "tools","tools/scripts",
  "brain","brain/docs",
  ".github",".github/workflows"
)

foreach ($dir in $dirs) {
  if (-not (Test-Path $dir)) {
    Write-Host "Creating: $dir" -ForegroundColor Green
    New-Item -ItemType Directory -Path $dir | Out-Null
  }
}
'@ | Set-Content tools/scripts/ry-mkdir.ps1 -Encoding UTF8

@'
Write-Host "=== ry-reset ===" -ForegroundColor Cyan
.\tools\scripts\ry-clean.ps1
.\tools\scripts\ry-mkdir.ps1
pnpm install
'@ | Set-Content tools/scripts/ry-reset.ps1 -Encoding UTF8

@'
Write-Host "=== deploy-all ===" -ForegroundColor Cyan
pnpm --filter rapyard-web build
pnpm --filter rapyard-api deploy
'@ | Set-Content tools/scripts/deploy-all.ps1 -Encoding UTF8

# ---------- 6) GitHub Actions CI/CD ----------

@'
name: Deploy Web (Pages)

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - run: pnpm install
      - run: pnpm --filter rapyard-web build
      - uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CF_API_TOKEN }}
          accountId: ${{ secrets.CF_ACCOUNT_ID }}
          projectName: rapyard
          directory: apps/web/dist
'@ | Set-Content .github/workflows/pages.yml -Encoding UTF8

@'
name: Deploy API (Workers)

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - run: pnpm install
      - run: pnpm --filter rapyard-api deploy
'@ | Set-Content .github/workflows/workers.yml -Encoding UTF8

# ---------- 7) Git init + first commit ----------

if (-not (Test-Path ".git")) {
  Write-Host "Initializing git..." -ForegroundColor Cyan
  git init
  git add .
  git commit -m "Initial RapYard bootstrap"
}

Write-Host "=== RAPYARD BOOTSTRAP + CI/CD COMPLETE ===" -ForegroundColor Green
Write-Host "Next:" -ForegroundColor Cyan
Write-Host "  1) pnpm install" -ForegroundColor Yellow
Write-Host "  2) pnpm --filter rapyard-web dev" -ForegroundColor Yellow
Write-Host "  3) pnpm --filter rapyard-api dev" -ForegroundColor Yellow
Write-Host "  4) Add CF_API_TOKEN + CF_ACCOUNT_ID secrets in GitHub" -ForegroundColor Yellow
Write-Host "  5) Push to GitHub → CI/CD auto-deploys" -ForegroundColor Yellow
