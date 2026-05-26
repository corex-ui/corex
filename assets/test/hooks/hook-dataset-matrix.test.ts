import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { mutableArray } from "../helpers/matrix";
import { comboboxValueBinding } from "../../hooks/combobox";
import { resolveCloseOnSelect, valueToIsoString } from "../../hooks/date-picker";
import { parseJsonTags, blurBehavior, maxProp } from "../../hooks/tags-input";
import { padToCount, parseValueWithEmpties, readDefaultValueList } from "../../hooks/pin-input";
import { readPayloadPage, readPayloadPageSize } from "../../hooks/pagination";
import { toZagPage, fromZagPage, readCorexPage } from "../../hooks/carousel";

describe("comboboxValueBinding matrix", () => {
  it.each([
    [{ controlled: true, value: "a,b" }, "value"],
    [{ defaultValue: "x,y" }, "defaultValue"],
  ] as const)("%#", (dataset, key) => {
    const result = comboboxValueBinding(el(dataset as Record<string, string>));
    expect(key in result).toBe(true);
  });
});

describe("date-picker hook parsers", () => {
  it.each([
    [null, ""],
    ["2024-06-01", "2024-06-01"],
    [{ year: 2024, month: 6, day: 1 }, "2024-06-01"],
    [0, "0"],
  ] as const)("valueToIsoString %#", (input, expected) => {
    expect(valueToIsoString(input)).toBe(expected);
  });

  it.each([
    [{ closeOnSelect: true }, true],
    [{}, false],
  ] as const)("resolveCloseOnSelect %#", (dataset, expected) => {
    expect(resolveCloseOnSelect(el(dataset as Record<string, boolean>))).toBe(expected);
  });
});

describe("tags-input hook parsers", () => {
  it.each([
    ['["a","b"]', ["a", "b"]],
    ["invalid", []],
  ] as const)("parseJsonTags %#", (raw, expected) => {
    const node = document.createElement("div");
    node.dataset.tags = raw;
    expect(parseJsonTags(node, "tags")).toEqual(expected);
  });

  it.each([
    [{ blurBehavior: "add" }, "add"],
    [{ blurBehavior: "clear" }, "clear"],
    [{}, undefined],
  ] as const)("blurBehavior %#", (dataset, expected) => {
    expect(blurBehavior(el(dataset as Record<string, string>))).toBe(expected);
  });

  it.each([
    [{ max: 5 }, 5],
    [{ max: 0 }, undefined],
    [{ max: -1 }, undefined],
  ] as const)("maxProp %#", (dataset, expected) => {
    expect(maxProp(el(dataset as Record<string, number>))).toBe(expected);
  });
});

describe("pin-input hook parsers", () => {
  it.each([
    ["1, 2, 3", ["1", "2", "3"]],
    ["", [""]],
  ] as const)("parseValueWithEmpties %#", (raw, expected) => {
    expect(parseValueWithEmpties(raw)).toEqual(expected);
  });

  it.each([
    [["a"], 3, ["a", "", ""]],
    [[], 2, ["", ""]],
  ] as const)("padToCount %#", (arr, count, expected) => {
    expect(padToCount(mutableArray(arr), count)).toEqual(expected);
  });

  it("readDefaultValueList pads to count", () => {
    const node = el({ defaultValue: "1,2", count: 4 });
    expect(readDefaultValueList(node, 4)).toEqual(["1", "2", "", ""]);
  });
});

describe("pagination payload readers", () => {
  it.each([
    [{ page: 1 }, 1],
    [{ page: "1" }, undefined],
  ] as const)("readPayloadPage %#", (payload, expected) => {
    expect(readPayloadPage(payload)).toBe(expected);
  });

  it.each([
    [{ page_size: 20 }, 20],
    [{ pageSize: 15 }, 15],
  ] as const)("readPayloadPageSize %#", (payload, expected) => {
    expect(readPayloadPageSize(payload)).toBe(expected);
  });
});

describe("readCorexPage matrix", () => {
  it.each([
    [{ page: 5 }, "page", 4],
    [{ defaultPage: 1 }, "defaultPage", 0],
  ] as const)("%#", (dataset, attr, zag) => {
    expect(readCorexPage(el(dataset as Record<string, number>), attr)).toBe(zag);
  });
});

describe("carousel page matrix", () => {
  it.each([
    [1, 0],
    [2, 1],
    [0, 0],
    [undefined, undefined],
  ] as const)("toZagPage %#", (page, zag) => {
    expect(toZagPage(page)).toBe(zag);
  });

  it.each([0, 1, 4] as const)("fromZagPage roundtrip %#", (zag) => {
    expect(fromZagPage(zag)).toBe(zag + 1);
  });
});
