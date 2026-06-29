const fs = require("fs");
const path = require("path");

const ROOT = process.cwd();
const structure = JSON.parse(fs.readFileSync("scripts/structure.json", "utf8"));

function ensure(base, obj) {
  for (const key of Object.keys(obj)) {
    const target = path.join(base, key);
    const value = obj[key];

    if (typeof value === "object") {
      if (!fs.existsSync(target)) {
        console.log("[CREATE FOLDER]", target);
        fs.mkdirSync(target, { recursive: true });
      }
      ensure(target, value);
    }

    if (typeof value === "string") {
      if (!fs.existsSync(target)) {
        console.log("[CREATE FILE]", target);
        fs.writeFileSync(target, value);
      } else {
        const existing = fs.readFileSync(target, "utf8");
        if (existing.trim() !== value.trim()) {
          console.log("[RESTORE BOILERPLATE]", target);
          fs.writeFileSync(target, value);
        }
      }
    }
  }
}

console.log("=== RAPYARD STRUCTURE SYNC ===");
ensure(ROOT, structure);
console.log("=== COMPLETE ===");
