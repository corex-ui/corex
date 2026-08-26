import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/slider";
import { coerceSliderValues, valueChangePayload } from "../../hooks/slider";
import { expectHookModule } from "../helpers/expect-hook";

describe("slider hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("valueChangePayload", () => {
  it("includes the value list", () => {
    const el = document.createElement("div");
    el.id = "vol";
    expect(valueChangePayload(el, { value: [20, 80] })).toEqual({
      id: "vol",
      value: [20, 80],
    });
  });
});

describe("coerceSliderValues", () => {
  it("wraps a number", () => {
    expect(coerceSliderValues(50)).toEqual([50]);
  });

  it("keeps a number list", () => {
    expect(coerceSliderValues([20, 80])).toEqual([20, 80]);
  });

  it("parses a JSON list string", () => {
    expect(coerceSliderValues("[10,90]")).toEqual([10, 90]);
  });
});
