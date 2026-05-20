import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/color-picker";
import { readValueProps } from "../../hooks/color-picker";
import { el } from "../helpers/dom";
import { expectHookModule } from "../helpers/expect-hook";

describe("color-picker hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("readValueProps", () => {
  it("parses hex defaultValue", () => {
    const props = readValueProps(el({ defaultValue: "#ff00ff" }));
    expect(props.defaultValue?.toString("hex")).toBe("#FF00FF");
  });

  it("returns undefined without defaultValue", () => {
    expect(readValueProps(el({})).defaultValue).toBeUndefined();
  });
});
