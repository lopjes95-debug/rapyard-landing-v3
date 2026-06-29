#!/usr/bin/env node
import fs from "fs";
import path from "path";
import glob from "glob";

type WorkspaceConfig = {
  packages: string[];
};

const ROOT = process.cwd();

function readWorkspaceConfig(): WorkspaceConfig {
  const file = path.join(ROOT, "pnpm-workspace.yaml");
  if (!fs.existsSync(file)) {
    throw new Error("pnpm-workspace.yaml not found at repo root");
  }
  const raw = fs.readFileSync(file, "utf8");
  const match = raw.match(/packages:\s*([\s\S]+)/);
  if (!match) throw new Error("Invalid pnpm-workspace.yaml: no packages section");

  const lines = match[1]
    .split("\n")
    .map((l) => l.trim())
    .filter((l) => l.startsWith("-"));

  const packages = lines.map((l) => l.replace(/^-+\s*/, "").replace(/["']/g, ""));
  return { packages };
}

function expandPatterns(patterns: string[]): string[] {
  const results = new Set<string>();
  for (const pattern of patterns) {
    const matches = glob.sync(pattern, {
      cwd: ROOT,
      absolute: false,
    });
    for (const m of matches) {
      // only keep dirs with package.json
      const pkgJson = path.join(ROOT, m, "package.json");
      if (fs.existsSync(pkgJson)) results.add(m);
    }
  }
  return Array.from(results).sort();
}

function findActualPackages(): string[] {
  const all = glob.sync("**/package.json", {
    cwd: ROOT,
    absolute: false,
    ignore: ["**/node_modules/**"],
  });
  return all
    .map((p) => path.dirname(p))
    .filter((dir) => !dir.startsWith("node_modules"))
    .sort();
}

function main() {
  const workspace = readWorkspaceConfig();
  const expected = expandPatterns(workspace.packages);
  const actual = findActualPackages();

  const expectedSet = new Set(expected);
  const actualSet = new Set(actual);

  const missing: string[] = [];
  const extra: string[] = [];

  for (const dir of actual) {
    if (!expectedSet.has(dir)) extra.push(dir);
  }
  for (const dir of expected) {
    if (!actualSet.has(dir)) missing.push(dir);
  }

  if (!missing.length && !extra.length) {
    console.log("✅ Workspace is clean. No drift detected.");
    process.exit(0);
  }

  console.log("⚠️ Workspace drift detected:");
  if (missing.length) {
    console.log("\nMissing (declared in pnpm-workspace.yaml but no package.json):");
    for (const m of missing) console.log(`  - ${m}`);
  }
  if (extra.length) {
    console.log("\nExtra (has package.json but not in pnpm-workspace.yaml):");
    for (const e of extra) console.log(`  - ${e}`);
  }

  process.exit(1);
}

main();
