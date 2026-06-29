Write-Host "🚀 RAPYARD OS :: deploy"

# Deploy Cloudflare Workers
Write-Host "⚙️ Deploying Cloudflare Workers..."
npx wrangler deploy

# Deploy Cloudflare Pages
Write-Host "⚙️ Deploying Cloudflare Pages..."
npx wrangler pages deploy ./out

# Run Supabase migrations before deploy
Write-Host "⚙️ Applying Supabase migrations..."
supabase db push

Write-Host "🟢 Deployment complete."
