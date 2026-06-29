const fs = require("fs");

const ts = JSON.parse(fs.readFileSync("tsconfig.json", "utf8"));

if (!ts.references || !ts.compilerOptions) {
  console.log("❌ Invalid TSConfig");
  process.exit(1);
}

console.log("✔ TSConfig OK");
