import { compare } from "bcryptjs";

export default {
  async fetch(request: Request, env: any) {
    const url = new URL(request.url);

    if (request.method === "POST" && url.pathname === "/login") {
      const { email, password } = await request.json();

      // Query user by email only
      const stmt = env.DB.prepare("SELECT * FROM users WHERE email = ?");
      const user = await stmt.bind(email).first();

      if (user) {
        const match = await compare(password, user.password); // bcrypt hash check
        if (match) {
          return new Response(JSON.stringify({ success: true }), { status: 200 });
        }
      }

      return new Response(JSON.stringify({ success: false }), { status: 401 });
    }

    return new Response("Not found", { status: 404 });
  }
};
