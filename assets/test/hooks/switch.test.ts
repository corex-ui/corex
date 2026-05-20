import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/switch";
import { checkedChangePayload } from "../../hooks/switch";
import { expectHookModule } from "../helpers/expect-hook";

describe("switch hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("checkedChangePayload", () => {
  it("includes element id and checked state", () => {
    const el = document.createElement("div");
    el.id = "sw";
    expect(checkedChangePayload(el, { checked: true })).toEqual({ id: "sw", checked: true });
  });
});
