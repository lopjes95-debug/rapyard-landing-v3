import fs from "fs";
import path from "path";

const folders = [
  "apps/web/app",
  "apps/web/app/auth/sign-in",
  "apps/web/app/auth/sign-up",
  "apps/web/app/auth/callback",
  "apps/web/lib/supabase",
  "apps/web/components/ui",
  "apps/web/public/landing",
  "apps/api/functions/auth",
  "apps/api/functions/profiles",
  "apps/api/functions/battles",
  "apps/api/supabase/migrations",
  "apps/api/supabase/policies",
  "apps/workers/src/handlers",
  "packages/ui/components",
  "packages/ui/styles",
  "packages/utils",
  "infra/supabase",
  "infra/cloudflare",
  "infra/aws",
  "config/eslint",
  "config/prettier",
  "config/ts",
  "config/env"
];

export async function createFolders() {
  folders.forEach((folder) => {
    const full = path.join(process.cwd(), folder);
    if (!fs.existsSync(full)) {
      fs.mkdirSync(full, { recursive: true });
      console.log("📁 Created:", folder);
    }
  });
}
