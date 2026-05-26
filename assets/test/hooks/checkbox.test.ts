import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/checkbox";
import { checkedChangePayload } from "../../hooks/checkbox";
import { expectHookModule } from "../helpers/expect-hook";

describe("checkbox hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("checkedChangePayload", () => {
  it.each([
    [true, true],
    [false, false],
  ] as const)("%#", (checked, expected) => {
    const el = document.createElement("div");
    el.id = "cb-1";
    expect(checkedChangePayload(el, { checked })).toEqual({ id: "cb-1", checked: expected });
  });
});
