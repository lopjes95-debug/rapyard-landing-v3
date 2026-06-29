cd C:\dev\rapyard\apps\admin

pnpm install
if ($LASTEXITCODE -ne 0) { exit 1 }

pnpm run build
if ($LASTEXITCODE -ne 0) { exit 1 }

wrangler pages deploy dist --project-name rapyard