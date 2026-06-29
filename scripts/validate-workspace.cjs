const fs = require("fs");

const root = JSON.parse(fs.readFileSync("package.json", "utf8"));
const workspaces = root.workspaces || [];

if (!workspaces.length) {
  console.log("❌ No workspaces defined");
  process.exit(1);
}

console.log("✔ Workspaces OK");
