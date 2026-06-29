Write-Host "🔄 RAPYARD OS :: sync"

Write-Host "⚙️ Syncing Prisma schema with DB..."
npx prisma db pull

Write-Host "⚙️ Syncing Supabase storage buckets..."
supabase storage list

Write-Host "⚙️ Syncing environment config..."
Copy-Item ".env.example" ".env" -Force

Write-Host "🟢 Sync complete."
