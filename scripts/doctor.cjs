const fs = require("fs");
const path = require("path");

const structure = JSON.parse(fs.readFileSync("scripts/structure.json", "utf8"));

function check(base, obj, errors) {
  for (const key of Object.keys(obj)) {
    const target = path.join(base, key);
    const value = obj[key];

    if (typeof value === "object") {
      if (!fs.existsSync(target)) {
        errors.push(`Missing folder: ${target}`);
      } else {
        check(target, value, errors);
      }
    }

    if (typeof value === "string") {
      if (!fs.existsSync(target)) {
        errors.push(`Missing file: ${target}`);
      }
    }
  }
}

console.log("=== RapYard Doctor ===");

const errors = [];
check(process.cwd(), structure, errors);

if (errors.length === 0) {
  console.log("✔ All structure checks passed");
  process.exit(0);
}

console.log("❌ Issues found:");
errors.forEach(e => console.log(" -", e));
process.exit(1);
