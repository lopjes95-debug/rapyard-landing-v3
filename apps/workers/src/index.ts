import { router } from "./router";

export default {
  fetch: (req, env, ctx) => router.handle(req, env, ctx),
};
