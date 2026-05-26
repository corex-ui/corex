import { expect } from "vitest";

export function findHookExport(mod: unknown): object | undefined {
  if (!mod || typeof mod !== "object") return undefined;
  return Object.values(mod as Record<string, unknown>).find(
    (v) => v && typeof v === "object" && ("mounted" in v || "updated" in v || "destroyed" in v)
  ) as object | undefined;
}

export function expectHookModule(mod: unknown): void {
  expect(findHookExport(mod)).toBeDefined();
}
