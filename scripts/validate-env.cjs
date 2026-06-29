const required = [
  "SUPABASE_URL",
  "SUPABASE_ANON_KEY",
  "SUPABASE_SERVICE_KEY",
  "FIREBASE_PROJECT_ID",
  "FIREBASE_ANDROID_APP_ID",
  "FIREBASE_TOKEN"
];

let missing = [];

for (const key of required) {
  if (!process.env[key]) missing.push(key);
}

if (missing.length) {
  console.log("❌ Missing environment variables:");
  missing.forEach(v => console.log(" -", v));
  process.exit(1);
}

console.log("✔ Environment OK");
