
const fs = require("fs");
const structure = JSON.parse(fs.readFileSync("scripts/structure.json", "utf8"));

function count(obj) {
  let folders = 0;
  let files = 0;

  for (const key of Object.keys(obj)) {
    if (typeof obj[key] === "object") {
      folders++;
      const sub = count(obj[key]);
      folders += sub.folders;
      files += sub.files;
    } else {
      files++;
    }
  }

  return { folders, files };
}

const { folders, files } = count(structure);

console.log("=== RapYard Structure Health ===");
console.log(`Folders expected: ${folders}`);
console.log(`Files expected:   ${files}`);
console.log("Run: pnpm doctor to validate");
