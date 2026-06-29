const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization"
}

export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url)

    // CORS preflight
    if (request.method === "OPTIONS") {
      return new Response(null, { headers: corsHeaders })
    }

    // /status endpoint
    if (url.pathname === "/status") {
      return Response.json(
        {
          ok: true,
          service: "rapyard-api",
          time: new Date().toISOString(),
          uptime: "online"
        },
        { headers: corsHeaders }
      )
    }

    // /time endpoint
    if (url.pathname === "/time") {
      return Response.json(
        { now: new Date().toISOString() },
        { headers: corsHeaders }
      )
    }

    // Root endpoint
    if (url.pathname === "/") {
      return Response.json(
        { status: "ok", service: "rapyard-api" },
        { headers: corsHeaders }
      )
    }

    return new Response("Not found", {
      status: 404,
      headers: corsHeaders
    })
  }
}
