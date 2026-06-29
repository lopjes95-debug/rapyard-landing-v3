Write-Host "📜 RAPYARD OS :: logs"

Write-Host "`n⚙️ Cloudflare Workers logs..."
npx wrangler tail

Write-Host "`n📄 Cloudflare Pages logs..."
npx wrangler pages deployments list

Write-Host "`n🗄️ Supabase logs..."
supabase logs

Write-Host "`n🟢 Logs streaming complete."
