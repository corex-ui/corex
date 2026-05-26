import { describe, expect, it } from "vitest";
import * as hookModule from "../../hooks/tabs";
import type { ValueChangeDetails } from "@zag-js/tabs";
import { tabsFocusChangePayload, tabsValueChangePayload } from "../../hooks/tabs";
import { expectHookModule } from "../helpers/expect-hook";

describe("tabs hook module", () => {
  it("exports lifecycle hook", () => {
    expectHookModule(hookModule);
  });
});

describe("tabsValueChangePayload", () => {
  it("maps tab value", () => {
    const el = document.createElement("div");
    el.id = "tabs";
    expect(tabsValueChangePayload(el, { value: "home" })).toEqual({ id: "tabs", value: "home" });
  });

  it("maps missing value to null", () => {
    const el = document.createElement("div");
    el.id = "tabs";
    expect(
      tabsValueChangePayload(el, { value: undefined } as unknown as ValueChangeDetails)
    ).toEqual({ id: "tabs", value: null });
  });
});

describe("tabsFocusChangePayload", () => {
  it("maps focused tab value", () => {
    const el = document.createElement("div");
    el.id = "tabs";
    expect(tabsFocusChangePayload(el, { focusedValue: "profile" })).toEqual({
      id: "tabs",
      value: "profile",
    });
  });
});
