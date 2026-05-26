import { describe, expect, it } from "vitest";
import { el } from "../helpers/dom";
import { buildAnchorProps, parsePoint, parseSize } from "../../hooks/floating-panel";

describe("parseSize", () => {
  it("parses JSON size", () => {
    expect(parseSize('{"width":100,"height":200}')).toEqual({ width: 100, height: 200 });
  });

  it("returns undefined for invalid JSON", () => {
    expect(parseSize("bad")).toBeUndefined();
  });
});

describe("parsePoint", () => {
  it("parses JSON point", () => {
    expect(parsePoint('{"x":10,"y":20}')).toEqual({ x: 10, y: 20 });
  });
});

describe("buildAnchorProps", () => {
  it("uses default size when dataset missing", () => {
    const props = buildAnchorProps(el({}));
    expect(props.defaultPosition).toBeUndefined();
  });

  it("reads default position from dataset", () => {
    const node = el({});
    node.dataset.defaultPosition = '{"x":1,"y":2}';
    expect(buildAnchorProps(node).defaultPosition).toEqual({ x: 1, y: 2 });
  });
});
