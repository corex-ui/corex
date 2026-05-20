import { describe, expect, it } from "vitest";
import { findHookExport } from "../helpers/expect-hook";

const skip = new Set(["hooks.ts", "lazy-hook.ts", "corex.ts", "components.d.ts"]);

const loaders = import.meta.glob<Record<string, unknown>>("../../hooks/*.ts", { eager: true });

describe("hook modules", () => {
  for (const [path, mod] of Object.entries(loaders)) {
    const name = path.replace("../../hooks/", "");
    if (skip.has(name) || name.endsWith(".test.ts")) continue;

    it(`${name} exports a hook with lifecycle methods`, () => {
      expect(findHookExport(mod)).toBeDefined();
    });
  }
});
