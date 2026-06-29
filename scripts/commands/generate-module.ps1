param([string]$Name)

if (-not $Name) {
    Write-Host "❌ Missing module name."
    exit
}

$base = "plugins/$Name"
New-Item -ItemType Directory -Path $base -Force | Out-Null

Set-Content "$base/README.md" "# Module: $Name`n`nTODO: Describe module."

New-Item -ItemType Directory -Path "$base/components" -Force | Out-Null
New-Item -ItemType Directory -Path "$base/api" -Force | Out-Null
New-Item -ItemType Directory -Path "$base/types" -Force | Out-Null

Set-Content "$base/components/$Name.tsx" "export default function $Name() { return <div>$Name module</div>; }"

Set-Content "$base/api/route.ts" "import { NextResponse } from 'next/server'; export async function POST() { return NextResponse.json({ ok: true }); }"

Set-Content "$base/types/$Name.ts" "export interface ${Name}Type { id: string; createdAt: string; }"

Write-Host "🚀 Module '$Name' generated."
