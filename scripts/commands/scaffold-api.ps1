param([string]$Name)

if (-not $Name) {
    Write-Host "❌ Missing API name."
    exit
}

$apiDir = "app/api/$Name"
$svcDir = "services/$Name"
$typeDir = "types/modules"

New-Item -ItemType Directory -Path $apiDir -Force | Out-Null
New-Item -ItemType Directory -Path $svcDir -Force | Out-Null
New-Item -ItemType Directory -Path $typeDir -Force | Out-Null

Set-Content "$apiDir/route.ts" "import { NextResponse } from 'next/server'; export async function POST(req: Request) { return NextResponse.json({ ok: true }); }"

Set-Content "$svcDir/index.ts" "export async function ${Name}Service() { return {}; }"

Set-Content "$typeDir/$Name.ts" "export interface ${Name} { id: string; createdAt: string; }"

Write-Host "🛠️ API '$Name' scaffolded."
