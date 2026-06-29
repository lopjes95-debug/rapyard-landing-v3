Write-Host "🩺 RAPYARD OS :: doctor deep"

# Cloudflare Workers
Write-Host "`n⚙️ Checking Cloudflare Workers..."
try {
    npx wrangler whoami
    Write-Host "✅ Workers authenticated"
} catch {
    Write-Host "❌ Workers auth failed"
}

# Cloudflare DNS
Write-Host "`n🌐 Checking Cloudflare DNS..."
try {
    npx wrangler zones list
    Write-Host "✅ DNS zones reachable"
} catch {
    Write-Host "❌ DNS check failed"
}

# Cloudflare Pages
Write-Host "`n📄 Checking Cloudflare Pages..."
try {
    npx wrangler pages list
    Write-Host "✅ Pages reachable"
} catch {
    Write-Host "❌ Pages check failed"
}

# Supabase
Write-Host "`n🗄️ Checking Supabase..."
try {
    supabase status
    Write-Host "✅ Supabase reachable"
} catch {
    Write-Host "❌ Supabase check failed"
}

Write-Host "`n🟢 Deep doctor complete."
