Write-Host "📦 RAPYARD OS :: migrate"

Write-Host "⚙️ Running Prisma migration..."
npx prisma migrate dev

Write-Host "⚙️ Running Supabase migration..."
supabase db push

Write-Host "🟢 Hybrid migration complete."
