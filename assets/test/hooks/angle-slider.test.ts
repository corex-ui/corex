import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/angle-slider";
import { valueChangePayload } from "../../hooks/angle-slider";
import { expectHookModule } from "../helpers/expect-hook";

describe("angle-slider hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("valueChangePayload", () => {
  it("includes angle value", () => {
    const el = document.createElement("div");
    el.id = "as";
    expect(valueChangePayload(el, { value: 45, valueAsDegree: "45" })).toEqual({
      id: "as",
      value: 45,
      valueAsDegree: "45",
    });
  });
});
