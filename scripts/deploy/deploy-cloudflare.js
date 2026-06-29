import { execSync } from "child_process";
import path from "path";

const root = process.cwd();
const workersDir = path.join(root, "apps", "workers");

export async function deployCloudflare() {
  console.log("🟠 Deploying Cloudflare Workers…");

  try {
    execSync(`npx wrangler deploy`, {
      cwd: workersDir,
      stdio: "inherit",
    });
    console.log("✅ Cloudflare Workers deployed.");
  } catch (err) {
    console.error("❌ Cloudflare deploy failed.");
    process.exit(1);
  }
}
