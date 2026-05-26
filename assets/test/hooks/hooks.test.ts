import { describe, expect, it, vi } from "vitest";
import { hooks } from "../../hooks/hooks";

describe("hooks", () => {
  it("wraps lazy factory entries", async () => {
    const factory = vi.fn(async () => ({
      Demo: {
        mounted() {},
        destroyed() {},
      },
    }));
    const result = hooks({ Demo: factory });
    expect(typeof result.Demo).toBe("object");
    expect(result.Demo).toHaveProperty("mounted");
  });

  it("returns direct hooks unchanged", () => {
    const direct = { mounted() {}, destroyed() {} };
    const result = hooks({ Direct: direct });
    expect(result.Direct).toBe(direct);
  });
});
