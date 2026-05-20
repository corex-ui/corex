import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/toggle-group";
import { readToggleGroupPayloadValue, valueChangePayload } from "../../hooks/toggle-group";
import { expectHookModule } from "../helpers/expect-hook";

describe("toggle-group hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("valueChangePayload", () => {
  it("includes string array value", () => {
    const el = document.createElement("div");
    el.id = "tgr";
    expect(valueChangePayload(el, { value: ["a", "b"] })).toEqual({
      id: "tgr",
      value: ["a", "b"],
    });
  });
});

describe("readToggleGroupPayloadValue", () => {
  it.each([
    [{ value: ["x"] }, ["x"]],
    [{ value: "x" }, undefined],
    [null, undefined],
  ] as const)("%#", (payload, expected) => {
    expect(readToggleGroupPayloadValue(payload)).toEqual(expected);
  });
});
