Write-Host "🌎 RAPYARD OS :: cluster deploy"

$regions = @("iad", "sfo", "fra", "sin", "bom")

foreach ($r in $regions) {
    Write-Host "`n⚙️ Deploying to region: $r"
    npx wrangler deploy --env $r
}

Write-Host "`n📄 Deploying Cloudflare Pages globally..."
npx wrangler pages deploy ./out

Write-Host "`n🗄️ Deploying Supabase migrations..."
supabase db push

Write-Host "`n🟢 Multi-region cluster deploy complete."
