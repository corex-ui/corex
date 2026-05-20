import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/editable";
import { dataDefaultValue } from "../../hooks/editable";
import { el } from "../helpers/dom";
import { expectHookModule } from "../helpers/expect-hook";

describe("editable hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("dataDefaultValue", () => {
  it.each([
    [{ defaultValue: "draft" }, "draft"],
    [{}, ""],
  ] as const)("%#", (dataset, expected) => {
    expect(dataDefaultValue(el(dataset as Record<string, string>))).toBe(expected);
  });
});
