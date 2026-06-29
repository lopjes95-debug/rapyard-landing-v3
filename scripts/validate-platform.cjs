const fs = require("fs");

function check(file) {
  if (!fs.existsSync(file)) {
    console.log("❌ Missing:", file);
    process.exit(1);
  }
}

check("apps/mobile/app.json");
check("apps/mobile/android/app/google-services.json");
check("apps/mobile/ios/GoogleService-Info.plist");
check("supabase/config.toml");

console.log("✔ Platform configs OK");
