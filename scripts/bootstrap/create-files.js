import fs from "fs";
import path from "path";

const files = [
  "apps/web/app/layout.tsx",
  "apps/web/app/page.tsx",
  "apps/web/app/globals.css",
  "apps/web/app/auth/callback/route.ts",
  "apps/web/lib/supabase/client.ts",
  "apps/web/lib/supabase/server.ts",
  "apps/web/next.config.js",
  "apps/web/package.json",
  "apps/web/tsconfig.json",
  "apps/api/functions/auth/index.ts",
  "apps/api/functions/profiles/index.ts",
  "apps/api/functions/battles/index.ts",
  "apps/workers/src/index.ts",
  "apps/workers/src/router.ts",
  "apps/workers/src/handlers/health.ts",
  "apps/workers/src/handlers/proxy.ts",
  "packages/ui/components/index.ts",
  "packages/ui/package.json",
  "packages/utils/index.ts",
  "infra/supabase/config.toml",
  "infra/cloudflare/workers.tf",
  "infra/aws/s3.tf",
  "turbo.json",
  ".gitignore"
];

export async function createFiles() {
  files.forEach((file) => {
    const full = path.join(process.cwd(), file);
    if (!fs.existsSync(full)) {
      fs.writeFileSync(full, "");
      console.log("📄 Created:", file);
    }
  });
}
