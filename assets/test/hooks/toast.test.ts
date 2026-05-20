import { describe, expect, it } from "vitest";
import { parseActionSpec } from "../../hooks/toast";

describe("parseActionSpec", () => {
  it("parses valid exec_js action", () => {
    expect(
      parseActionSpec({
        label: "Undo",
        effects: [{ kind: "exec_js", encoded: "abc" }],
      })
    ).toEqual({ label: "Undo", encoded: "abc" });
  });

  it("includes className when present", () => {
    expect(
      parseActionSpec({
        label: "Go",
        class: " button--sm ",
        effects: [{ kind: "exec_js", encoded: "x" }],
      })
    ).toEqual({ label: "Go", encoded: "x", className: "button--sm" });
  });

  it("returns null for invalid shape", () => {
    expect(parseActionSpec(null)).toBeNull();
    expect(parseActionSpec({ label: "" })).toBeNull();
    expect(parseActionSpec({ label: "X", effects: [] })).toBeNull();
    expect(parseActionSpec({ label: "X", effects: [{ kind: "other", encoded: "x" }] })).toBeNull();
  });
});
