param(
    [switch]$All,
    [switch]$Web,
    [switch]$Mobile,
    [switch]$Api,
    [switch]$Worker
)

function Write-Section($msg) {
    Write-Host "`n=== $msg ===" -ForegroundColor Cyan
}

function Write-Step($msg) {
    Write-Host "[•] $msg" -ForegroundColor Yellow
}

function Fail($msg) {
    Write-Host "ERROR: $msg" -ForegroundColor Red
    exit 1
}

Write-Section "RapYard Deploy Pipeline"

Write-Step "Validating environment"
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { Fail "Node.js not installed" }
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) { Fail "pnpm not installed" }
if (-not (Get-Command supabase -ErrorAction SilentlyContinue)) { Fail "Supabase CLI not installed" }

Write-Section "Running monorepo doctor"
pnpm run doctor
if ($LASTEXITCODE -ne 0) { Fail "Doctor failed" }

Write-Section "Cleaning workspace"
pnpm run clean

Write-Section "Typechecking"
pnpm run typecheck
if ($LASTEXITCODE -ne 0) { Fail "Typecheck failed" }

Write-Section "Running tests"
pnpm test
if ($LASTEXITCODE -ne 0) { Fail "Tests failed" }

Write-Section "Applying Supabase migrations"
supabase db push
if ($LASTEXITCODE -ne 0) { Fail "Supabase migrations failed" }

if ($All -or $Web) {
    Write-Section "Building Web"
    pnpm --filter web build
}

if ($All -or $Mobile) {
    Write-Section "Building Mobile"
    pnpm --filter mobile build
}

if ($All -or $Api) {
    Write-Section "Bundling API"
    pnpm --filter api build
}

if ($All -or $Worker) {
    Write-Section "Bundling Worker"
    pnpm --filter worker build
}

if ($All -or $Web) {
    Write-Section "Deploying Web → Vercel"
    vercel deploy --prod
}

if ($All -or $Mobile) {
    Write-Section "Publishing Mobile → Expo"
    eas update --branch production --message "Automated deploy"
}

if ($All -or $Api) {
    Write-Section "Deploying API → Supabase"
    supabase functions deploy --project-ref $env:SUPABASE_PROJECT_ID
}

if ($All -or $Worker) {
    Write-Section "Deploying Worker"
    pnpm --filter worker deploy
}

Write-Section "Running post-deploy verification"
pnpm run verify
if ($LASTEXITCODE -ne 0) { Fail "Verification failed" }

Write-Host "`nDeployment complete." -ForegroundColor Green
