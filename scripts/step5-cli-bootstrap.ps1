Write-Host "🔥 Bootstrapping Step 5 — RapYard CLI..."

function Write-File($path, $content) {
    $dir = Split-Path $path
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    Set-Content -Path $path -Value $content -Encoding UTF8
}

# Ensure CLI structure exists
New-Item -ItemType Directory -Force -Path "ry/src/commands" | Out-Null

# package.json
Write-File "ry/package.json" @'
{
  "name": "ry",
  "private": true,
  "bin": {
    "ry": "dist/index.js"
  },
  "scripts": {
    "build": "tsc -p tsconfig.json"
  },
  "devDependencies": {
    "typescript": "^5.6.0"
  }
}
'@

# tsconfig
Write-File "ry/tsconfig.json" @'
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "CommonJS",
    "outDir": "dist",
    "rootDir": "src",
    "esModuleInterop": true
  }
}
'@

# index.ts (CLI entrypoint)
Write-File "ry/src/index.ts" @'
#!/usr/bin/env node

import { dev } from "./commands/dev";
import { doctor } from "./commands/doctor";

const [, , cmd, arg] = process.argv;

switch (cmd) {
  case "dev":
    dev(arg);
    break;

  case "doctor":
    doctor();
    break;

  default:
    console.log(`
ry — RapYard CLI

Commands:
  ry dev web
  ry dev api
  ry dev worker
  ry dev mobile
  ry doctor
`);
}
'@

# dev command
Write-File "ry/src/commands/dev.ts" @'
import { execSync } from "child_process";

export function dev(target: string) {
  if (!target) {
    console.log("Usage: ry dev <web|api|worker|mobile>");
    return;
  }

  console.log("Starting dev for:", target);
  execSync(`pnpm dev:${target}`, { stdio: "inherit" });
}
'@

# doctor command
Write-File "ry/src/commands/doctor.ts" @'
import fs from "fs";

export function doctor() {
  console.log("🔍 RapYard Doctor — Checking monorepo health...");

  const required = [
    "apps/web",
    "apps/api",
    "apps/worker",
    "apps/mobile",
    "packages/ui",
    "packages/utils",
    "packages/schema",
    "packages/env",
    "packages/supabase",
    "ry"
  ];

  for (const path of required) {
    if (fs.existsSync(path)) {
      console.log("✔", path);
    } else {
      console.log("✖ MISSING:", path);
    }
  }

  console.log("Done.");
}
'@

Write-Host "✅ Step 5 complete — RapYard CLI generated!"
Write-Host "👉 Run 'pnpm --filter ry build' to compile the CLI"
Write-Host "👉 Then run 'node ry/dist/index.js' or add ry to PATH"
