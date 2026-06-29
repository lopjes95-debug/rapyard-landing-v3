import { execSync } from "child_process";

export async function initializeGit() {
  console.log("🔨 Initializing Git…");

  execSync("git init", { stdio: "inherit" });
  execSync("git add .", { stdio: "inherit" });
  execSync(`git commit -m "Bootstrap: Initialize RapYard monorepo"`, { stdio: "inherit" });

  console.log("📦 Git repo initialized.");
}
