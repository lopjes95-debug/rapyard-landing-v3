Write-Host "[ry bootstrap] Creating RapYard folder structure..." -ForegroundColor Cyan

$folders = @(
    "apps/web",
    "apps/mobile",
    "backend",
    "packages/core"
)

foreach ($f in $folders) {
    if (-not (Test-Path $f)) {
        New-Item -ItemType Directory -Path $f -Force | Out-Null
        Write-Host "[+] Created $f" -ForegroundColor Green
    }

    # src subfolder
    $srcPath = Join-Path $f "src"
    if (-not (Test-Path $srcPath)) {
        New-Item -ItemType Directory -Path $srcPath -Force | Out-Null
        Write-Host "[+] Created $srcPath" -ForegroundColor Green
    }

    # common subfolders for apps
    if ($f -like "apps/*") {
        foreach ($sub in @("components","pages","services")) {
            $subPath = Join-Path $srcPath $sub
            if (-not (Test-Path $subPath)) {
                New-Item -ItemType Directory -Path $subPath -Force | Out-Null
                Write-Host "[+] Created $subPath" -ForegroundColor Green
            }

            # starter boilerplate files
            switch ($sub) {
                "components" {
                    $compFile = Join-Path $subPath "GridLayer.tsx"
                    if (-not (Test-Path $compFile)) {
                        @"
import React from 'react';

export default function GridLayer() {
  return (
    <div style={{
      position: 'absolute',
      inset: 0,
      backgroundImage:
        'linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px)',
      backgroundSize: '40px 40px',
      transform: 'perspective(600px) rotateX(60deg)',
      transformOrigin: 'top',
      opacity: 0.25
    }} />
  );
}
"@ | Set-Content $compFile
                        Write-Host "[+] Created $compFile" -ForegroundColor Yellow
                    }
                }
                "pages" {
                    $pageFile = Join-Path $subPath "Home.tsx"
                    if (-not (Test-Path $pageFile)) {
                        @"
import React from 'react';

export default function Home() {
  return (
    <div>
      <h1>Welcome to RapYard</h1>
      <p>The forge is burning. Every legend starts as a spark.</p>
    </div>
  );
}
"@ | Set-Content $pageFile
                        Write-Host "[+] Created $pageFile" -ForegroundColor Yellow
                    }
                }
                "services" {
                    $svcFile = Join-Path $subPath "api.ts"
                    if (-not (Test-Path $svcFile)) {
                        @"
export async function login(email: string, password: string) {
  // TODO: wire to backend auth
  console.log('Login attempt', email);
  return { success: true };
}
"@ | Set-Content $svcFile
                        Write-Host "[+] Created $svcFile" -ForegroundColor Yellow
                    }
                }
            }
        }
    }

    # index.ts
    $indexFile = Join-Path $srcPath "index.ts"
    if (-not (Test-Path $indexFile)) {
        @"
export default function ${f.Replace('/','_')}() {
  console.log('Hello from $f');
}
"@ | Set-Content $indexFile
        Write-Host "[+] Created $indexFile" -ForegroundColor Yellow
    }

    # README.md
    $readmeFile = Join-Path $f "README.md"
    if (-not (Test-Path $readmeFile)) {
        @"
# ${f}
This module is part of the RapYard monorepo.
"@ | Set-Content $readmeFile
        Write-Host "[+] Created $readmeFile" -ForegroundColor Yellow
    }

    # tsconfig.json
    $tsconfigFile = Join-Path $f "tsconfig.json"
    if (-not (Test-Path $tsconfigFile)) {
        @"
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src/**/*"]
}
"@ | Set-Content $tsconfigFile
        Write-Host "[+] Created $tsconfigFile" -ForegroundColor Yellow
    }
}

Write-Host "[✓] RapYard bootstrap complete." -ForegroundColor Cyan