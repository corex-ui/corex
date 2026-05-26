import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { readFlipAttr, readPositioningOptions } from "../../lib/positioning";

describe.each([
  [{ positionFlip: "true" }, true],
  [{ positionFlip: "false" }, false],
  [{ positionFlip: "top, bottom" }, ["top", "bottom"]],
  [{}, undefined],
] as const)("readFlipAttr", (dataset, expected) => {
  it("reads flip", () => {
    expect(readFlipAttr(el(dataset as Record<string, string>))).toEqual(expected);
  });
});

describe.each([
  [
    {
      positionStrategy: "fixed",
      positionPlacement: "bottom",
      positionGutter: 8,
      positionShift: 4,
      positionFlip: "true",
      positionSlide: "true",
    },
    true,
  ],
  [{ positionPlacement: "top-start" }, true],
  [{}, false],
] as const)("readPositioningOptions", (dataset, hasOptions) => {
  it(hasOptions ? "builds options" : "returns undefined", () => {
    const opts = readPositioningOptions(el(dataset as Record<string, string>));
    if (hasOptions) {
      expect(opts).toBeDefined();
      expect(opts?.placement).toBeDefined();
    } else {
      expect(opts).toBeUndefined();
    }
  });
});
