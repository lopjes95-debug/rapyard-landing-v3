# ============================
# VERCEL ONE-CLICK (MISSING ONLY)
# ============================

$VERCEL_TOKEN = "<YOUR_VERCEL_TOKEN>"
$TEAM_ID      = "<YOUR_TEAM_ID>"   # or "" for personal
$SUPABASE_URL = "<YOUR_SUPABASE_URL>"
$SUPABASE_ANON = "<YOUR_SUPABASE_ANON_KEY>"
$SUPABASE_SERVICE = "<YOUR_SUPABASE_SERVICE_ROLE>"

$headers = @{
  "Authorization" = "Bearer $VERCEL_TOKEN"
  "Content-Type"  = "application/json"
}

# ----------------------------
# HELPERS
# ----------------------------

function Get-VercelProjects {
  $uri = "https://api.vercel.com/v9/projects?teamId=$TEAM_ID"
  $res = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
  return $res.projects
}

function Project-Exists {
  param([string]$name, [array]$existing)
  return $existing.name -contains $name
}

function New-VercelProject {
  param(
    [string]$name,
    [string]$rootDir
  )

  Write-Host "→ Creating project $name (root: $rootDir)..."

  $body = @{
    name   = $name
    framework = "other"
    rootDirectory = $rootDir
    teamId = $TEAM_ID
  } | ConvertTo-Json -Depth 5

  $res = Invoke-RestMethod -Method Post -Uri "https://api.vercel.com/v10/projects" -Headers $headers -Body $body
  return $res.id
}

function Set-VercelEnv {
  param(
    [string]$projectId,
    [string]$key,
    [string]$value
  )

  $body = @{
    key    = $key
    value  = $value
    target = @("production","preview","development")
    type   = "encrypted"
  } | ConvertTo-Json -Depth 5

  Invoke-RestMethod -Method Post -Uri "https://api.vercel.com/v9/projects/$projectId/env" -Headers $headers -Body $body | Out-Null
}

function Add-VercelDomain {
  param(
    [string]$projectId,
    [string]$domain
  )

  Write-Host "   ↳ Attaching domain $domain"

  $body = @{ name = $domain } | ConvertTo-Json
  Invoke-RestMethod -Method Post -Uri "https://api.vercel.com/v10/projects/$projectId/domains" -Headers $headers -Body $body | Out-Null
}

# ----------------------------
# PROJECT DEFINITIONS
# ----------------------------

$projects = @(
  @{ name = "rapyard-web";         root = "apps/web";         domains = @("rapyard.club","www.rapyard.club") },
  @{ name = "rapyard-api";         root = "apps/api";         domains = @("api.rapyard.club") },
  @{ name = "rapyard-worker";      root = "apps/worker";      domains = @("worker.rapyard.club") },
  @{ name = "rapyard-governance";  root = "apps/governance";  domains = @("governance.rapyard.club") },
  @{ name = "rapyard-admin";       root = "apps/admin";       domains = @("admin.rapyard.club") },
  @{ name = "rapyard-core";        root = "services/core";          domains = @("core.rapyard.club") },
  @{ name = "rapyard-ledger";      root = "services/ledger";        domains = @("ledger.rapyard.club") },
  @{ name = "rapyard-notifications"; root = "services/notifications"; domains = @("notify.rapyard.club") },
  @{ name = "rapyard-ingest";      root = "services/ingest";        domains = @("ingest.rapyard.club") },
  @{ name = "rapyard-ai";          root = "services/ai-scoring";    domains = @("ai.rapyard.club") }
)

# ----------------------------
# MAIN EXECUTION
# ----------------------------

Write-Host "🔍 Fetching existing Vercel projects..."
$existing = Get-VercelProjects

foreach ($p in $projects) {
  if (Project-Exists -name $p.name -existing $existing) {
    Write-Host "✔ Project already exists: $($p.name) — skipping"
    continue
  }

  Write-Host ""
  Write-Host "🚀 Creating missing project: $($p.name)"

  $id = New-VercelProject -name $p.name -rootDir $p.root
  Write-Host "   Project ID: $id"

  # Shared envs
  Set-VercelEnv -projectId $id -key "SUPABASE_URL"          -value $SUPABASE_URL
  Set-VercelEnv -projectId $id -key "SUPABASE_ANON_KEY"     -value $SUPABASE_ANON
  Set-VercelEnv -projectId $id -key "SUPABASE_SERVICE_ROLE" -value $SUPABASE_SERVICE
  Set-VercelEnv -projectId $id -key "NODE_ENV"              -value "production"
  Set-VercelEnv -projectId $id -key "SERVICE_NAME"          -value $p.name

  # Domains
  foreach ($d in $p.domains) {
    Add-VercelDomain -projectId $id -domain $d
  }

  Write-Host "   ✔ Done"
}

Write-Host ""
Write-Host "✅ Vercel One-Click (Missing Only) complete."
Write-Host "Check your Vercel dashboard — all missing projects are now created."

