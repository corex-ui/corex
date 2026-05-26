import { describe, expect, it } from "vitest";
import {
  formatDisplayValue,
  formatOptionsFromStep,
  formatSubmitValue,
  fractionDigitsForStep,
  mergeFormatOptions,
} from "../../lib/number-input-format";

describe("number-input-format", () => {
  it("fractionDigitsForStep returns null for whole steps", () => {
    expect(fractionDigitsForStep(1)).toBeNull();
    expect(fractionDigitsForStep(5)).toBeNull();
  });

  it("fractionDigitsForStep counts fractional step decimals", () => {
    expect(fractionDigitsForStep(0.1)).toBe(1);
    expect(fractionDigitsForStep(0.01)).toBe(2);
    expect(fractionDigitsForStep(0.25)).toBe(2);
  });

  it("formatOptionsFromStep enables grouping for whole steps", () => {
    expect(formatOptionsFromStep(1)).toEqual({ useGrouping: true });
  });

  it("mergeFormatOptions matches formatOptionsFromStep", () => {
    expect(mergeFormatOptions(0.1)).toEqual(formatOptionsFromStep(0.1));
  });

  it("formatDisplayValue strips .0 for whole steps", () => {
    expect(formatDisplayValue(10.0, 1)).toBe("10");
    expect(formatDisplayValue("10.0", 1)).toBe("10");
  });

  it("formatDisplayValue keeps needed decimals for fractional steps", () => {
    expect(formatDisplayValue(10.5, 0.1)).toBe("10.5");
    expect(formatDisplayValue(10.55, 0.01)).toBe("10.55");
  });

  it("formatDisplayValue handles empty input", () => {
    expect(formatDisplayValue(undefined, 1)).toBe("");
    expect(formatDisplayValue("", 1)).toBe("");
  });

  it("formatDisplayValue adds en-US grouping", () => {
    expect(formatDisplayValue(1234.5, 0.1)).toBe("1,234.5");
    expect(formatDisplayValue(5000, 1)).toBe("5,000");
  });

  it("formatSubmitValue never adds grouping", () => {
    expect(formatSubmitValue(1234.5, 0.1)).toBe("1234.5");
    expect(formatSubmitValue(5000, 1)).toBe("5000");
    expect(formatSubmitValue("1,234.5", 0.1)).toBe("1234.5");
  });
});
