import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import {
  padToCount,
  parseValueWithEmpties,
  readDefaultValueList,
  readPinValueList,
  readUpdatedPinValue,
} from "../../hooks/pin-input";

describe("parseValueWithEmpties", () => {
  it("splits comma-separated values", () => {
    expect(parseValueWithEmpties("1, 2 ,3")).toEqual(["1", "2", "3"]);
  });
});

describe("padToCount", () => {
  it("pads with empty strings", () => {
    expect(padToCount(["a"], 3)).toEqual(["a", "", ""]);
  });
});

describe("readDefaultValueList", () => {
  it("reads default value list from dataset", () => {
    const node = el({ defaultValue: "1,2", count: 4 });
    expect(readDefaultValueList(node, 4)).toEqual(["1", "2", "", ""]);
  });

  it("reads JSON default value list", () => {
    const node = el({ defaultValue: '["1","2"]', count: 4 });
    expect(readDefaultValueList(node, 4)).toEqual(["1", "2", "", ""]);
  });
});

describe("readUpdatedPinValue", () => {
  it("returns value from data-value when controlled", () => {
    const node = el({ controlled: true, value: '["1","2"]', count: 4 });
    expect(readUpdatedPinValue(node, 4)).toEqual({ value: ["1", "2", "", ""] });
  });

  it("returns value from data-value when form field", () => {
    const node = el({ formField: true, value: '["3"]', count: 4 });
    expect(readUpdatedPinValue(node, 4)).toEqual({ value: ["3", "", "", ""] });
  });

  it("returns empty patch when neither", () => {
    expect(readUpdatedPinValue(el({ count: 4 }), 4)).toEqual({});
  });

  it("never returns defaultValue in patch", () => {
    const node = el({ formField: true, value: '["a"]', count: 2 });
    const patch = readUpdatedPinValue(node, 2);
    expect(patch).not.toHaveProperty("defaultValue");
    expect(patch).toHaveProperty("value");
  });
});

describe("readPinValueList", () => {
  it("reads value dataset key", () => {
    const node = el({ value: '["a","b"]', count: 3 });
    expect(readPinValueList(node, "value", 3)).toEqual(["a", "b", ""]);
  });
});
