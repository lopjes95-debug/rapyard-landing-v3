import { createFolders } from "./create-folders.js";
import { createFiles } from "./create-files.js";
import { seedBoilerplates } from "./seed-boilerplates.js";
import { initializeGit } from "./init-git.js";
import { runSupabaseMigrations } from "../migrate/supabase-migrate.js";
import { deployCloudflare } from "../deploy/deploy-cloudflare.js";

const args = process.argv.slice(2);
const withDeploy = args.includes("--deploy");
const withMigrate = args.includes("--migrate");

async function main() {
  console.log("🔧 RapYard Bootstrap Starting…");

  await createFolders();
  await createFiles();
  await seedBoilerplates();
  await initializeGit();

  if (withMigrate) {
    await runSupabaseMigrations();
  }

  if (withDeploy) {
    await deployCloudflare();
  }

  console.log("🚀 RapYard Bootstrap Complete.");
}

main();

