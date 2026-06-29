export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname === "/api/tasks" && request.method === "GET") {
      return Response.json({
        success: true,
        tasks: []
      });
    }

    return new Response("Not found", { status: 404 });
  }
};
