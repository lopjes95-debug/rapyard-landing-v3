Write-Host "🌌 Bootstrapping RapYard Fusion Universe — CLEAN mode..."

function Write-File($path, $content) {
    $dir = Split-Path $path
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    Set-Content -Path $path -Value $content -Encoding UTF8
}

# ---------------------------
# ROOT STRUCTURE
# ---------------------------
$folders = @(
  "apps/web/app",
  "apps/web/public",
  "apps/api/src/routes",
  "apps/worker/src/jobs",
  "apps/mobile",
  "apps/governance/src",
  "apps/admin/src",
  "services/core/src/routes",
  "services/ledger/src/routes",
  "services/notifications/src/routes",
  "services/ingest/src/routes",
  "services/ai-scoring/src/routes",
  "packages/ui/src",
  "packages/utils/src",
  "packages/schema/src",
  "packages/env/src",
  "packages/supabase/src",
  "packages/queue/src",
  "packages/logging/src",
  "infra/terraform",
  "infra/vercel",
  "infra/dns",
  "infra/supabase",
  "infra/observability",
  "ry/src/commands",
  ".github/workflows"
)

foreach ($f in $folders) {
  New-Item -ItemType Directory -Force -Path $f | Out-Null
}

# ---------------------------
# ROOT FILES
# ---------------------------
Write-File "package.json" @'
{
  "name": "rapyard-universe",
  "private": true,
  "version": "0.1.0",
  "scripts": {
    "dev:web": "turbo run dev --filter=web",
    "dev:api": "turbo run dev --filter=api",
    "dev:worker": "turbo run dev --filter=worker",
    "dev:mobile": "turbo run dev --filter=mobile",
    "dev:governance": "turbo run dev --filter=governance",
    "dev:admin": "turbo run dev --filter=admin",
    "dev:all": "turbo run dev",
    "build": "turbo run build",
    "lint": "turbo run lint"
  },
  "devDependencies": {
    "turbo": "^2.0.0",
    "typescript": "^5.6.0"
  },
  "packageManager": "pnpm@9.0.0"
}
'@

Write-File "pnpm-workspace.yaml" @'
packages:
  - "apps/*"
  - "services/*"
  - "packages/*"
  - "ry"
'@

Write-File "turbo.json" @'
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": { "dependsOn": ["^build"], "outputs": ["dist/**"] },
    "dev": { "cache": false },
    "lint": {}
  }
}
'@

Write-File "tsconfig.json" @'
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "Node",
    "strict": true,
    "jsx": "react-jsx",
    "baseUrl": ".",
    "paths": {
      "@ui/*": ["packages/ui/src/*"],
      "@utils/*": ["packages/utils/src/*"],
      "@schema/*": ["packages/schema/src/*"],
      "@env": ["packages/env/src/index.ts"],
      "@supabase/*": ["packages/supabase/src/*"],
      "@queue/*": ["packages/queue/src/*"],
      "@logging/*": ["packages/logging/src/*"]
    }
  }
}
'@

# ---------------------------
# APPS / WEB (CINEMATIC)
# ---------------------------
Write-File "apps/web/package.json" @'
{
  "name": "web",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "15.0.0",
    "react": "18.3.1",
    "react-dom": "18.3.1"
  }
}
'@

Write-File "apps/web/app/layout.tsx" @'
export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
'@

Write-File "apps/web/app/page.tsx" @'
import "./cinematic.css";

export default function Page() {
  return (
    <main className="cinematic">
      <div className="fog"></div>
      <h1 className="title">RAPYARD</h1>
      <p className="subtitle">Where creators forge their sound.</p>
      <a href="/app" className="enter">Enter the Yard</a>
    </main>
  );
}
'@

Write-File "apps/web/app/cinematic.css" @'
.cinematic {
  height: 100vh;
  background: url("/cinematic-bg.jpg") center/cover no-repeat;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: white;
  text-shadow: 0 0 20px black;
  position: relative;
}
.title {
  font-size: 6rem;
  letter-spacing: 0.2em;
  font-weight: 900;
}
.subtitle {
  margin-top: 1rem;
  font-size: 1.5rem;
  opacity: 0.8;
}
.enter {
  margin-top: 3rem;
  padding: 1rem 2rem;
  background: #ff3b3b;
  color: black;
  font-weight: 700;
  border-radius: 4px;
  text-decoration: none;
}
.fog {
  position: absolute;
  inset: 0;
  background: url("/fog.png") center/cover repeat-x;
  opacity: 0.3;
  animation: fogMove 30s linear infinite;
}
@keyframes fogMove {
  from { background-position: 0 0; }
  to { background-position: 2000px 0; }
}
'@

Write-File "apps/web/public/7f3c1e8b2f4d4c0e9a8f123456789abc.txt" "7f3c1e8b2f4d4c0e9a8f123456789abc"

# ---------------------------
# APPS / API (ROUTED, SUPABASE)
# ---------------------------
Write-File "apps/api/package.json" @'
{
  "name": "api",
  "private": true,
  "scripts": {
    "dev": "tsx src/index.ts",
    "build": "tsc -p tsconfig.json"
  },
  "devDependencies": {
    "tsx": "^4.0.0"
  }
}
'@

Write-File "apps/api/src/http.ts" @'
export function json(res, status, data) {
  res.writeHead(status, { "Content-Type": "application/json" });
  res.end(JSON.stringify(data));
}
'@

Write-File "apps/api/src/routes/health.ts" @'
import { json } from "../http";

export function health(req, res) {
  return json(res, 200, { ok: true, service: "rapyard-api" });
}
'@

Write-File "apps/api/src/routes/users.ts" @'
import { supabaseAdmin } from "@supabase/admin";
import { json } from "../http";

export async function users(req, res) {
  const { data, error } = await supabaseAdmin
    .from("users")
    .select("id, handle, created_at")
    .limit(50);

  if (error) return json(res, 500, { error });

  return json(res, 200, data);
}
'@

Write-File "apps/api/src/routes/feed.ts" @'
import { supabase } from "@supabase/client";
import { json } from "../http";

export async function feed(req, res) {
  const { data, error } = await supabase
    .from("tracks")
    .select("id, title, artist, cover_url, created_at")
    .order("created_at", { ascending: false })
    .limit(50);

  if (error) return json(res, 500, { error });

  return json(res, 200, data);
}
'@

Write-File "apps/api/src/routes/sessions.ts" @'
import { supabaseAdmin } from "@supabase/admin";
import { json } from "../http";

export async function sessions(req, res) {
  const { data, error } = await supabaseAdmin
    .from("sessions")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(20);

  if (error) return json(res, 500, { error });

  return json(res, 200, data);
}
'@

Write-File "apps/api/src/routes/upload.ts" @'
import { json } from "../http";

export async function upload(req, res) {
  return json(res, 200, { ok: true, message: "Upload endpoint coming soon" });
}
'@

Write-File "apps/api/src/index.ts" @'
import http from "http";
import { health } from "./routes/health";
import { users } from "./routes/users";
import { sessions } from "./routes/sessions";
import { feed } from "./routes/feed";
import { upload } from "./routes/upload";

const server = http.createServer((req, res) => {
  const { url } = req;

  if (url === "/health") return health(req, res);
  if (url === "/users") return users(req, res);
  if (url === "/sessions") return sessions(req, res);
  if (url === "/feed") return feed(req, res);
  if (url === "/upload") return upload(req, res);

  res.writeHead(404);
  res.end("Not found");
});

server.listen(4000, () => console.log("API running on :4000"));
'@

# ---------------------------
# APPS / WORKER
# ---------------------------
Write-File "apps/worker/package.json" @'
{
  "name": "worker",
  "private": true,
  "scripts": {
    "dev": "tsx src/index.ts",
    "build": "tsc -p tsconfig.json"
  },
  "devDependencies": {
    "tsx": "^4.0.0"
  }
}
'@

Write-File "apps/worker/src/queue.ts" @'
export const queue = {
  jobs: [] as any[],
  add(job: any) {
    this.jobs.push(job);
  },
  async process() {
    while (this.jobs.length) {
      const job = this.jobs.shift();
      console.log("[worker] processing job:", job.type);
      await job.run();
    }
  }
};
'@

Write-File "apps/worker/src/cron.ts" @'
export function startCron() {
  setInterval(() => {
    console.log("[cron] heartbeat:", new Date().toISOString());
  }, 60000);
}
'@

Write-File "apps/worker/src/jobs/generate-waveform.ts" @'
export async function generateWaveform(trackId: string) {
  console.log("[job] generateWaveform for track:", trackId);
  return { ok: true };
}
'@

Write-File "apps/worker/src/jobs/rank-feed.ts" @'
export async function rankFeed() {
  console.log("[job] rankFeed running...");
  return { ok: true };
}
'@

Write-File "apps/worker/src/index.ts" @'
import { queue } from "./queue";
import { startCron } from "./cron";
import { generateWaveform } from "./jobs/generate-waveform";
import { rankFeed } from "./jobs/rank-feed";

console.log("Worker started.");
startCron();

setInterval(() => {
  queue.add({ type: "waveform", run: () => generateWaveform("track_123") });
  queue.add({ type: "rank", run: () => rankFeed() });
  queue.process();
}, 5000);
'@

# ---------------------------
# APPS / MOBILE (EXPO STUB)
# ---------------------------
Write-File "apps/mobile/package.json" @'
{
  "name": "mobile",
  "private": true,
  "main": "index.js",
  "scripts": {
    "dev": "expo start"
  },
  "dependencies": {
    "expo": "~52.0.0",
    "react": "18.3.1",
    "react-native": "0.76.0"
  }
}
'@

Write-File "apps/mobile/App.tsx" @'
import { Text, View } from "react-native";

export default function App() {
  return (
    <View style={{ flex: 1, backgroundColor: "#050505", justifyContent: "center", alignItems: "center" }}>
      <Text style={{ color: "#fff", fontSize: 24 }}>RapYard Mobile</Text>
    </View>
  );
}
'@

# ---------------------------
# APPS / GOVERNANCE + ADMIN (STUBS)
# ---------------------------
Write-File "apps/governance/package.json" @'
{
  "name": "governance",
  "private": true,
  "scripts": {
    "dev": "tsx src/index.tsx",
    "build": "tsc -p tsconfig.json"
  }
}
'@

Write-File "apps/governance/src/index.tsx" @'
console.log("Governance portal stub — wire to web UI later.");
'@

Write-File "apps/admin/package.json" @'
{
  "name": "admin",
  "private": true,
  "scripts": {
    "dev": "tsx src/index.tsx",
    "build": "tsc -p tsconfig.json"
  }
}
'@

Write-File "apps/admin/src/index.tsx" @'
console.log("Admin portal stub — wire to web UI later.");
'@

# ---------------------------
# SERVICES (FUSION LAYER STUBS)
# ---------------------------
$services = @("core","ledger","notifications","ingest","ai-scoring")

foreach ($svc in $services) {
  Write-File "services/$svc/package.json" @"
{
  `"name`": `"service-$svc`",
  `"private`": true,
  `"scripts`": {
    `"dev`": `"tsx src/app.ts`",
    `"build`": `"tsc -p tsconfig.json`"
  },
  `"devDependencies`": {
    `"tsx`": `"^4.0.0`"
  }
}
"@

  Write-File "services/$svc/src/app.ts" @"
import http from "http";

const server = http.createServer((_, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, service: "service-$svc" }));
});

server.listen(0, () => console.log("service-$svc listening"));
"@
}

# ---------------------------
# PACKAGES
# ---------------------------
Write-File "packages/ui/src/index.tsx" @'
import React from "react";

export const Button = (props: any) => (
  <button
    {...props}
    style={{
      padding: "0.6rem 1.2rem",
      background: "#ff3b3b",
      border: "none",
      borderRadius: 4,
      cursor: "pointer",
      fontWeight: 600
    }}
  />
);
'@

Write-File "packages/utils/src/index.ts" @'
export const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));
'@

Write-File "packages/schema/src/index.ts" @'
import { z } from "zod";

export const UserSchema = z.object({
  id: z.string(),
  handle: z.string(),
  createdAt: z.string()
});
'@

Write-File "packages/env/src/index.ts" @'
export const env = {
  NODE_ENV: process.env.NODE_ENV ?? "development",
  SUPABASE_URL: process.env.SUPABASE_URL!,
  SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY!,
  SUPABASE_SERVICE_ROLE: process.env.SUPABASE_SERVICE_ROLE!
};
'@

Write-File "packages/supabase/src/client.ts" @'
import { createClient } from "@supabase/supabase-js";
import { env } from "@env";

export const supabase = createClient(
  env.SUPABASE_URL,
  env.SUPABASE_ANON_KEY
);
'@

Write-File "packages/supabase/src/admin.ts" @'
import { createClient } from "@supabase/supabase-js";
import { env } from "@env";

export const supabaseAdmin = createClient(
  env.SUPABASE_URL,
  env.SUPABASE_SERVICE_ROLE
);
'@

Write-File "packages/queue/src/index.ts" @'
export * from "@queue/.."; // placeholder, extend later
'@

Write-File "packages/logging/src/index.ts" @'
export function log(...args: any[]) {
  console.log("[rapyard]", ...args);
}
'@

# ---------------------------
# CLI (ry)
# ---------------------------
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
  ry dev governance
  ry dev admin
  ry doctor
`);
}
'@

Write-File "ry/src/commands/dev.ts" @'
import { execSync } from "child_process";

export function dev(target: string) {
  if (!target) {
    console.log("Usage: ry dev <web|api|worker|mobile|governance|admin>");
    return;
  }

  console.log("Starting dev for:", target);
  execSync(`pnpm dev:${target}`, { stdio: "inherit" });
}
'@

Write-File "ry/src/commands/doctor.ts" @'
import fs from "fs";

export function doctor() {
  console.log("🔍 RapYard Doctor — Checking Fusion Universe...");

  const required = [
    "apps/web",
    "apps/api",
    "apps/worker",
    "apps/mobile",
    "apps/governance",
    "apps/admin",
    "services/core",
    "services/ledger",
    "services/notifications",
    "services/ingest",
    "services/ai-scoring",
    "packages/ui",
    "packages/utils",
    "packages/schema",
    "packages/env",
    "packages/supabase",
    "packages/queue",
    "packages/logging",
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

# ---------------------------
# GIT INIT
# ---------------------------
if (!(Test-Path ".git")) {
  git init | Out-Null
}
git add .
git commit -m "Initial RapYard Fusion Universe (clean)" | Out-Null

Write-Host ""
Write-Host "✅ RapYard Fusion Universe (CLEAN) bootstrapped."
Write-Host "👉 Next:"
Write-Host "   pnpm install"
Write-Host "   pnpm --filter ry build"
Write-Host "   node ry/dist/index.js"
