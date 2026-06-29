Write-Host "🧹 Cleaning RapYard repo..."

# Folders to archive
$legacy = @(
    "api",
    "backend",
    "workers",
    "shared",
    "cli",
    "supabase",
    "app",
    "cdk",
    "tools",
    "scripts",
    "branding",
    "tokens",
    "sequences"
)

# Create archive folder
if (!(Test-Path "archive")) {
    New-Item -ItemType Directory -Path "archive" | Out-Null
}

foreach ($folder in $legacy) {
    if (Test-Path $folder) {
        Write-Host "→ Archiving $folder"
        Move-Item -Path $folder -Destination "archive/$folder" -Force
    }
}

Write-Host ""
Write-Host "✅ Repo cleaned successfully!"
Write-Host "Remaining structure:"
Write-Host "  apps/"
Write-Host "  packages/"
Write-Host "  infra/"
Write-Host "  ry/"
Write-Host "  .github/"
Write-Host "  package.json"
Write-Host "  pnpm-workspace.yaml"
Write-Host "  turbo.json"
Write-Host "  tsconfig.json"
Write-Host ""
Write-Host "🧩 All legacy folders moved to /archive"
