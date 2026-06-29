import { health } from "./handlers/health";
import { proxy } from "./handlers/proxy";

export const router = {
  async handle(req) {
    const url = new URL(req.url);
    if (url.pathname === "/health") return health();
    return proxy(req);
  },
};
