import fs from "fs";
import path from "path";

function write(file, content) {
  fs.writeFileSync(path.join(process.cwd(), file), content.trim() + "\n");
  console.log("✍️  Seeded:", file);
}

export async function seedBoilerplates() {

  write("apps/web/app/layout.tsx", `
import "./globals.css";

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
  `);

  write("apps/web/app/page.tsx", `
export default function Home() {
  return <h1>RapYard Landing Page</h1>;
}
  `);

  write("apps/web/app/auth/callback/route.ts", `
import { NextResponse } from "next/server";
import { createServer } from "@/lib/supabase/server";

export async function GET() {
  const supabase = createServer();
  await supabase.auth.exchangeCodeForSession();
  return NextResponse.redirect("/dashboard");
}
  `);

  write("apps/web/lib/supabase/client.ts", `
import { createBrowserClient } from "@supabase/ssr";

export const createClient = () =>
  createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!
  );
  `);

  write("apps/web/lib/supabase/server.ts", `
import { cookies } from "next/headers";
import { createServerClient } from "@supabase/ssr";

export const createServer = () =>
  createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
    { cookies }
  );
  `);

  write("apps/workers/src/index.ts", `
import { router } from "./router";

export default {
  fetch: (req, env, ctx) => router.handle(req, env, ctx),
};
  `);

  write("apps/workers/src/router.ts", `
import { health } from "./handlers/health";
import { proxy } from "./handlers/proxy";

export const router = {
  async handle(req) {
    const url = new URL(req.url);
    if (url.pathname === "/health") return health();
    return proxy(req);
  },
};
  `);

  write("apps/workers/src/handlers/health.ts", `
export function health() {
  return new Response("OK", { status: 200 });
}
  `);

  write("apps/workers/src/handlers/proxy.ts", `
export function proxy(req) {
  return fetch("http://localhost:3000", req);
}
  `);

  write(".gitignore", `
node_modules
.env
.env.local
.next
dist
  `);

  write("turbo.json", `
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": { "dependsOn": ["^build"], "outputs": ["dist/**"] },
    "dev": { "cache": false }
  }
}
  `);
}
