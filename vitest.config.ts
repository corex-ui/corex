import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    environment: "happy-dom",
    include: ["assets/**/*.test.ts"],
    exclude: ["node_modules", "priv", "e2e"],
  },
});
