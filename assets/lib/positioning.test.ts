import { describe, expect, it } from "vitest";
import { el } from "../test/helpers/dom";
import { readFlipAttr, readPositioningOptions } from "./positioning";

describe("readFlipAttr", () => {
  it("returns true for position-flip=true", () => {
    const node = document.createElement("div");
    node.setAttribute("data-position-flip", "true");
    expect(readFlipAttr(node)).toBe(true);
  });

  it("returns false for position-flip=false", () => {
    const node = document.createElement("div");
    node.setAttribute("data-position-flip", "false");
    expect(readFlipAttr(node)).toBe(false);
  });

  it("returns placement list for comma-separated values", () => {
    const node = document.createElement("div");
    node.setAttribute("data-position-flip", "top, bottom");
    expect(readFlipAttr(node)).toEqual(["top", "bottom"]);
  });
});

describe("readPositioningOptions", () => {
  it("builds options from data attributes", () => {
    const node = el({
      positionPlacement: "bottom-start",
      positionGutter: 8,
    });
    expect(readPositioningOptions(node)).toEqual({
      placement: "bottom-start",
      gutter: 8,
    });
  });

  it("returns undefined when no positioning attrs", () => {
    expect(readPositioningOptions(el({}))).toBeUndefined();
  });
});
