export function proxy(req) {
  return fetch("http://localhost:3000", req);
}
