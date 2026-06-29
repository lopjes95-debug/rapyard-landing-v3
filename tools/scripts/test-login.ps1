# RapYard Worker Login Test Script
# Usage: powershell ./tools/scripts/test-login.ps1 -Email "test@rapyard.com" -Password "secret"

param(
    [string]$Email = "test@rapyard.com",
    [string]$Password = "secret"
)

Write-Host "[ry test] Sending login request to rapyard.club..." -ForegroundColor Cyan

try {
    $body = @{ email = $Email; password = $Password } | ConvertTo-Json
    $response = Invoke-RestMethod `
        -Uri "https://rapyard.club/login" `
        -Method POST `
        -ContentType "application/json" `
        -Body $body

    Write-Host "[✓] Response:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 3
}
catch {
    Write-Host "[✘] Error:" $_.Exception.Message -ForegroundColor Red
}
