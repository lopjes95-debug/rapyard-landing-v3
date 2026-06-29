Write-Host "`n=== Environment Check ===" -ForegroundColor Cyan

$required = @(
    "SUPABASE_URL",
    "SUPABASE_ANON_KEY",
    "SUPABASE_SERVICE_KEY",
    "SUPABASE_PROJECT_ID",
    "VERCEL_TOKEN",
    "EAS_TOKEN"
)

foreach ($var in $required) {
    if (-not $env:$var) {
        Write-Host "Missing: $var" -ForegroundColor Red
        $missing = $true
    }
}

if ($missing) {
    Write-Host "Environment incomplete." -ForegroundColor Red
    exit 1
}

Write-Host "Environment OK." -ForegroundColor Green
