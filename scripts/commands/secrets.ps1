param([string]$Action, [string]$Key, [string]$Value)

Write-Host "🔐 RAPYARD OS :: secrets"

switch ($Action) {
    "set" {
        Write-Host "⚙️ Setting Cloudflare secret..."
        npx wrangler secret put $Key <<< $Value

        Write-Host "⚙️ Setting Supabase secret..."
        supabase secrets set $Key $Value

        Write-Host "🟢 Secret set."
    }

    "get" {
        Write-Host "⚠️ Cloudflare does not allow secret retrieval."
        Write-Host "⚠️ Supabase does not allow secret retrieval."
    }

    "list" {
        Write-Host "📄 Listing Supabase secrets..."
        supabase secrets list
    }

    default {
        Write-Host "Commands:"
        Write-Host "  ry secrets set <key> <value>"
        Write-Host "  ry secrets list"
    }
}
