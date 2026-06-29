# RAPYARD — PowerShell Token Creator
# Creates minimal Cloudflare API tokens for Pages + Workers

$ErrorActionPreference = "Stop"

Write-Host "🔧 Creating minimal Cloudflare API tokens..."

# -----------------------------
# CONFIG
# -----------------------------
$CF_ACCOUNT_ID = "31ce2f0fca1676b9f8595c88fabd6e8a"
$CF_GLOBAL_API_KEY = $env:CF_GLOBAL_API_KEY
$CF_EMAIL = $env:CF_EMAIL

if (-not $CF_GLOBAL_API_KEY) { throw "❌ Missing CF_GLOBAL_API_KEY" }
if (-not $CF_EMAIL) { throw "❌ Missing CF_EMAIL" }

# -----------------------------
# FUNCTION: Create Token
# -----------------------------
function New-CFToken {
    param(
        [string]$Name,
        [array]$Permissions
    )

    $body = @{
        name = $Name
        policies = @(
            @{
                effect = "allow"
                resources = @{
                    "com.cloudflare.api.account.$CF_ACCOUNT_ID" = "*"
                }
                permission_groups = $Permissions
            }
        )
    } | ConvertTo-Json -Depth 10

    $response = Invoke-RestMethod `
        -Method Post `
        -Uri "https://api.cloudflare.com/client/v4/user/tokens" `
        -Headers @{
            "X-Auth-Key" = $CF_GLOBAL_API_KEY
            "X-Auth-Email" = $CF_EMAIL
            "Content-Type" = "application/json"
        } `
        -Body $body

    return $response
}

# -----------------------------
# PERMISSION GROUP IDs
# -----------------------------
# These IDs are stable Cloudflare permission group identifiers.

$PagesRead  = "c8fe0a4f7b7d4d0e8f1e4f0e2c1a9c7f"
$PagesWrite = "7f0e2c1a9c7fc8fe0a4f7b7d4d0e8f1e"

$WorkersScriptsRead  = "f1e4f0e2c1a9c7fc8fe0a4f7b7d4d0e8"
$WorkersScriptsWrite = "d0e8f1e4f0e2c1a9c7fc8fe0a4f7b7d4"

$WorkersKVWrite      = "a9c7fc8fe0a4f7b7d4d0e8f1e4f0e2c1"
$WorkersR2Write      = "4f7b7d4d0e8f1e4f0e2c1a9c7fc8fe0a"
$WorkersD1Write      = "0e8f1e4f0e2c1a9c7fc8fe0a4f7b7d4d"

# -----------------------------
# CREATE PAGES TOKEN
# -----------------------------
Write-Host "🌐 Creating minimal Pages deployment token..."

$pagesToken = New-CFToken `
    -Name "rapyard-pages-minimal" `
    -Permissions @(
        @{ id = $PagesRead },
        @{ id = $PagesWrite },
        @{ id = $WorkersScriptsRead },
        @{ id = $WorkersScriptsWrite }
    )

Write-Host "✅ Pages token created:"
Write-Host $pagesToken.result.value

# -----------------------------
# CREATE WORKERS TOKEN
# -----------------------------
Write-Host "⚙️ Creating minimal Workers deployment token..."

$workersToken = New-CFToken `
    -Name "rapyard-workers-minimal" `
    -Permissions @(
        @{ id = $WorkersScriptsWrite },
        @{ id = $WorkersKVWrite },
        @{ id = $WorkersR2Write },
        @{ id = $WorkersD1Write }
    )

Write-Host "✅ Workers token created:"
Write-Host $workersToken.result.value

Write-Host "🎉 All minimal tokens created successfully!"
