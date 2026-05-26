import { describe, expect, it } from "vitest";
import { Hooks } from "../../hooks/corex";

describe("Hooks registry", () => {
  it("exports named hook entries", () => {
    expect(typeof Hooks).toBe("object");
    expect(Object.keys(Hooks).length).toBeGreaterThan(0);
  });
});
