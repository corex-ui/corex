import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/radio-group";
import { valueChangePayload } from "../../hooks/radio-group";
import { expectHookModule } from "../helpers/expect-hook";

describe("radio-group hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("valueChangePayload", () => {
  it("includes selected value", () => {
    const el = document.createElement("div");
    el.id = "rg";
    expect(valueChangePayload(el, { value: "opt-a" })).toEqual({
      id: "rg",
      value: "opt-a",
    });
  });
});
