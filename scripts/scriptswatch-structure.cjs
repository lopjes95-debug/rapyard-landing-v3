const chokidar = require("chokidar");
const { exec } = require("child_process");

console.log("Watching for drift...");

chokidar.watch(".", {
  ignored: ["node_modules", ".git", ".turbo"],
  persistent: true
}).on("all", () => {
  exec("node scripts/create-missing-structure.cjs", () => {
    console.log("[SYNC] Structure repaired");
  });
});
