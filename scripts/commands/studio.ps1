Write-Host "🎛️ RAPYARD OS :: studio"
Write-Host "Starting web, mobile, workers, infra..."

Start-Process powershell -ArgumentList "npm run dev:web"
Start-Process powershell -ArgumentList "npm run dev:mobile"
Start-Process powershell -ArgumentList "npm run dev:workers"
Start-Process powershell -ArgumentList "npm run dev:infra"

Write-Host "🟢 Studio running."
