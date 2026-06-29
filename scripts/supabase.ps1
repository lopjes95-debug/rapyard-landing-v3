Write-Host "Starting Supabase local environment..." -ForegroundColor Cyan

# Ensure Supabase CLI exists
if (-not (Get-Command supabase -ErrorAction SilentlyContinue)) {
    Write-Host "Supabase CLI not found. Install from: https://supabase.com/docs/guides/cli" -ForegroundColor Red
    exit 1
}

# Start Supabase local stack
Write-Host "Launching Supabase local stack..." -ForegroundColor Yellow
supabase start

# Apply migrations
Write-Host "Applying migrations..." -ForegroundColor Yellow
supabase db reset --force

# Generate types
Write-Host "Generating TypeScript types..." -ForegroundColor Yellow
supabase gen types typescript --local > api/schema/database.types.ts

# Sync RPC definitions
Write-Host "Syncing RPC definitions..." -ForegroundColor Yellow
supabase functions serve

Write-Host "Supabase local environment ready." -ForegroundColor Green
