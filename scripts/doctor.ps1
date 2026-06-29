Write-Host "`n=== RapYard Doctor ===" -ForegroundColor Cyan

pnpm run doctor

if ($LASTEXITCODE -ne 0) {
    Write-Host "Doctor found issues." -ForegroundColor Red
    exit 1
}

Write-Host "Doctor OK." -ForegroundColor Green
