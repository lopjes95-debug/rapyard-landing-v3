Write-Host "`n=== RapYard Verification ===" -ForegroundColor Cyan

Write-Host "[•] Checking Web health"
curl https://rapyard.club --silent --fail
if ($LASTEXITCODE -ne 0) { Write-Host "Web failed" -ForegroundColor Red; exit 1 }

Write-Host "[•] Checking API health"
curl https://api.rapyard.club/health --silent --fail
if ($LASTEXITCODE -ne 0) { Write-Host "API failed" -ForegroundColor Red; exit 1 }

Write-Host "[•] Checking Worker heartbeat"
curl https://worker.rapyard.club/heartbeat --silent --fail
if ($LASTEXITCODE -ne 0) { Write-Host "Worker failed" -ForegroundColor Red; exit 1 }

Write-Host "Verification OK." -ForegroundColor Green
