import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { padToCount, parseValueWithEmpties, readDefaultValueList } from "../../hooks/pin-input";

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
});
