Write-Host "🩺 RAPYARD OS :: doctor"

$required = @(
    "app",
    "components",
    "types/modules/core.ts",
    "prisma/schema.prisma",
    "lib/supabase/client.ts",
    "scripts/bootstrap.ps1"
)

$healthy = $true

foreach ($item in $required) {
    if (Test-Path $item) {
        Write-Host "✅ $item"
    } else {
        Write-Host "❌ Missing: $item"
        $healthy = $false
    }
}

if ($healthy) {
    Write-Host "🟢 System healthy."
} else {
    Write-Host "🔴 Issues detected."
}
