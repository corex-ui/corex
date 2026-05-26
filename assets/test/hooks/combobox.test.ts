import { describe, expect, it } from "vitest";
import {
  comboboxValueBinding,
  formatComboboxHiddenValue,
  selectedItemLabel,
  syncVisibleInputAttribute,
} from "../../hooks/combobox";
import { el } from "../helpers/dom";

describe("comboboxValueBinding", () => {
  it("returns value when controlled", () => {
    expect(comboboxValueBinding(el({ controlled: true, value: "a,b" }))).toEqual({
      value: ["a", "b"],
    });
  });

  it("returns defaultValue when uncontrolled", () => {
    expect(comboboxValueBinding(el({ defaultValue: "x" }))).toEqual({ defaultValue: ["x"] });
  });
});

describe("selectedItemLabel", () => {
  it("returns first item label", () => {
    expect(selectedItemLabel([{ label: "Alpha" }])).toBe("Alpha");
  });

  it("returns empty when no items", () => {
    expect(selectedItemLabel([])).toBe("");
  });
});

describe("formatComboboxHiddenValue", () => {
  it("returns single value", () => {
    expect(formatComboboxHiddenValue(el({}), ["eur"])).toBe("eur");
  });

  it("returns comma joined values when multiple", () => {
    expect(formatComboboxHiddenValue(el({ multiple: true }), ["a", "b"])).toBe("a,b");
  });

  it("returns empty string when no values", () => {
    expect(formatComboboxHiddenValue(el({}), [])).toBe("");
  });
});

describe("syncVisibleInputAttribute", () => {
  it("sets value attribute on visible input", () => {
    const root = document.createElement("div");
    root.innerHTML = `<input data-scope="combobox" data-part="input" />`;
    syncVisibleInputAttribute(root, "query");
    expect(root.querySelector("input")?.getAttribute("value")).toBe("query");
  });
});
