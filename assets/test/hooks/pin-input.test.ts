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
  it("returns empty when uncontrolled including form field", () => {
    const node = el({ formField: true, defaultValue: '["3"]', count: 4 });
    expect(readUpdatedPinValue(node, 4)).toEqual({});
  });

  it("returns empty patch when neither controlled nor value dataset", () => {
    expect(readUpdatedPinValue(el({ count: 4 }), 4)).toEqual({});
  });
});

describe("readPinValueList", () => {
  it("reads value dataset key", () => {
    const node = el({ value: '["a","b"]', count: 3 });
    expect(readPinValueList(node, "value", 3)).toEqual(["a", "b", ""]);
  });
});
