import { execSync } from "child_process";
import path from "path";

const root = process.cwd();
const supabaseDir = path.join(root, "apps", "api", "supabase");

export async function runSupabaseMigrations() {
  console.log("🟢 Running Supabase migrations…");

  try {
    execSync(`supabase db push`, {
      cwd: supabaseDir,
      stdio: "inherit",
    });
    console.log("✅ Supabase migrations applied.");
  } catch (err) {
    console.error("❌ Supabase migration failed.");
    process.exit(1);
  }
}
