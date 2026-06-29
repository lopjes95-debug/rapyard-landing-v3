export const json = (data: unknown, init: ResponseInit = {}) =>
  new Response(JSON.stringify(data), {
    headers: { "Content-Type": "application/json" },
    ...init,
  })

export const error = (message: string, status = 400) =>
  json({ error: message }, { status })
