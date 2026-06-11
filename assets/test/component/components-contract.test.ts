import { describe, expect, it } from "vitest";

const loaders = import.meta.glob<Record<string, unknown>>("../../components/*.ts", {
  eager: false,
});

describe("component modules", () => {
  for (const [path, load] of Object.entries(loaders)) {
    if (
      path.includes(".test.ts") ||
      path.includes("components-contract") ||
      path.endsWith("-connect.ts")
    )
      continue;

    it(`${path.replace("../../components/", "")} exports a Component subclass`, async () => {
      const mod = await load();
      const exported = Object.values(mod).filter(
        (v) => typeof v === "function" && v.prototype && "initMachine" in v.prototype
      );
      expect(exported.length).toBeGreaterThan(0);
    });
  }
});
