import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { resolveCloseOnSelect, valueToIsoString } from "../../hooks/date-picker";

describe("valueToIsoString", () => {
  it("returns empty for null", () => {
    expect(valueToIsoString(null)).toBe("");
  });

  it("stringifies values", () => {
    expect(valueToIsoString("2024-01-01")).toBe("2024-01-01");
  });
});

describe("resolveCloseOnSelect", () => {
  it("reads closeOnSelect boolean", () => {
    expect(resolveCloseOnSelect(el({ closeOnSelect: true }))).toBe(true);
    expect(resolveCloseOnSelect(el({}))).toBe(false);
  });
});
